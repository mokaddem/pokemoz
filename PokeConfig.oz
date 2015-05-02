functor
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
	Trainer_MoveS_Speed
	
	BAR_WIDTH
	BAR_LENGTH
	
define
	SQUARE_LENGTH = 32 % length of a standard square
	
	HERO_SUBSAMPLE = 1
	GRASS_ZOOM = 2
	POKE_ZOOM = 3
	
	DELAY = 200 % delay between the moves
	SPEED = 7 %[0,10]
	PokeAttackDelay = DELAY div 3
	BarRegressionDelay = DELAY div 15
	
	Wild_Pokemon_proba = 70 % encounter probability (%)
	Trainer_Move_Proba = 70 % move probability (%)
	Trainer_MoveS_Speed = ((10-SPEED)*DELAY)
	
	BAR_WIDTH = 12 % for Hp bars
	BAR_LENGTH = 200
end
