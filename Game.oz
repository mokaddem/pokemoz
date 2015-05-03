functor

import
	System(show:Show)
	Open
	QTk at 'x-oz://system/wp/QTk.ozf'

	CutImages(heroFace:HeroFace pokeFace:PokeFace allHeroFrames:AllHeroFrames grass_Tile:Grass_Tile road_Tile:Road_Tile)
	MoveHero(movementHandle:MovementHandle)
	Util(customNewCell:CustomNewCell cellSet:CellSet cellGet:CellGet)
	PokeChoice(launchTheIntro:LaunchTheIntro)
	PokeConfig(sQUARE_LENGTH:SQUARE_LENGTH hERO_SUBSAMPLE:HERO_SUBSAMPLE gRASS_ZOOM:GRASS_ZOOM dELAY:DELAY wild_Pokemon_proba:Wild_Pokemon_proba pathPokeTotal:PathPokeTotal pathTrainersTotal:PathTrainersTotal starter:Starter)
	
	DisplayMap(heroPosition:HeroPosition pokeHandle:PokeHandle pokePosition:PokePosition squareLengthFloat:SquareLengthFloat fieldType:FieldType
					createAndDisplayHeroAndFollower:CreateAndDisplayHeroAndFollower createAndDisplayTrainer:CreateAndDisplayTrainer initMap:InitMap mapRecord:MapRecord drawMap:DrawMap
					startX:StartX startY:StartY launchGameOver:LaunchGameOver)
	
	DisplayBattle(prepareBattle:PrepareBattle)
	Trainer(newTrainer:NewTrainer randomMove:RandomMove goTo:GoTo)
	Pokemoz(newPokemoz:NewPokemoz)
	Battle(runBattle:RunBattle)
	
export
	HeroTrainer
	InBattle
	GameOver
	
define
	IntroFinish
	GameOver

	HeroTrainer
	HeroHandler
	PokemOz
	MapRecord
	
	Trainer2
	TrainerHandle2
	TrainerPosX2=9
	TrainerPosY2=9
	PokeTrainer2
	
	InBattle = {CustomNewCell false}
in
	IntroFinish = {LaunchTheIntro}
	{Wait IntroFinish}
	thread if GameOver then {Show 'GAME OVER'} {CellSet InBattle true} {LaunchGameOver} end end
	{InitMap}
	{DrawMap MapRecord HeroTrainer} %	/!\ Concurrency! {DrawMap} need 'HeroHandler' that need the variables initialated in {DrawMap}
	HeroHandler = {CreateAndDisplayHeroAndFollower}
	
	local Num Name Type in
		case Starter
		of 1 then Num=1 Name="BULBASOZ" Type=grass
		[]4 then Num=4 Name="CHARMADOZ" Type=fire
		else Num=7 Name="OZTIRTLE" Type=water
		end
		PokemOz = {NewPokemoz state(type:Type num:Num name:Name maxlife:20 currentLife:20 experience:0 level:5)}
		HeroTrainer = {NewTrainer state(x:StartX y:StartY pokemoz:PokemOz speed:5 movement:{GoTo 9 1 AllHeroFrames} handler:HeroHandler number:1 movementStatus:idle() type:'player')}
		end

	
/*trainer 1*/
	local 
		Trainer1 TrainerHandle1 TrainerFrames1 TrainerCreation PokeTrainer1
		TrainerPosX1=5
		TrainerPosY1=5
	in 
		TrainerCreation = {CreateAndDisplayTrainer TrainerPosX1 TrainerPosY1 1} 
		TrainerHandle1 = TrainerCreation.handle
		TrainerFrames1 = TrainerCreation.frames
		PokeTrainer1 = {NewPokemoz state(type:water num:7 name:"OZTIRTLE1" maxlife:20 currentLife:20 experience:0 level:5)}
		Trainer1 = {NewTrainer state(x:TrainerPosX1 y:TrainerPosY1 pokemoz:PokeTrainer1 speed:5 movement:{RandomMove TrainerFrames1} handler:TrainerHandle1 number:1 movementStatus:idle() type:'ia')}
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
		PokeTrainer1 = {NewPokemoz state(type:water num:7 name:"OZTIRTLE2" maxlife:20 currentLife:20 experience:0 level:5)}
		Trainer1 = {NewTrainer state(x:TrainerPosX1 y:TrainerPosY1 pokemoz:PokeTrainer1 speed:5 movement:{RandomMove TrainerFrames1} handler:TrainerHandle1 number:2 movementStatus:idle() type:'ia')}
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
		PokeTrainer1 = {NewPokemoz state(type:water num:7 name:"OZTIRTLE3" maxlife:20 currentLife:20 experience:0 level:5)}
		Trainer1 = {NewTrainer state(x:TrainerPosX1 y:TrainerPosY1 pokemoz:PokeTrainer1 speed:5 movement:{RandomMove TrainerFrames1} handler:TrainerHandle1 number:3 movementStatus:idle() type:'ia')}
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
		PokeTrainer1 = {NewPokemoz state(type:water num:7 name:"OZTIRTLE4" maxlife:20 currentLife:20 experience:0 level:5)}
		Trainer1 = {NewTrainer state(x:TrainerPosX1 y:TrainerPosY1 pokemoz:PokeTrainer1 speed:5 movement:{RandomMove TrainerFrames1} handler:TrainerHandle1 number:4 movementStatus:idle() type:'ia')}
	end

end

