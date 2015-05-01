functor

import
	System(show:Show)
	Open
	QTk at 'x-oz://system/wp/QTk.ozf'

	CutImages(heroFace:HeroFace pokeFace:PokeFace grass_Tile:Grass_Tile road_Tile:Road_Tile)
	MoveHero(movementHandle:MovementHandle)
	Util(customNewCell:CustomNewCell cellSet:CellSet cellGet:CellGet)
	PokeConfig(sQUARE_LENGTH:SQUARE_LENGTH hERO_SUBSAMPLE:HERO_SUBSAMPLE gRASS_ZOOM:GRASS_ZOOM dELAY:DELAY wild_Pokemon_proba:Wild_Pokemon_proba)
	
	DisplayMap(heroPosition:HeroPosition pokeHandle:PokeHandle pokePosition:PokePosition squareLengthFloat:SquareLengthFloat fieldType:FieldType
					createAndDisplayHeroAndFollower:CreateAndDisplayHeroAndFollower createAndDisplayTrainer:CreateAndDisplayTrainer mapRecord:MapRecord drawMap:DrawMap
					startX:StartX startY:StartY)
	
	DisplayBattle(prepareBattle:PrepareBattle)
	Trainer(newTrainer:NewTrainer)
	Pokemoz(newPokemoz:NewPokemoz)
	Battle(runBattle:RunBattle)
	
export
	HeroTrainer
define
	HeroTrainer
	HeroHandler
	PokemOz
	
	Trainer1
	TrainerHandle1
	TrainerPosX1=2
	TrainerPosY1=3
	PokeTrainer1
in
	{DrawMap MapRecord HeroTrainer} %	/!\ Concurrency! {DrawMap} need 'HeroHandler' that need the variables initialated in {DrawMap}
	HeroHandler = {CreateAndDisplayHeroAndFollower}
	PokemOz = {NewPokemoz state(type:grass num:1 name:bulbozar maxlife:20 currentLife:20 experience:0 level:5)}
	HeroTrainer = {NewTrainer state(x:StartX y:StartY pokemoz:PokemOz speed:5 movement:proc{$ P} 1=1 end handler:HeroHandler)}
	
	
	TrainerHandle1 = {CreateAndDisplayTrainer TrainerPosX1 TrainerPosY1}
	PokeTrainer1 = {NewPokemoz state(type:grass num:7 name:squirtOz maxlife:20 currentLife:20 experience:0 level:5)}
	Trainer1 = {NewTrainer state(x:TrainerPosX1 y:TrainerPosY1 pokemoz:PokemOz speed:5 movement:proc{$ P} 1=1 end handler:TrainerHandle1)}
	
	

end

