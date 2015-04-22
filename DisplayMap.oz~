declare
MapFile = map(r(1 1 1 0 0 0 0 0 0 0 0 0 e)
	      r(1 1 1 0 0 1 1 1 1 0 0 0 0)
	      r(1 1 1 0 0 1 1 1 1 1 1 0 0)
	      r(0 0 0 0 0 1 1 1 1 1 1 0 0)
	      r(0 0 0 1 1 1 1 1 1 0 0 0 0)
	      r(0 0 0 1 1 0 0 0 0 0 0 1 1)
	      r(0 0 0 1 1 0 0 0 0 0 0 1 1)
	      r(0 0 1 1 1 0 0 0 0 0 1 0 0)
	      r(0 1 1 1 1 1 0 0 0 0 0 0 0)
	      r(0 1 1 1 1 1 0 0 0 0 0 0 0)
	      r(0 0 1 1 1 0 0 0 0 0 0 0 0)
	      r(0 0 0 1 0 0 0 0 0 0 0 1 1)
	      r(0 0 0 0 0 0 0 0 0 0 s 1 1))

SQUARE_LENGTH = 50 % length of a standard square

[QTk] = {Module.link ['x-oz://system/wp/QTk.ozf']}

declare
proc {AddMapBlock MapFile Canvas}
   RowLength = {Length {Arity MapFile.1}}
   ColumnLength = {Length {Arity MapFile}}
   proc {Recurs CurrRow CurrCol PosX PosY} %construct the map recursively
      GroundType in
      {Browse CurrCol#CurrRow}
      if CurrCol>ColumnLength then {Recurs CurrRow+1 1 0 PosY+SQUARE_LENGTH} end %restart a new row
      if CurrRow>RowLength then skip end %EOF
      GroundType = MapFile.CurrRow.CurrCol
      case GroundType
      of 1 then {Canvas create(rect PosX PosY PosX+SQUARE_LENGTH PosY+SQUARE_LENGTH fill:green outline:black)}
      []0 then {Canvas create(rect PosX PosY PosX+SQUARE_LENGTH PosY+SQUARE_LENGTH fill:white outline:black)}
      []e then {Canvas create(rect PosX PosY PosX+SQUARE_LENGTH PosY+SQUARE_LENGTH fill:red outline:black)}
      []s then {Canvas create(rect PosX PosY PosX+SQUARE_LENGTH PosY+SQUARE_LENGTH fill:blue outline:black)}
      end
      {Recurs CurrRow CurrCol+1  PosX+SQUARE_LENGTH PosY}
   end
in
   {Recurs 1 1 0 0}
end


declare
fun {DrawMap MapFile}
   C
   Canvas = canvas(handle:C width:800 height:800)
in
   {{QTk.build td(Canvas)} show}
   {AddMapBlock MapFile C}
   1
end

{Browse {DrawMap MapFile}}