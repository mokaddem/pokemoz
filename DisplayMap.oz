/*
   IMPORT AND CONSTANTS
*/
functor
import
	System(show:Show)
	Open
	CutImages(heroFace:HeroFace pokeFace:PokeFace grass_Tile:Grass_Tile road_Tile:Road_Tile)
	MoveHero(upHandle:UpHandle rightHandle:RightHandle leftHandle:LeftHandle downHandle:DownHandle)
	Util(customNewCell:CustomNewCell cellSet:CellSet cellGet:CellGet)
	QTk at 'x-oz://system/wp/QTk.ozf'

export
	HeroHandle 
	HeroPosition
	PokeHandle 
	SquareLengthFloat
	
define
																/* CONSTANTS */
	SQUARE_LENGTH = 16 % length of a standard square
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
	HeroPosition	%The Hero's position cell
	
	%Poke_variables
	PokeHandle
	PokeTag
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
					of 1 then %{Canvas create(rect PosX PosY PosX+SQUARE_LENGTH PosY+SQUARE_LENGTH fill:green outline:nil)}
								{Canvas create(image PosX PosY image:Grass_Tile anchor:nw)}
					[]0 then %{Canvas create(rect PosX PosY PosX+SQUARE_LENGTH PosY+SQUARE_LENGTH fill:white outline:nil)}
								{Canvas create(image PosX PosY image:Road_Tile anchor:nw)}
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

	MapFile={New Open.file init(name:'map.txt' flags:[read])}
	{MapFile read(list:MapParsed size:all)}
	MapRecord={List.toTuple map {Scan MapParsed}}
	{MapFile close}
	{DrawMap MapRecord}

	HeroTag={CanvasHandler newTag($)}
	HeroPosition={CustomNewCell StartX#StartY}
	{CanvasHandler create(image StartX-7 StartY-16 image:HeroFace anchor:nw handle:HeroHandle tags:HeroTag)}

	PokeTag={CanvasHandler newTag($)}
	{CanvasHandler create(image StartX-7 StartY-16-SQUARE_LENGTH image:PokeFace anchor:nw handle:PokeHandle tags:PokeTag)}

	{Window bind(event:"<Up>" action:UpHandle)} %trying to bind to an action
	{Window bind(event:"<Down>" action:DownHandle)}
	{Window bind(event:"<Left>" action:LeftHandle)}
	{Window bind(event:"<Right>" action:RightHandle)}

end
