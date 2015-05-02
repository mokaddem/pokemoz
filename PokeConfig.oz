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
	
	HeroPosXDecal
	HeroPosYDecal
	
	BAR_WIDTH
	BAR_LENGTH
	
define
	SQUARE_LENGTH = 32 % length of a standard square
	
	HERO_SUBSAMPLE = 1
	GRASS_ZOOM = 2
	POKE_ZOOM = 3
	
	DELAY = 200 % delay between the moves
	PokeAttackDelay = DELAY div 3
	BarRegressionDelay = DELAY div 15
	
	Wild_Pokemon_proba = 70 % encounter probability (%)
	Trainer_Move_Proba = 70 % move probability (%)
	
	HeroPosXDecal=~14
	HeroPosYDecal=0
	
	BAR_WIDTH = 12 % for Hp bars
	BAR_LENGTH = 200
end
