functor
import
	System(show:Show)
export
	RunBattle
define
	/* 
	 * Pok1 attacks first
	 */
	proc {RunBattle Pok1 Pok2}
		Name1 Name2 Type1 Type2 Damage Hp2 in
		{Send Pok1 getType(Type1)}
		{Send Pok2 getType(Type2)}
		{Send Pok1 getName(Name1)}
		{Send Pok2 getName(Name2)}
		Damage = {GetDamage Type1 Type2}
		{Send Pok2 damage(Damage)}
		{Send Pok2 getHp(Hp2)}
		{Show Name1#' did '#Damage#' damage to '#Name2}
		if {WannaRun} == 'true' then
			{Show 'Run, you fool!'}
		else if Hp2 > 0 then {RunBattle Pok2 Pok1} end
		end
		
	end
	
	fun {GetDamage AtkType DefType}
		case AtkType
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
	
	fun {WannaRun}
		{Show 'You dont want to run'}
		'false'
	end
end
