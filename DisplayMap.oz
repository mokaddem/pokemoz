/*
   IMPORT AND CONSTANTS
*/
functor
import
System(show:Show)
Module(link)
Open

define
SQUARE_LENGTH = 34 % length of a standard square
SquareLenghtFloat = {IntToFloat SQUARE_LENGTH}
[QTk] = {Module.link ['x-oz://system/wp/QTk.ozf']}
StartX 
StartY

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
fun {Scan Map}
   case Map of nil then nil
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
proc {AddMapBlock MapFile Canvas}
   RowLength = {Length {Arity MapFile}}
   ColumnLength = {Length {Arity MapFile.1}}
   proc {Recurs CurrRow CurrCol PosX PosY} %construct the map recursively
      GroundType in
      if CurrRow<RowLength+1 then  % not EOF
	 if CurrCol>ColumnLength then {Recurs CurrRow+1 1 0 PosY+SQUARE_LENGTH}  %restart a new row
	 else
	    GroundType = MapFile.CurrRow.CurrCol
	    case GroundType
	    of 1 then {Canvas create(rect PosX PosY PosX+SQUARE_LENGTH PosY+SQUARE_LENGTH fill:green outline:black)}
	    []0 then {Canvas create(rect PosX PosY PosX+SQUARE_LENGTH PosY+SQUARE_LENGTH fill:white outline:black)}
	    []e then {Canvas create(rect PosX PosY PosX+SQUARE_LENGTH PosY+SQUARE_LENGTH fill:red outline:black)}
	    []s then 
	       {Canvas create(rect PosX PosY PosX+SQUARE_LENGTH PosY+SQUARE_LENGTH fill:blue outline:black)}
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
* pre: A valid MapFile record
* result: Draw and display the map
*/
C Window
proc {DrawMap MapFile}
   RowLength = {Length {Arity MapFile}}
   ColumnLength = {Length {Arity MapFile.1}}
   Canvas = canvas(handle:C width:ColumnLength*SQUARE_LENGTH+200 height:RowLength*SQUARE_LENGTH+SQUARE_LENGTH)
in
   Window = {QTk.build td(Canvas)}
   {Window show}
   {AddMapBlock MapFile C}
end


MapFile Map
F={New Open.file init(name:'map.txt' flags:[read])}
{F read(list:Map size:all)}
MapFile={List.toTuple map {Scan Map}}
{F close}
{DrawMap MapFile}

local 
   Hero HeroHandle HeroTag={C newTag($)}
   Beer
   PathHero = photo(file:'Images/hero.gif') %constructor and path to the picture file
   PathBeer = photo(file:'Images/beer.gif')

%%%%% CREATE MOUVEMENT IMAGES %%%%%   
   PathHeroTotal = photo(file:'Images/006_0.gif')
   HeroImage = {QTk.newImage PathHeroTotal}   
%Down
   Down1 = {QTk.newImage photo()}
   Down2 = {QTk.newImage photo()}
   Down3 = {QTk.newImage photo()}
   Down4 = {QTk.newImage photo()}
   {Down1 copy(HeroImage 'from':o(0 0 64 64))}
   {Down2 copy(HeroImage 'from':o(64 0 128 64))}
   {Down3 copy(HeroImage 'from':o(128 0 192 64))}
   {Down4 copy(HeroImage 'from':o(192 0 256 64))}
   DownFrame = frame(Down1 Down2 Down3 Down4)
%Right
   Right1 = {QTk.newImage photo()}
   Right2 = {QTk.newImage photo()}
   Right3 = {QTk.newImage photo()}
   Right4 = {QTk.newImage photo()}
   {Right1 copy(HeroImage 'from':o(0 128 64 192))}
   {Right2 copy(HeroImage 'from':o(64 128 128 192))}
   {Right3 copy(HeroImage 'from':o(128 128 192 192))}
   {Right4 copy(HeroImage 'from':o(192 128 256 192))}
   RightFrame = frame(Right1 Right2 Right3 Right4)
%Left
   Left1 = {QTk.newImage photo()}
   Left2 = {QTk.newImage photo()}
   Left3 = {QTk.newImage photo()}
   Left4 = {QTk.newImage photo()}
   {Left1 copy(HeroImage 'from':o(0 64 64 128))}
   {Left2 copy(HeroImage 'from':o(64 64 128 128))}
   {Left3 copy(HeroImage 'from':o(128 64 192 128))}
   {Left4 copy(HeroImage 'from':o(192 64 256 128))}
   LeftFrame = frame(Left1 Left2 Left3 Left4)
%Up
   Up1 = {QTk.newImage photo()}
   Up2 = {QTk.newImage photo()}
   Up3 = {QTk.newImage photo()}
   Up4 = {QTk.newImage photo()}
   {Up1 copy(HeroImage 'from':o(0 192 64 256))}
   {Up2 copy(HeroImage 'from':o(64 192 128 256))}
   {Up3 copy(HeroImage 'from':o(128 192 192 256))}
   {Up4 copy(HeroImage 'from':o(192 192 256 256))}
   UpFrame = frame(Up1 Up2 Up3 Up4)
%PROCEDURE THAT ANIMATE AND MOVE THE HERO
   proc {MoveHero Dir}
      D=75 MovementValue=SquareLenghtFloat/4.0 Movement Frames in
      case Dir
      of r then
	 Frames = RightFrame
	 Movement = move(MovementValue 0)
      []l then
	 Frames = LeftFrame
	 Movement = move(~MovementValue 0)
      []d then
         Frames = DownFrame
	 Movement = move(0 MovementValue)
      []u then
         Frames = UpFrame
	 Movement = move(0 ~MovementValue)
      end
      {HeroHandle set(image:Frames.1)}
      {Delay D}
      {HeroHandle set(image:Frames.2)}
      {HeroHandle Movement}
      {Delay D}
      {HeroHandle set(image:Frames.3)}
      {HeroHandle Movement}
      {Delay D}
      {HeroHandle set(image:Frames.4)}
      {HeroHandle Movement}
      {Delay D}
      {HeroHandle set(image:Frames.1)}
      {HeroHandle Movement}
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

%%%%%%%%%%%%%%%

in
   Hero = {QTk.newImage PathHero} %build the image
   Beer = {QTk.newImage PathBeer}
%   {C create(image StartX StartY-14 image:Hero anchor:nw handle:HeroHandle tags:HeroTag)} %add the image to the canvas. -14 to fit the foot with the ground
   {C create(image StartX-12 StartY-25-34*10 image:Down1 anchor:nw handle:HeroHandle tags:HeroTag)}

  {Window bind(event:"<Up>" action:UpHandle)} %trying to bind to an action
   {Window bind(event:"<Down>" action:DownHandle)}
   {Window bind(event:"<Left>" action:LeftHandle)}
   {Window bind(event:"<Right>" action:RightHandle)}
   {Window bind(event:"<Return>" action:proc{$} {Show change_state} {HeroHandle set(image:Down2)} end)}

end

end
