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
	PokeConfig(sQUARE_LENGTH:SQUARE_LENGTH hERO_SUBSAMPLE:HERO_SUBSAMPLE gRASS_ZOOM:GRASS_ZOOM heroPosYDecal:HeroPosYDecal heroPosXDecal:HeroPosXDecal)
	Trainer(newTrainer:NewTrainer)
	Pokemoz(newPokemoz:NewPokemoz)
	Battle(runBattle:RunBattle)
%	Game(heroTrainer:HeroTrainer)
export
	
	HeroPosition
	PokeHandle 
	PokePosition
	SquareLengthFloat
	FieldType
	InitMap
	MapRecord
	AllowedPlace
	PlaceAllowed
	LookAround
	DeplaceAllowedPlace
	CreateAndDisplayHeroAndFollower
	CreateAndDisplayTrainer
	DrawMap
%	HeroHandle
	StartX
	StartY
	
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
	AllowedPlace    %Record = occupied if not allowed

	%Hero_variables
%	HeroHandle	%The Hero handler
	HeroPosition	%The Hero's position cell
	%HeroPosXDecal=~14
	%HeroPosYDecal=0
	
	%Poke_variables
	PokeHandle
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
	proc {DrawMap MapRecord HeroTrainer}
		RowLength = {Length {Arity MapRecord}}
		ColumnLength = {Length {Arity MapRecord.1}}
		Canvas = canvas(handle:CanvasHandler width:ColumnLength*SQUARE_LENGTH+200 height:RowLength*SQUARE_LENGTH+200)
	in
		Window = {QTk.build td(Canvas)}
		{Window show}
		{AddMapBlock MapRecord CanvasHandler}
		
		{Window bind(event:"<Up>" action:proc{$} {MovementHandle u HeroTrainer true} end)}
		{Window bind(event:"<Down>" action:proc{$} {MovementHandle d HeroTrainer true} end)}
		{Window bind(event:"<Left>" action:proc{$} {MovementHandle l HeroTrainer true} end)}
		{Window bind(event:"<Right>" action:proc{$} {MovementHandle r HeroTrainer true} end)}
	end
	
	fun {FieldType X Y}
		if X > {Length {Arity MapRecord}} then null
		else if X < 1 then null
		else if Y > {Length {Arity MapRecord}} then null
		else if Y < 1  then null
		else MapRecord.Y.X end end end end
	end
	
	fun {PlaceAllowed X Y}
		if X > {Length {Arity AllowedPlace}} then null
		else if X < 1 then null
		else if Y > {Length {Arity AllowedPlace}} then null
		else if Y < 1  then null
		else {CellGet AllowedPlace.Y.X} end end end end
	end
	
	proc {DeplaceAllowedPlace NewX NewY OldX OldY Type}
		{CellSet AllowedPlace.OldY.OldX 'free'}
		{CellSet AllowedPlace.NewY.NewX Type}
	end
	
	fun {LookAround X Y Type}
		OtherType in
		if Type == 'player' then OtherType = 'ia'
		elseif Type == 'ia' then OtherType = 'player' end
		
		/*if {PlaceAllowed X-1 Y-1} == OtherType then 'true'
		else*/if {PlaceAllowed X-1 Y} == OtherType then 'true'
		%else if {PlaceAllowed X-1 Y+1} == OtherType then 'true'
		else if {PlaceAllowed X Y-1} == OtherType then 'true'
		else if {PlaceAllowed X Y+1} == OtherType then 'true'
		%else if {PlaceAllowed X+1 Y-1} == OtherType then 'true'
		else if {PlaceAllowed X+1 Y} == OtherType then 'true'
		%else if {PlaceAllowed X+1 Y+1} == OtherType then 'true'
		else 'false' end end end end %end end end end
	end
	
	/*
	*	result: Draw and display the hero and his fellow
	*	return: the created Hero Handle
	*/
	fun {CreateAndDisplayHeroAndFollower}
		PosXPokDecal=~14
		PosYPokDecal={FloatToInt ~1.0*SquareLengthFloat}
		HeroHandle
	in	
		PokePosition={CustomNewCell pos(x:{IntToFloat StartX} y:({IntToFloat StartY}-SquareLengthFloat/5.0))}
		{CanvasHandler create(image (StartX)*SQUARE_LENGTH+PosXPokDecal (StartY-1)*SQUARE_LENGTH+PosYPokDecal image:PokeFace anchor:nw handle:PokeHandle)}
		HeroPosition={CustomNewCell pos(x:{IntToFloat StartX} y:{IntToFloat StartY})}
		{CanvasHandler create(image (StartX)*SQUARE_LENGTH+HeroPosXDecal (StartY-1)*SQUARE_LENGTH+HeroPosYDecal image:HeroFace anchor:nw handle:HeroHandle)}
		HeroHandle
	end
	
	/*
	*	result: Draw and display a trainer
	*	return: the created trainer Handle
	*/
	fun {CreateAndDisplayTrainer TrainerPosX1 TrainerPosY1}
		TrainerHandle
	in	
		%TrainerPosition={CustomNewCell pos(x:{IntToFloat TrainerPosX1} y:{IntToFloat TrainerPosY1})}
		{CanvasHandler create(image (TrainerPosX1)*SQUARE_LENGTH+HeroPosXDecal (TrainerPosY1-1)*SQUARE_LENGTH+HeroPosYDecal image:HeroFace anchor:nw handle:TrainerHandle)}
		TrainerHandle
	end
	
	% State = state(type:T num:Num name:N maxlife:Ml currentLife:Cl experience:E level:L)
   /*	Bulba = {NewPokemoz state(type:grass num:1 name:bulbozar maxlife:20 currentLife:20 experience:0 level:5)}
	Charmo = {NewPokemoz state(type:fire num:0 name:charmozer maxlife:20 currentLife:20 experience:0 level:5)}
	{RunBattle Bulba Charmo}*/

	proc {InitMap}
		MapFile={New Open.file init(name:'map.txt' flags:[read])}
		{MapFile read(list:MapParsed size:all)}
		MapRecord={List.toTuple map {Scan MapParsed}}
		AllowedPlace = {Record.make allowed {Arity MapRecord}}
		for N in 1..{Length {Arity MapRecord}} do
			AllowedPlace.N = {Record.make allowed {Arity MapRecord.N}}
			for M in 1..{Length {Arity MapRecord.N}} do
				AllowedPlace.N.M = {CustomNewCell MapRecord.N.M}
			end
		end
		{MapFile close}
	end

end
