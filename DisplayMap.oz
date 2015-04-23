/*
   IMPORT AND CONSTANTS
*/
declare
SQUARE_LENGTH = 40 % length of a standard square
[QTk] = {Module.link ['x-oz://system/wp/QTk.ozf']}
StartX 
StartY

/*
* pre: a no-nul list starting with the first case of the map.
* result: return a list of rows lists -> [row1 row2 row3..]
*/
declare						
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
declare
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
	       StartX=PosX+117 %?? pq ??? --> image dimensio problem
	       StartY=PosY+100 %?? pq ?
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
declare
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


declare
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
in
   Hero = {QTk.newImage PathHero} %build the image
   Beer = {QTk.newImage PathBeer}
   {C create(image StartX StartY image:Hero anchor:center handle:HeroHandle tags:HeroTag)} %add the image to the canvas
   {Window bind(event:"<Up>" action:proc{$} {Show move_up} {HeroTag move(0 ~1)} end)} %trying to bind to an action
   {Window bind(event:"<Down>" action:proc{$} {Show move_down} {HeroTag move(0 1)} end)}
   {Window bind(event:"<Left>" action:proc{$} {Show move_left} {HeroTag move(~1 0)} end)}
   {Window bind(event:"<Right>" action:proc{$} {Show move_right} {HeroTag move(1 0)} end)}
   {Window bind(event:"<Return>" action:proc{$} {Show change_state} {HeroHandle set(image:Beer)} end)}
end