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

define
	UI_LENGTH = 255*2
	UI_HEIGHT = 143*2

	OpPokePosX = 192*2
%	OpPokePosY = (88-18)*2
	OpPokePosY = (88-38)*2
	MiPokePosX = (90+20)*2
	MiPokePosY = (143+21)*2
	
	OpPokeHandle
	OpPokeTag
	MiPokeHandle
	MiPokeTag

	UICanvas
	UICanvasHandler
	Window
	
	UI_Control
	UI_Control_Window
	
	proc {DrawBattleUI}
		UICanvas = canvas(handle:UICanvasHandler width:UI_LENGTH height:UI_HEIGHT)
		Window = {QTk.build td(UICanvas)}
		{Window show}
		{UICanvasHandler create(image 0 0 image:Background_Battle_Grass anchor:nw)}
		{DrawPokemoz}
		{DrawUI_Control}
	end
	
	proc {DrawPokemoz}
		OpPokeTag={UICanvasHandler newTag($)}
		{UICanvasHandler create(image OpPokePosX OpPokePosY image:AllSprites_Op.1.1 anchor:center handle:OpPokeHandle tags:OpPokeTag)}
	
		MiPokeTag={UICanvasHandler newTag($)}
		{UICanvasHandler create(image MiPokePosX MiPokePosY image:AllSprites_B.8 anchor:se handle:MiPokeHandle tags:MiPokeTag)}
	
%		V in
%	{AllSprites_Op.1.1 getColor(1 1 V)}
	end
	
	proc {DrawUI_Control}
		Button_Attack = button(text:"Attack" action:proc{$} {Show 'Attack'} end)
		Button_PokemOz = button(text:"PokemOz" action:proc{$} {Show 'PokemOz'} end)
		Button_Fuite = button(text:"Runaway" action:proc{$} {Show 'Runaway'} end)
		Button_Capture = button(text:"Capture" action:proc{$} {Show 'Capture'} end)
		in
		
		UI_Control = grid(Button_Attack Button_Capture newline
								Button_PokemOz Button_Fuite)
		UI_Control_Window = {QTk.build td(UI_Control)} 
		{UI_Control_Window show}
	end

in
	{DrawBattleUI}

end
