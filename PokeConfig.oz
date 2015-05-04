functor
import 
	System(show:Show)
	Util(customNewCell:CustomNewCell)
	
export
	SQUARE_LENGTH
	
	HERO_SUBSAMPLE
	GRASS_ZOOM
	POKE_ZOOM
	
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
	PokeAttackDelayCell = {CustomNewCell (DELAY div 2)}
	BarRegressionDelay = DELAY div 15
	REAL_SPEED
	thread REAL_SPEED = ((10-Speed)*DELAY) end
	Trainer_Move_Proba = 70 % move probability (%)
	Trainer_Max_Foot_Number = 3
	
	HeroPosXDecal=~14
	HeroPosYDecal=0
	
	BAR_WIDTH = 12 % for Hp bars
	BAR_LENGTH = 200
	
	MAX_ENNEMY_EXP = 51
	
	PathTrainersTotal = "Images/Trainers/"
	PathPokeTotal = "Images/Pokemon-overworld/"
	
	%Parameter
	Wild_Pokemon_proba % encounter probability (%)
	Speed
	Combat_Speed
	Autofight	%0=manual 1=autofight 2=autorun
	CheckAutoMove
	UnlockAllPok
	PlayerName
	Starter
	
	proc {SaveValue FWild_Pokemon_proba FSpeed FAutofight FUnlockAllPok FPlayerName FCheckAutoMove FCombat_Speed}
		Wild_Pokemon_proba = FWild_Pokemon_proba
		Speed = FSpeed
		if FAutofight.1 then Autofight=0 elseif FAutofight.2.1 then Autofight=1 else Autofight=2 end
		{Show FAutofight}
		{Show Autofight}
		UnlockAllPok = FUnlockAllPok
		PlayerName = FPlayerName
		CheckAutoMove = FCheckAutoMove
		if FCombat_Speed == 0 then Combat_Speed=100 else Combat_Speed = FCombat_Speed*40 end
	end
	
	proc {SaveStarter X}
		Starter = X
	end
	
end
