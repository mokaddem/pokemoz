functor
import
	System(show:Show)
	Open

	CutImages(heroFace:HeroFace pokeFace:PokeFace grass_Tile:Grass_Tile road_Tile:Road_Tile allSprites_B:AllSprites_B)
	MoveHero(movementHandle:MovementHandle)
	Util(customNewCell:CustomNewCell cellSet:CellSet cellGet:CellGet)
	QTk at 'x-oz://system/wp/QTk.ozf'
	PokeConfig(sQUARE_LENGTH:SQUARE_LENGTH hERO_SUBSAMPLE:HERO_SUBSAMPLE gRASS_ZOOM:GRASS_ZOOM)
	Trainer(newTrainer:NewTrainer)
	Pokemoz(newPokemoz:NewPokemoz)
	Battle(runBattle:RunBattle)

define
	UI_LENGTH = 500
	UI_HEIGHT = 400

	OpPokePosX = 400
	OpPokePosY = 50
	MiPokePosX = 100
	MiPokePosY = 300
	
	OpPokeHandle
	OpPokeTag
	MiPokeHandle
	MiPokeTag

	UICanvas
	UICanvasHandler
	Window
	
	proc {DrawBattleUI}
		UICanvas = canvas(handle:UICanvasHandler width:UI_LENGTH height:UI_HEIGHT)
		Window = {QTk.build td(UICanvas)}
		{Window show}
		
		{DrawPokemoz}
	end
	
	proc {DrawPokemoz}
		OpPokeTag={UICanvasHandler newTag($)}
		{UICanvasHandler create(image OpPokePosX OpPokePosY image:AllSprites_B.9 anchor:center handle:OpPokeHandle tags:OpPokeTag)}
	
		MiPokeTag={UICanvasHandler newTag($)}
		{UICanvasHandler create(image MiPokePosX MiPokePosY image:AllSprites_B.1 anchor:center handle:MiPokeHandle tags:MiPokeTag)}

	end

in
	{DrawBattleUI}

end
