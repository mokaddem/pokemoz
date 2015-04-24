/*
   IMPORT AND CONSTANTS
*/
functor
import
System(show:Show)
Module
Open

define
SQUARE_LENGTH = 34 % length of a standard square
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
   PathHeroTotal = photo(file:'Images/HGSS_143.gif')
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
%Right
   Right1 = {QTk.newImage photo()}
   Right2 = {QTk.newImage photo()}
   Right3 = {QTk.newImage photo()}
   Right4 = {QTk.newImage photo()}
   {Right1 copy(HeroImage 'from':o(0 128 64 192))}
   {Right2 copy(HeroImage 'from':o(64 128 128 192))}
   {Right3 copy(HeroImage 'from':o(128 128 192 192))}
   {Right4 copy(HeroImage 'from':o(192 128 256 192))}
%Left
   Left1 = {QTk.newImage photo()}
   Left2 = {QTk.newImage photo()}
   Left3 = {QTk.newImage photo()}
   Left4 = {QTk.newImage photo()}
   {Left1 copy(HeroImage 'from':o(0 64 64 128))}
   {Left2 copy(HeroImage 'from':o(64 64 128 128))}
   {Left3 copy(HeroImage 'from':o(128 64 192 128))}
   {Left4 copy(HeroImage 'from':o(192 64 256 128))}
%Up
   Up1 = {QTk.newImage photo()}
   Up2 = {QTk.newImage photo()}
   Up3 = {QTk.newImage photo()}
   Up4 = {QTk.newImage photo()}
   {Up1 copy(HeroImage 'from':o(0 192 64 256))}
   {Up2 copy(HeroImage 'from':o(64 192 128 256))}
   {Up3 copy(HeroImage 'from':o(128 192 192 256))}
   {Up4 copy(HeroImage 'from':o(192 192 256 256))}
%PROCEDURE THAT ANIMATE AND MOVE THE HERO
   proc {MoveHero Dir}
      D=75 in
      case Dir
      of r then
	 {HeroHandle set(image:Right1)}
	 {Delay D}
	 {HeroHandle set(image:Right2)}
	 {HeroHandle move(8.5 0)}
	 {Delay D}
	 {HeroHandle set(image:Right3)}
	 {HeroHandle move(8.5 0)}
	 {Delay D}
	 {HeroHandle set(image:Right4)}
	 {HeroHandle move(8.5 0)}
	 {Delay D}
	 {HeroHandle set(image:Right1)}
	 {HeroHandle move(8.5 0)}
      []l then
	 {HeroHandle set(image:Left1)}
	 {Delay D}
	 {HeroHandle set(image:Left2)}
	 {HeroHandle move(~8.5 0)}
	 {Delay D}
	 {HeroHandle set(image:Left3)}
	 {HeroHandle move(~8.5 0)}
	 {Delay D}
	 {HeroHandle set(image:Left4)}
	 {HeroHandle move(~8.5 0)}
	 {Delay D}
	 {HeroHandle set(image:Left1)}
	 {HeroHandle move(~8.5 0)}
       []d then
         {HeroHandle set(image:Down1)}
	 {Delay D}
	 {HeroHandle set(image:Down2)}
	 {HeroHandle move(0 8.5)}
	 {Delay D}
	 {HeroHandle set(image:Down3)}
	 {HeroHandle move(0 8.5)}
	 {Delay D}
	 {HeroHandle set(image:Down4)}
	 {HeroHandle move(0 8.5)}
	 {Delay D}
	 {HeroHandle set(image:Down1)}
	 {HeroHandle move(0 8.5)}
      []u then
         {HeroHandle set(image:Up1)}
	 {Delay D}
	 {HeroHandle set(image:Up2)}
	 {HeroHandle move(0 ~8.5)}
	 {Delay D}
	 {HeroHandle set(image:Up3)}
	 {HeroHandle move(0 ~8.5)}
	 {Delay D}
	 {HeroHandle set(image:Up4)}
	 {HeroHandle move(0 ~8.5)}
	 {Delay D}
	 {HeroHandle set(image:Up1)}
	 {HeroHandle move(0 ~8.5)}
      end
   end

%%%%%%%%%%%%%%%

in
   Hero = {QTk.newImage PathHero} %build the image
   Beer = {QTk.newImage PathBeer}
%   {C create(image StartX StartY-14 image:Hero anchor:nw handle:HeroHandle tags:HeroTag)} %add the image to the canvas. -14 to fit the foot with the ground
   {C create(image StartX-12 StartY-25-34*10 image:Down1 anchor:nw handle:HeroHandle tags:HeroTag)}

  {Window bind(event:"<Up>" action:proc{$} {Show move_up} {HeroTag move(0 ~34)} end)} %trying to bind to an action
   {Window bind(event:"<Down>" action:proc{$} {Show move_down} {HeroHandle move(0 34)} end)}
   {Window bind(event:"<Left>" action:proc{$} {Show move_left} {HeroHandle move(~34 0)} end)}
   {Window bind(event:"<Right>" action:proc{$} {Show move_right} {HeroHandle move(34 0)} end)}
   {Window bind(event:"<Return>" action:proc{$} {Show change_state} {HeroHandle set(image:Down2)} end)}


   {Window bind(event:"<Down>" action:proc{$} {Show move_down} {MoveHero d} end)}
   {Window bind(event:"<Up>" action:proc{$} {Show move_up} {MoveHero u} end)}
   {Window bind(event:"<Right>" action:proc{$} {Show move_right} {MoveHero r} end)}
   {Window bind(event:"<Left>" action:proc{$} {Show move_left} {MoveHero l} end)}

end

end
