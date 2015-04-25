/*
   IMPORT AND CONSTANTS
*/
functor
import

System(show:Show)
Module
Open
CutImages(moveHero:MoveHero face:Face)
QTk at 'x-oz://system/wp/QTk.ozf'

export
HeroHandle SquareLengthFloat

define
																/* CONSTANTS */
SQUARE_LENGTH = 34 % length of a standard square
SquareLengthFloat = {IntToFloat SQUARE_LENGTH}

																/* GLOBAL_VARIABLES */
%Key_positions
StartX 
StartY

%Canvas
CanvasHandler 
Window

%Map_variables
MapFile		%The map.txt file to read
MapRecord	%Record 
MapParsed	%List readed from map.txt

%Hero_variables
HeroHandle	%The Hero handler
HeroTag		%The Hero Canvas Tag

																/* FUNCTIONS */

/*
* pre: a no-nul list starting with the first case of the map.
* result: return a list of rows lists -> [row1 row2 row3..]
*/						
fun {MakeRow List}
   case List
   of nil then nil
   []H|T then
      case {String.toAtom [H]}
      of ' ' then {MakeRow T}
      []')' then nil
      []X then
	 if {String.isInt X} then {String.toInt X}|{MakeRow T}
	 else X|{MakeRow T} end
      end
   end
end

/*
* pre: a list no-nul of the map starting
* result: return a record of the map -> map(r(x x) r(x x))
*/
fun {Scan MapParsed}
   case MapParsed of nil then nil
   []M|N then
      case {String.toAtom [M]}
      of &\t then {Scan N} 
      []&\n then {Scan N}
      []m then {Scan N}
      []a then {Scan N}
      []p then {Scan N}
      []r then {List.toTuple r {MakeRow N.2}}|{Scan N}
      else {Scan N}
      end
   end
end

/*
* pre: a valid MapFile record and a valid Canvas Handler
* result: Construc square by square the map
*/
proc {AddMapBlock MapRecord Canvas}
   RowLength = {Length {Arity MapRecord}}
   ColumnLength = {Length {Arity MapRecord.1}}
   proc {Recurs CurrRow CurrCol PosX PosY} %construct the map recursively
      GroundType in
      if CurrRow<RowLength+1 then  % not EOF
	 if CurrCol>ColumnLength then {Recurs CurrRow+1 1 0 PosY+SQUARE_LENGTH}  %restart a new row
	 else
	    GroundType = MapRecord.CurrRow.CurrCol
	    case GroundType
	    of 1 then {Canvas create(rect PosX PosY PosX+SQUARE_LENGTH PosY+SQUARE_LENGTH fill:green outline:nil)}
	    []0 then {Canvas create(rect PosX PosY PosX+SQUARE_LENGTH PosY+SQUARE_LENGTH fill:white outline:nil)}
	    []e then {Canvas create(rect PosX PosY PosX+SQUARE_LENGTH PosY+SQUARE_LENGTH fill:red outline:nil)}
	    []s then 
	       {Canvas create(rect PosX PosY PosX+SQUARE_LENGTH PosY+SQUARE_LENGTH fill:blue outline:nil)}
	       StartX=PosX
	       StartY=PosY
	    end
	    {Recurs CurrRow CurrCol+1  PosX+SQUARE_LENGTH PosY} %recurse increasing the collumn number
	 end
      end
   end
in
   {Recurs 1 1 0 0}
end

/*
* pre: A valid MapRecord record
* result: Draw and display the map
*/

proc {DrawMap MapRecord}
   RowLength = {Length {Arity MapRecord}}
   ColumnLength = {Length {Arity MapRecord.1}}
   Canvas = canvas(handle:CanvasHandler width:ColumnLength*SQUARE_LENGTH+200 height:RowLength*SQUARE_LENGTH+SQUARE_LENGTH)
in
   Window = {QTk.build td(Canvas)}
   {Window show}
   {AddMapBlock MapRecord CanvasHandler}
end

   
   MovementStatusStream
   MovementStatus = {NewPort MovementStatusStream}
   fun {F Msg State}
   	case Msg
   	of moving() then moving()
   	[] idle() then idle()
   	[] get(X) then X=State State
   	end
   end
   proc {Loop S State}
   	case S of Msg|S2 then
   		{Loop S2 {F Msg State}}
   	end
   end
   thread {Loop MovementStatusStream idle()} end
   
	proc {LeftHandle}
	   	thread X in
			{Send MovementStatus get(X)}
			{Wait X}
			{Show X}
		   	case X of idle() then
		   		{Send MovementStatus moving()}
			   	{Show move_left}
		   		{MoveHero l}
		   		{Send MovementStatus idle()}
		   	else
		   		skip
		   	end
	   	end
   	end
   	
   	proc {RightHandle}
	   	thread X in
			{Send MovementStatus get(X)}
			{Wait X}
			{Show X}
		   	case X of idle() then
		   		{Send MovementStatus moving()}
			   	{Show move_right}
		   		{MoveHero r}
		   		{Send MovementStatus idle()}
		   	else
		   		skip
		   	end
	   	end
   	end
   	
   	proc {UpHandle}
	   	thread X in
			{Send MovementStatus get(X)}
			{Wait X}
			{Show X}
		   	case X of idle() then
		   		{Send MovementStatus moving()}
			   	{Show move_up}
		   		{MoveHero u}
		   		{Send MovementStatus idle()}
		   	else
		   		skip
		   	end
	   	end
   	end
   	
   	proc {DownHandle}
	   	thread X in
			{Send MovementStatus get(X)}
			{Wait X}
			{Show X}
		   	case X of idle() then
		   		{Send MovementStatus moving()}
			   	{Show move_down}
		   		{MoveHero d}
		   		{Send MovementStatus idle()}
		   	else
		   		skip
		   	end
	   	end
   	end

MapFile={New Open.file init(name:'map.txt' flags:[read])}
{MapFile read(list:MapParsed size:all)}
MapRecord={List.toTuple map {Scan MapParsed}}
{MapFile close}
{DrawMap MapRecord}

HeroTag={CanvasHandler newTag($)}
{CanvasHandler create(image StartX-12 StartY-25-34*10 image:Face anchor:nw handle:HeroHandle tags:HeroTag)}


  {Window bind(event:"<Up>" action:UpHandle)} %trying to bind to an action
   {Window bind(event:"<Down>" action:DownHandle)}
   {Window bind(event:"<Left>" action:LeftHandle)}
   {Window bind(event:"<Right>" action:RightHandle)}

end
