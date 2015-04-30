functor
import
	System(show:Show)
	Open

	CutImages(heroFace:HeroFace pokeFace:PokeFace grass_Tile:Grass_Tile road_Tile:Road_Tile allSprites_B:AllSprites_B allSprites_Op:AllSprites_Op background_Battle_Trainer:Background_Battle_Trainer background_Battle_Grass:Background_Battle_Grass)
	MoveHero(movementHandle:MovementHandle)
	Util(customNewCell:CustomNewCell cellSet:CellSet cellGet:CellGet)
	QTk at 'x-oz://system/wp/QTk.ozf'
	PokeConfig(sQUARE_LENGTH:SQUARE_LENGTH hERO_SUBSAMPLE:HERO_SUBSAMPLE gRASS_ZOOM:GRASS_ZOOM)
	Trainer(newTrainer:NewTrainer)
	Pokemoz(newPokemoz:NewPokemoz)
	Battle(runBattle:RunBattle)
	
export
	PrepareBattle

define
	UI_LENGTH = 255*2
	UI_HEIGHT = 143*2

	OpPokePosX = 192*2
%	OpPokePosY = (88-18)*2	%bulbizar
	OpPokePosY = (88-38)*2	%dracofeu -> solve with getcolor
	MiPokePosX = (90+20)*2
	MiPokePosY = (143+21)*2
	

	proc {DrawBattleUI MiNumber OpNumber}
		UICanvas
		UICanvasHandler
		Window
	in
		UICanvas = canvas(handle:UICanvasHandler width:UI_LENGTH height:UI_HEIGHT)
		Window = {QTk.build td(title:'PokemOz battle!' UICanvas)}
		{Window show}
		{UICanvasHandler create(image 0 0 image:Background_Battle_Grass anchor:nw)}
		{DrawPokemoz OpNumber MiNumber UICanvasHandler}
		{DrawUI_Control Window}
	end
	
	proc {DrawPokemoz OpNumber MiNumber UICanvasHandler}
		OpPokeHandle MiPokeHandle
	in
		{UICanvasHandler create(image OpPokePosX OpPokePosY image:AllSprites_Op.OpNumber.1 anchor:center handle:OpPokeHandle)}
		{UICanvasHandler create(image MiPokePosX MiPokePosY image:AllSprites_B.MiNumber anchor:se handle:MiPokeHandle)}
	
%		V in
%	{AllSprites_Op.1.1 getColor(1 1 V)}	--> to correctly place the pokemon on the ground. (bulb/draco)
	end
	
	proc {PrepareBattle MiPoke OpPoke}
		{DrawBattleUI MiPoke OpPoke}
		
	end
	
	proc {DrawUI_Control Window}
		UI_Control
		UI_Control_Handler
		UI_Control_Window
		
		But_Attk_Handler
		But_Poke_Handler
		But_Fuite_Handler
		But_Capt_Handler

		Button_Attack = button(text:"Attack" action:proc{$} {Show 'Attack'} end handle:But_Attk_Handler)
		Button_PokemOz = button(text:"PokemOz" action:proc{$} {Show 'PokemOz'} end handle:But_Poke_Handler)
		Button_Fuite = button(text:"Runaway" action:proc{$} {Show 'Runaway'} end handle:But_Capt_Handler)
		Button_Capture = button(text:"Capture" action:proc{$} {Show 'Capture'} end handle:But_Fuite_Handler)
	
		UI_Control = grid(empty Button_Attack  empty newline
								Button_PokemOz empty Button_Capture newline
								empty Button_Fuite empty
								handle:UI_Control_Handler)
	
		in
			% Get info about window and place the dialog ont the right place
			UI_Control_Window = {QTk.build td(title:'PokemOz battle!' UI_Control)}
			{UI_Control_Handler configure(But_Attk_Handler But_Poke_Handler But_Fuite_Handler But_Capt_Handler padx:10 pady:10)}	 
			local X Y in {Window winfo(geometry:X)} {UI_Control_Handler winfo(geometry:Y)}
			{UI_Control_Window set(geometry:geometry(x:X.x+{FloatToInt {IntToFloat X.width}/2.0-{IntToFloat Y.width}/2.0} y:X.y+X.height))}
		end
		{UI_Control_Window show(modal:true)}
	
		{UI_Control_Window bind(event:"<Up>" action:proc{$} {Show 'Attack'} end)} %trying to bind to an action
		{UI_Control_Window bind(event:"<Down>" action:proc{$} {Show 'Runaway'} end)}
		{UI_Control_Window bind(event:"<Left>" action:proc{$} {Show 'PokemOz'} end)}
		{UI_Control_Window bind(event:"<Right>" action:proc{$} {Show 'Capture'} end)}
	end

end
