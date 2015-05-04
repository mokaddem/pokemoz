functor	
export
	SQUARE_LENGTH
	
	HERO_SUBSAMPLE
	GRASS_ZOOM
	POKE_ZOOM
	
	CheckMap
	CustomMap
	DELAY
	REAL_SPEED
	Combat_Speed
	PokeAttackDelay
	BarRegressionDelay
	
	Wild_Pokemon_proba
	Trainer_Move_Proba
	Trainer_Max_Foot_Number
	
	Autofight
	CheckAutoMove
	
	HeroPosXDecal
	HeroPosYDecal
	
	BAR_WIDTH
	BAR_LENGTH	
	
	PathTrainersTotal
	PathPokeTotal
	
	Starter
	UnlockAllPok
	MAXPOKENUMBER
	
	SaveValue
	SaveStarter
	
	MAX_ENNEMY_EXP
define
	SQUARE_LENGTH = 32 % length of a standard square
	
	HERO_SUBSAMPLE = 1
	GRASS_ZOOM = 2
	POKE_ZOOM = 3
	
	DELAY = 200 % delay between the moves
	
	MAXPOKENUMBER = 386 % total number of availbe pokemoz 
	
	PokeAttackDelay = DELAY div 2
	BarRegressionDelay = DELAY div 15
	REAL_SPEED
	thread REAL_SPEED = ((10-Speed)*DELAY) end
	Trainer_Move_Proba = 70 % move probability (%)
	Trainer_Max_Foot_Number
	thread Trainer_Max_Foot_Number = 3 div CheckTrain end
	
	HeroPosXDecal=~14
	HeroPosYDecal=0
	
	BAR_WIDTH = 12 % for Hp bars
	BAR_LENGTH = 200
	
	MAX_ENNEMY_EXP
	thread MAX_ENNEMY_EXP = 55-(3-Difficulty)*(54 div 3) end
	
	PathTrainersTotal = "Images/Trainers/"
	PathPokeTotal = "Images/Pokemon-overworld/"
	
	%Parameter
	Wild_Pokemon_proba % encounter probability (%)
	Speed
	Combat_Speed
	Difficulty
	Autofight	%0=manual 1=autofight 2=autorun
	CheckAutoMove
	UnlockAllPok
	CheckMap
	CustomMap
	CheckTrain
	Starter
	
	proc {SaveValue FWild_Pokemon_proba FSpeed FAutofight FUnlockAllPok FCheckMap FCheckTrain FCheckAutoMove FCombat_Speed FDifficulty}
		Wild_Pokemon_proba = FWild_Pokemon_proba
		Speed = FSpeed
		if FAutofight.1 then Autofight=0 elseif FAutofight.2.1 then Autofight=1 else Autofight=2 end
		if FCheckMap then CheckMap='mapX.txt' CustomMap=true else CheckMap='map.txt' CustomMap=false end
		if FCheckTrain then CheckTrain=1 else CheckTrain=3 end 
		UnlockAllPok = FUnlockAllPok
		CheckAutoMove = FCheckAutoMove
		if FCombat_Speed == 0 then Combat_Speed=100 else Combat_Speed = FCombat_Speed*20 end
		Difficulty = FDifficulty
	end
	
	proc {SaveStarter X}
		Starter = X
	end
	
end
