functor

import
	System(show:Show)
	Open
	QTk at 'x-oz://system/wp/QTk.ozf'

	CutImages(heroFace:HeroFace pokeFace:PokeFace grass_Tile:Grass_Tile road_Tile:Road_Tile)
	MoveHero(movementHandle:MovementHandle)
	Util(customNewCell:CustomNewCell cellSet:CellSet cellGet:CellGet)
	PokeConfig(sQUARE_LENGTH:SQUARE_LENGTH hERO_SUBSAMPLE:HERO_SUBSAMPLE gRASS_ZOOM:GRASS_ZOOM dELAY:DELAY wild_Pokemon_proba:Wild_Pokemon_proba pathPokeTotal:PathPokeTotal pathTrainersTotal:PathTrainersTotal)
	
	DisplayMap(heroPosition:HeroPosition pokeHandle:PokeHandle pokePosition:PokePosition squareLengthFloat:SquareLengthFloat fieldType:FieldType
					createAndDisplayHeroAndFollower:CreateAndDisplayHeroAndFollower createAndDisplayTrainer:CreateAndDisplayTrainer initMap:InitMap mapRecord:MapRecord drawMap:DrawMap
					startX:StartX startY:StartY)
	
	DisplayBattle(prepareBattle:PrepareBattle)
	Trainer(newTrainer:NewTrainer randomMove:RandomMove)
	Pokemoz(newPokemoz:NewPokemoz)
	Battle(runBattle:RunBattle)
	
export
	HeroTrainer
	
define
	HeroTrainer
	HeroHandler
	PokemOz
	MapRecord
	
	
	Trainer2
	TrainerHandle2
	TrainerPosX2=9
	TrainerPosY2=9
	PokeTrainer2
in
	{InitMap}
	{DrawMap MapRecord HeroTrainer} %	/!\ Concurrency! {DrawMap} need 'HeroHandler' that need the variables initialated in {DrawMap}
	
	HeroHandler = {CreateAndDisplayHeroAndFollower}
	PokemOz = {NewPokemoz state(type:grass num:1 name:bulbozar maxlife:20 currentLife:20 experience:0 level:5)}
	HeroTrainer = {NewTrainer state(x:StartX y:StartY pokemoz:PokemOz speed:5 movement:proc{$ P} 1=1 end handler:HeroHandler number:1 incombat:false movementStatus:idle())}

	
/*trainer 1*/
	local 
		Trainer1 TrainerHandle1 TrainerFrames1 TrainerCreation PokeTrainer1
		TrainerPosX1=5
		TrainerPosY1=5
	in 
		TrainerCreation = {CreateAndDisplayTrainer TrainerPosX1 TrainerPosY1 1} 
		TrainerHandle1 = TrainerCreation.handle
		TrainerFrames1 = TrainerCreation.frames
		PokeTrainer1 = {NewPokemoz state(type:grass num:7 name:squirtOz maxlife:20 currentLife:20 experience:0 level:5)}
		Trainer1 = {NewTrainer state(x:TrainerPosX1 y:TrainerPosY1 pokemoz:PokeTrainer1 speed:5 movement:{RandomMove Trainer1 TrainerFrames1} handler:TrainerHandle1 number:1 incombat:false movementStatus:idle())}
	end

/*trainer 2*/
	local 
		Trainer1 TrainerHandle1 TrainerFrames1 TrainerCreation PokeTrainer1
		TrainerPosX1=10
		TrainerPosY1=10
	in 
		TrainerCreation = {CreateAndDisplayTrainer TrainerPosX1 TrainerPosY1 2} 
		TrainerHandle1 = TrainerCreation.handle
		TrainerFrames1 = TrainerCreation.frames
		PokeTrainer1 = {NewPokemoz state(type:grass num:7 name:squirtOz maxlife:20 currentLife:20 experience:0 level:5)}
		Trainer1 = {NewTrainer state(x:TrainerPosX1 y:TrainerPosY1 pokemoz:PokeTrainer1 speed:5 movement:{RandomMove Trainer1 TrainerFrames1} handler:TrainerHandle1 number:2 incombat:false movementStatus:idle())}
	end
	
/*trainer 3*/
	local 
		Trainer1 TrainerHandle1 TrainerFrames1 TrainerCreation PokeTrainer1
		TrainerPosX1=7
		TrainerPosY1=7
	in 
		TrainerCreation = {CreateAndDisplayTrainer TrainerPosX1 TrainerPosY1 3} 
		TrainerHandle1 = TrainerCreation.handle
		TrainerFrames1 = TrainerCreation.frames
		PokeTrainer1 = {NewPokemoz state(type:grass num:7 name:squirtOz maxlife:20 currentLife:20 experience:0 level:5)}
		Trainer1 = {NewTrainer state(x:TrainerPosX1 y:TrainerPosY1 pokemoz:PokeTrainer1 speed:5 movement:{RandomMove Trainer1 TrainerFrames1} handler:TrainerHandle1 number:3 incombat:false movementStatus:idle())}
	end

/*trainer 4*/
	local 
		Trainer1 TrainerHandle1 TrainerFrames1 TrainerCreation PokeTrainer1
		TrainerPosX1=10
		TrainerPosY1=5
	in 
		TrainerCreation = {CreateAndDisplayTrainer TrainerPosX1 TrainerPosY1 4} 
		TrainerHandle1 = TrainerCreation.handle
		TrainerFrames1 = TrainerCreation.frames
		PokeTrainer1 = {NewPokemoz state(type:grass num:7 name:squirtOz maxlife:20 currentLife:20 experience:0 level:5)}
		Trainer1 = {NewTrainer state(x:TrainerPosX1 y:TrainerPosY1 pokemoz:PokeTrainer1 speed:5 movement:{RandomMove Trainer1 TrainerFrames1} handler:TrainerHandle1 number:4 incombat:false movementStatus:idle())}
	end

end

