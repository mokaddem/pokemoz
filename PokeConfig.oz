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
	{Show enterconfig}
	SQUARE_LENGTH = 32 % length of a standard square
	
	HERO_SUBSAMPLE = 1
	GRASS_ZOOM = 2
	POKE_ZOOM = 3
	
	DELAY = 200 % delay between the moves
	
	{Show enterconfig}
	PokeAttackDelay = DELAY div 3
	BarRegressionDelay = DELAY div 15
	{Show enterconfig}
	REAL_SPEED
	thread REAL_SPEED = ((10-Speed)*DELAY) end
	Trainer_Move_Proba = 70 % move probability (%)
	{Show enterconfig}
	HeroPosXDecal=~14
	HeroPosYDecal=0
	
	BAR_WIDTH = 12 % for Hp bars
	BAR_LENGTH = 200
	
	PathTrainersTotal = "Images/Trainers/overworld/"
	PathPokeTotal = "Images/Pokemon-overworld/"
	{Show enterconfig}
	%Parameter
	Wild_Pokemon_proba % encounter probability (%)
	Speed
	Autofight
	UnlockAllPok
	NormalTypeActivated
	PlayerName
	{Show enterconfig}
	proc {SaveValue FWild_Pokemon_proba FSpeed FAutofight FUnlockAllPok FNormalTypeActivated FPlayerName}
		{Show 8}
		Wild_Pokemon_proba = FWild_Pokemon_proba {Show 9}
		Speed = FSpeed {Show 10}
		Autofight = FAutofight {Show 11}
		UnlockAllPok = FUnlockAllPok {Show 12}
		NormalTypeActivated = FNormalTypeActivated {Show 13}
		PlayerName = FPlayerName {Show 14}
	end
	
	
end
