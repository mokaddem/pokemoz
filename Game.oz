functor

import
	System(show:Show)
	Open OS
	CutImages(allHeroFrames:AllHeroFrames)
	MoveHero(randomMove:RandomMove goTo:GoTo)
	Util(customNewCell:CustomNewCell cellGet:CellGet)
	PokeChoice(launchTheIntro:LaunchTheIntro)
	PokeConfig(starter:Starter checkAutoMove:CheckAutoMove checkMap:CheckMap)
	
	DisplayMap(createAndDisplayHeroAndFollower:CreateAndDisplayHeroAndFollower createAndDisplayTrainer:CreateAndDisplayTrainer initMap:InitMap mapRecord:MapRecord drawMap:DrawMap startX:StartX startY:StartY endX:EndX endY:EndY allowedPlace:AllowedPlace)
	Trainer(newTrainer:NewTrainer)
	Pokemoz(newPokemoz:NewPokemoz generateRandomPokemon:GenerateRandomPokemon)
	
export
	HeroTrainer
	InBattle
	
define
	IntroFinish

	HeroTrainer
	HeroHandler
	PokemOz
	MapRecord
	
	InBattle = {CustomNewCell false}
	
	proc {CreateTrainersPos X}
		N M 
	in 
		N = {OS.rand} mod {Width AllowedPlace} + 1
		M = {OS.rand} mod {Width AllowedPlace.1} + 1
		if {CellGet AllowedPlace.N.M} == 'occupied' then {CreateTrainersPos X} else X=pos(x:M y:N) end
	end
		
in
	IntroFinish = {LaunchTheIntro}
	{Wait IntroFinish}
	{InitMap {New Open.file init(name:CheckMap flags:[read])}}
	{DrawMap MapRecord HeroTrainer} %	/!\ Concurrency! {DrawMap} need 'HeroHandler' that need the variables initialated in {DrawMap}
	HeroHandler = {CreateAndDisplayHeroAndFollower}
	
	local Num Name Type MvtType in
		if CheckAutoMove then MvtType={GoTo {CellGet EndX} {CellGet EndY} AllHeroFrames} else MvtType=(proc{$ P} 1=1 end) end
		case Starter
		of 1 then Num=1 Name="BULBASOZ" Type=grass
		[]4 then Num=4 Name="CHARMADOZ" Type=fire
		else Num=7 Name="OZTIRTLE" Type=water
		end
		PokemOz = {NewPokemoz state(type:Type num:Num name:Name maxlife:20 currentLife:20 experience:0 level:5)}
		HeroTrainer = {NewTrainer state(x:{CellGet StartX} y:{CellGet StartY} pokemoz:PokemOz speed:5 movement:MvtType handler:HeroHandler number:1 movementStatus:idle() type:'player')}
	end

	
/*trainer 1*/
	local 
		Trainer1 TrainerHandle1 TrainerFrames1 TrainerCreation RandPos
		{CreateTrainersPos RandPos}
		{Show RandPos}
		TrainerPosX1
		TrainerPosY1
	in 
		TrainerPosX1=RandPos.x
		TrainerPosY1=RandPos.y
		TrainerCreation = {CreateAndDisplayTrainer TrainerPosX1 TrainerPosY1 1} 
		TrainerHandle1 = TrainerCreation.handle
		TrainerFrames1 = TrainerCreation.frames
		Trainer1 = {NewTrainer state(x:TrainerPosX1 y:TrainerPosY1 pokemoz:{GenerateRandomPokemon} speed:5 movement:{RandomMove TrainerFrames1} handler:TrainerHandle1 number:1 movementStatus:idle() type:'ia')}
	end

/*trainer 2*/
	local 
		Trainer1 TrainerHandle1 TrainerFrames1 TrainerCreation RandPos
		{CreateTrainersPos RandPos}
		TrainerPosX1
		TrainerPosY1
	in 
		TrainerPosX1=RandPos.x
		TrainerPosY1=RandPos.y
		TrainerCreation = {CreateAndDisplayTrainer TrainerPosX1 TrainerPosY1 2} 
		TrainerHandle1 = TrainerCreation.handle
		TrainerFrames1 = TrainerCreation.frames
		Trainer1 = {NewTrainer state(x:TrainerPosX1 y:TrainerPosY1 pokemoz:{GenerateRandomPokemon} speed:5 movement:{RandomMove TrainerFrames1} handler:TrainerHandle1 number:2 movementStatus:idle() type:'ia')}
	end
	
/*trainer 3*/
	local 
		Trainer1 TrainerHandle1 TrainerFrames1 TrainerCreation RandPos
		{CreateTrainersPos RandPos}
		TrainerPosX1
		TrainerPosY1
	in 
		TrainerPosX1=RandPos.x
		TrainerPosY1=RandPos.y
		TrainerCreation = {CreateAndDisplayTrainer TrainerPosX1 TrainerPosY1 3} 
		TrainerHandle1 = TrainerCreation.handle
		TrainerFrames1 = TrainerCreation.frames
		Trainer1 = {NewTrainer state(x:TrainerPosX1 y:TrainerPosY1 pokemoz:{GenerateRandomPokemon} speed:5 movement:{RandomMove TrainerFrames1} handler:TrainerHandle1 number:3 movementStatus:idle() type:'ia')}
	end

/*trainer 4*/
	local 
		Trainer1 TrainerHandle1 TrainerFrames1 TrainerCreation RandPos
		{CreateTrainersPos RandPos}
		TrainerPosX1
		TrainerPosY1
	in 
		TrainerPosX1=RandPos.x
		TrainerPosY1=RandPos.y
		TrainerCreation = {CreateAndDisplayTrainer TrainerPosX1 TrainerPosY1 4} 
		TrainerHandle1 = TrainerCreation.handle
		TrainerFrames1 = TrainerCreation.frames
		Trainer1 = {NewTrainer state(x:TrainerPosX1 y:TrainerPosY1 pokemoz:{GenerateRandomPokemon} speed:5 movement:{RandomMove TrainerFrames1} handler:TrainerHandle1 number:4 movementStatus:idle() type:'ia')}
	end

end

