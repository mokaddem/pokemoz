functor
import
	System(show:Show)
	OS
export
	RunAutoBattle
	Attack
define
	/* 
	 * Pok1 attacks first
	 */
	proc {RunAutoBattle Pok1 Pok2}
		Hp1 Hp2 in
		{Pok1 getHp(Hp1)}
		{Pok2 getHp(Hp2)}
		if Hp1 > 0 then if Hp2 > 0 then {Attack Pok1 Pok2} {RunAutoBattle Pok1 Pok2} end end
	end
	
	proc {Attack Pok1 Pok2}
		Name1 Name2 Type1 Type2 Damage Hp1 Hp2 Level1 Level2 in
		{Pok1 getType(Type1)}
		{Pok2 getType(Type2)}
		{Pok1 getName(Name1)}
		{Pok2 getName(Name2)}
		{Pok1 getLevel(Level1)}
		{Pok2 getLevel(Level2)}
		Damage = {GetDamage Type1 Type2 Level1 Level2}
		{Show Name1#' attacks'}
		{Pok2 damage(Damage)}
		{Pok2 getHp(Hp2)}
		if Hp2 > 0 then
			Damage2 in Damage2 = {GetDamage Type2 Type1 Level2 Level1}
			{Show Name2#' attacks'}
			{Pok1 damage(Damage2)}
		else
			{Pok1 'exp'(Level2)}
		end
	end
	
	fun {GetDamage AtkType DefType AtkLvl DefLvl}
		if({OS.rand} mod 100 > (6 + AtkLvl - DefLvl) * 9) then 0
		else case AtkType
			of grass then
				case DefType
				of grass then 2
				[] fire then 1
				[] water then 3
				end
			[] fire then
				case DefType
				of grass then 3
				[] fire then 2
				[] water then 1
				end
			[] water then
				case DefType
				of grass then 1
				[] fire then 3
				[] water then 2
				end
			end
		end
	end
	
	fun {WannaRun}
		{Show 'You dont want to run'}
		'false'
	end
end
