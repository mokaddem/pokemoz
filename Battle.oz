functor
import
	System(show:Show)
	OS
export
	RunBattle
define
	/* 
	 * Pok1 attacks first
	 */
	proc {RunBattle Pok1 Pok2}
		Name1 Name2 Type1 Type2 Damage Hp2 Level1 Level2 in
		{Send Pok1 getType(Type1)}
		{Send Pok2 getType(Type2)}
		{Send Pok1 getName(Name1)}
		{Send Pok2 getName(Name2)}
		{Send Pok1 getLevel(Level1)}
		{Send Pok2 getLevel(Level2)}
		Damage = {GetDamage Type1 Type2 Level1 Level2}
		{Send Pok2 damage(Damage)}
		{Send Pok2 getHp(Hp2)}
		{Show Name1#' did '#Damage#' damage to '#Name2}
		if {WannaRun} == 'true' then
			{Show 'Run, you fool!'}
		else
			if Hp2 > 0 then 
				{RunBattle Pok2 Pok1}
			else
				{Show Name2#' fainted'}
				{Send Pok1 'exp'(Level2)}
				{Show Name1#' earn exp : '#Level2}
			end
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
