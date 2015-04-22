/*
   IMPORT AND CONSTANTS
*/
declare
SQUARE_LENGTH = 25 % length of a standard square
[QTk] = {Module.link ['x-oz://system/wp/QTk.ozf']}

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
	    []s then {Canvas create(rect PosX PosY PosX+SQUARE_LENGTH PosY+SQUARE_LENGTH fill:blue outline:black)}
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
proc {DrawMap MapFile}
   RowLength = {Length {Arity MapFile}}
   ColumnLength = {Length {Arity MapFile.1}}
   C
   Canvas = canvas(handle:C width:ColumnLength*SQUARE_LENGTH+200 height:RowLength*SQUARE_LENGTH+SQUARE_LENGTH)
in
   {{QTk.build td(Canvas)} show}
   {AddMapBlock MapFile C}
end


declare
MapFile Map
F={New Open.file init(name:'/home/sami/info/Bac 3/Oz2/projet/pokemoz/map.txt' flags:[read])}
{F read(list:Map size:all)}
MapFile={List.toTuple map {Scan Map}}
{F close}
{DrawMap MapFile}