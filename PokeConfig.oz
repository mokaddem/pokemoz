functor
import 
	System(show:Show)
	
export
	SQUARE_LENGTH
	
	HERO_SUBSAMPLE
	GRASS_ZOOM
	POKE_ZOOM
	
	DELAY
	REAL_SPEED
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
	
	SaveValue
	SaveStarter
define
	SQUARE_LENGTH = 32 % length of a standard square
	
	HERO_SUBSAMPLE = 1
	GRASS_ZOOM = 2
	POKE_ZOOM = 3
	
	DELAY = 200 % delay between the moves
	
	PokeAttackDelay = DELAY div 2
	BarRegressionDelay = DELAY div 15
	REAL_SPEED
	thread REAL_SPEED = ((10-Speed)*DELAY) end
	Trainer_Move_Proba = 70 % move probability (%)
	Trainer_Max_Foot_Number = 3
	
	HeroPosXDecal=~14
	HeroPosYDecal=0
	
	BAR_WIDTH = 12 % for Hp bars
	BAR_LENGTH = 200
	
	PathTrainersTotal = "Images/Trainers/"
	PathPokeTotal = "Images/Pokemon-overworld/"
	
	%Parameter
	Wild_Pokemon_proba % encounter probability (%)
	Speed
	Autofight	%0=manual 1=autofight 2=autorun
	CheckAutoMove
	UnlockAllPok
	NormalTypeActivated
	PlayerName
	Starter
	
	proc {SaveValue FWild_Pokemon_proba FSpeed FAutofight FUnlockAllPok FNormalTypeActivated FPlayerName FCheckAutoMove}
		Wild_Pokemon_proba = FWild_Pokemon_proba
		Speed = FSpeed
		if FAutofight.1 then Autofight=0 elseif FAutofight.2.1 then Autofight=1 else Autofight=2 end
		{Show FAutofight}
		{Show Autofight}
		UnlockAllPok = FUnlockAllPok
		NormalTypeActivated = FNormalTypeActivated
		PlayerName = FPlayerName
		CheckAutoMove = FCheckAutoMove
	end
	
	proc {SaveStarter X}
		Starter = X
	end
	
end
