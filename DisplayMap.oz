/*
   IMPORT AND CONSTANTS
*/
functor
import
	System(show:Show)
	Open

	CutImages(heroFace:HeroFace pokeFace:PokeFace grass_Tile:Grass_Tile road_Tile:Road_Tile)
	MoveHero(movementHandle:MovementHandle)
	Util(customNewCell:CustomNewCell cellSet:CellSet cellGet:CellGet)
	QTk at 'x-oz://system/wp/QTk.ozf'
	PokeConfig(sQUARE_LENGTH:SQUARE_LENGTH hERO_SUBSAMPLE:HERO_SUBSAMPLE gRASS_ZOOM:GRASS_ZOOM)
	Trainer(newTrainer:NewTrainer)

export
	HeroHandle 
	HeroPosition
	PokeHandle 
	PokePosition
	SquareLengthFloat
	FieldType
	MapRecord
	
define
																/* CONSTANTS */
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
	PokePosition
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
				if CurrCol>ColumnLength then {Recurs CurrRow+1 1 1 PosY+1}  %restart a new row
				else
					GroundType = MapRecord.CurrRow.CurrCol
					case GroundType
					of 1 then {Canvas create(image PosX*SQUARE_LENGTH PosY*SQUARE_LENGTH image:Grass_Tile anchor:nw)}
					[]0 then {Canvas create(image PosX*SQUARE_LENGTH PosY*SQUARE_LENGTH image:Road_Tile anchor:nw)}
					[]e then {Canvas create(rect PosX*SQUARE_LENGTH PosY*SQUARE_LENGTH (PosX+1)*SQUARE_LENGTH (PosY+1)*SQUARE_LENGTH fill:red outline:nil)}
					[]s then 
						{Canvas create(rect PosX*SQUARE_LENGTH PosY*SQUARE_LENGTH (PosX+1)*SQUARE_LENGTH (PosY+1)*SQUARE_LENGTH fill:blue outline:nil)}
						StartX=PosX
						StartY=PosY
					end
					{Recurs CurrRow CurrCol+1  PosX+1 PosY} %recurse increasing the collumn number
				end
			end
		end
	in
		{Recurs 1 1 1 1}
	end

	

	
	/*
	* pre: A valid MapRecord record
	* result: Draw and display the map
	*/
	proc {DrawMap MapRecord}
		RowLength = {Length {Arity MapRecord}}
		ColumnLength = {Length {Arity MapRecord.1}}
		Canvas = canvas(handle:CanvasHandler width:ColumnLength*SQUARE_LENGTH+200 height:RowLength*SQUARE_LENGTH+200)
	in
		Window = {QTk.build td(Canvas)}
		{Window show}
		{AddMapBlock MapRecord CanvasHandler}
	end
	
	fun {FieldType X Y}
		if X > {Length {Arity MapRecord}} then null
		else if X < 1 then null
		else if Y > {Length {Arity MapRecord}} then null
		else if Y < 1  then null
		else MapRecord.Y.X end end end end
	end

	MapFile={New Open.file init(name:'map.txt' flags:[read])}
	{MapFile read(list:MapParsed size:all)}
	MapRecord={List.toTuple map {Scan MapParsed}}
	{MapFile close}
	{DrawMap MapRecord}

	PosXDecal=~14
	PosYDecal=0
	PosXPokDecal=~14
	PosYPokDecal={FloatToInt ~1.0*SquareLengthFloat}
	
	PokeTag={CanvasHandler newTag($)}
	PokePosition={CustomNewCell pos(x:{IntToFloat StartX} y:({IntToFloat StartY}-SquareLengthFloat/5.0))}
	{CanvasHandler create(image (StartX)*SQUARE_LENGTH+PosXPokDecal (StartY-1)*SQUARE_LENGTH+PosYPokDecal image:PokeFace anchor:nw handle:PokeHandle tags:PokeTag)}

	HeroTag={CanvasHandler newTag($)}
	HeroPosition={CustomNewCell pos(x:{IntToFloat StartX} y:{IntToFloat StartY})}
	{CanvasHandler create(image (StartX)*SQUARE_LENGTH+PosXDecal (StartY-1)*SQUARE_LENGTH+PosYDecal image:HeroFace anchor:nw handle:HeroHandle tags:HeroTag)}

	Tr = {NewTrainer state(x:StartX y:StartY pokemoz:0 speed:5 movement:proc{$ P} 1=1 end handler:HeroHandle)}

	{Window bind(event:"<Up>" action:proc{$} {MovementHandle u Tr} end)} %trying to bind to an action
	{Window bind(event:"<Down>" action:proc{$} {MovementHandle d Tr} end)}
	{Window bind(event:"<Left>" action:proc{$} {MovementHandle l Tr} end)}
	{Window bind(event:"<Right>" action:proc{$} {MovementHandle r Tr} end)}

end
