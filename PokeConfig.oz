functor
import 
	System(show:Show)
	
export
	SQUARE_LENGTH
	
	HERO_SUBSAMPLE
	GRASS_ZOOM
	POKE_ZOOM
	
	DELAY
	PokeAttackDelay
	BarRegressionDelay
	
	Wild_Pokemon_proba
	Trainer_Move_Proba
	
	HeroPosXDecal
	HeroPosYDecal
	
	BAR_WIDTH
	BAR_LENGTH	
	
	PathTrainersTotal
	PathPokeTotal
	
	SaveValue
	
define
	SQUARE_LENGTH = 32 % length of a standard square
	
	HERO_SUBSAMPLE = 1
	GRASS_ZOOM = 2
	POKE_ZOOM = 3
	
	DELAY = 200 % delay between the moves
	
	PokeAttackDelay = DELAY div 3
	BarRegressionDelay = DELAY div 15
	REAL_SPEED
	thread REAL_SPEED = ((10-Speed)*DELAY) end
	Trainer_Move_Proba = 70 % move probability (%)
	HeroPosXDecal=~14
	HeroPosYDecal=0
	
	BAR_WIDTH = 12 % for Hp bars
	BAR_LENGTH = 200
	
	PathTrainersTotal = "Images/Trainers/overworld/"
	PathPokeTotal = "Images/Pokemon-overworld/"
	
	%Parameter
	Wild_Pokemon_proba % encounter probability (%)
	Speed
	Autofight
	UnlockAllPok
	NormalTypeActivated
	PlayerName
	Starter
	
	proc {SaveValue FWild_Pokemon_proba FSpeed FAutofight FUnlockAllPok FNormalTypeActivated FPlayerName}
		Wild_Pokemon_proba = FWild_Pokemon_proba
		Speed = FSpeed
		Autofight = FAutofight
		UnlockAllPok = FUnlockAllPok
		NormalTypeActivated = FNormalTypeActivated
		PlayerName = FPlayerName
	end
	
	proc {SaveStarter X}
		Starter = X
	end
	
end
