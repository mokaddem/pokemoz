functor
import
	System(show:Show)
	OS
	Util(cellSet:CellSet)
	PokeConfig(combat_Speed:Combat_Speed)
	Game(inBattle:InBattle gameOver:GameOver)
	DisplayBattle(computeBarLength:ComputeBarLength doTheBarAnimation:DoTheBarAnimation doThePokeAttackAnimation:DoThePokeAttackAnimation doTheXpBarAnimation:DoTheXpBarAnimation doTheFaintAnim:DoTheFaintAnim doTheEvolution:DoTheEvolution)
	DisplayMap(launchGameOver:LaunchGameOver)
export
	RunAutoBattle
	Attack
define
	/* 
	 * Pok1 attacks first
	 */
	proc {RunAutoBattle Pok1 Pok2 Window HpRecord PokeTagsRecord DialogText}
		Hp1 Hp2 in
		{Pok1 getHp(Hp1)}
		{Pok2 getHp(Hp2)}
		if Hp1 > 0 then if Hp2 > 0 then {Attack Pok1 Pok2 Window HpRecord PokeTagsRecord DialogText} {RunAutoBattle Pok1 Pok2 Window HpRecord PokeTagsRecord DialogText} end end
	end
	
	proc {Attack Pok1 Pok2 Window HpRecord PokeTagsRecord DialogText}
		Name1 Name2 Type1 Type2 OpNumber Damage Hp1C Hp1P Hp2C Hp2P Hp2Max Hp1Max Level1 Level2 
		MiPvBarTag = HpRecord.miBar	OpPvBarTag = HpRecord.opBar
		MiPvTxtTag = HpRecord.miTxt	OpPvTxtTag = HpRecord.opTxt
		MiPokeTag = PokeTagsRecord.mi	OpPokeTag = PokeTagsRecord.op
		in
		{Pok2 getHp(Hp2P)} {Pok2 getHpMax(Hp2Max)}
		{Pok1 getHp(Hp1P)} {Pok1 getHpMax(Hp1Max)}
		{Pok1 getType(Type1)}
		{Pok2 getType(Type2)}
		{Pok1 getName(Name1)}
		{Pok2 getName(Name2)}
		{Pok2 getAdjustedNum(OpNumber)}
		{Pok1 getLevel(Level1)}
		{Pok2 getLevel(Level2)}
		Damage = {GetDamage Type1 Type2 Level1 Level2}
		{Show Name1#' attacks'}
		{Pok2 damage(Damage)}
		
%		{DialogText set(text:"A")}
		
		{Pok2 getHp(Hp2C)} 
		{DialogText set(text:{Append Name1 " Attack!"})}
		{Delay Combat_Speed*5}
		{DoThePokeAttackAnimation MiPokeTag OpNumber true}
		local PBarLen BarLen in
			PBarLen = {ComputeBarLength Hp2P Hp2Max}
			BarLen = {ComputeBarLength Hp2C Hp2Max}
			{DoTheBarAnimation OpPvTxtTag OpPvBarTag BarLen PBarLen Hp2P Hp2C Hp2Max}
		end
		
		if Hp2C > 0 then
			Damage2 in Damage2 = {GetDamage Type2 Type1 Level2 Level1}
			{Show Name2#' attacks'}
			{Pok1 damage(Damage2)}			
			{Pok1 getHp(Hp1C)}
			{DialogText set(text:{Append "Enemy " {Append Name2 " Attack!"}})}
			{Delay Combat_Speed*5}
			{DoThePokeAttackAnimation OpPokeTag OpNumber false}
			local PBarLen BarLen in 
				PBarLen = {ComputeBarLength Hp1P Hp1Max}
				BarLen = {ComputeBarLength Hp1C Hp1Max}
				{DoTheBarAnimation MiPvTxtTag MiPvBarTag BarLen PBarLen Hp1P Hp1C Hp1Max}
			end
			
			if Hp1C =< 0 then
				{DialogText set(text:{Append "Your " {Append Name1 " fainted!"}})}
				{Delay Combat_Speed*5}
				{DoTheFaintAnim MiPokeTag}

				{Window close} 
				{CellSet InBattle true}
				GameOver=true
				{LaunchGameOver false}
			end
		else
			local PBarLen BarLen XpC XpP XpNeeded E1 E2 in 
				{Pok1 getExp(XpP)}
				{Pok1 getEvolution(E1)}
				{Pok1 getExpNeeded(XpNeeded)}
				{Pok1 'exp'(Level2)}
				{Pok1 getExp(XpC)}
				{Pok1 getEvolution(E2)}
				{Show 'bla'#E1#E2}
				PBarLen = {ComputeBarLength XpP XpNeeded}
				BarLen = {ComputeBarLength XpC XpNeeded}
				{Show PBarLen#BarLen}
				{DoTheXpBarAnimation BarLen PBarLen HpRecord.expBar HpRecord.lvlTxt}
				if E2>E1 then {DoTheEvolution Pok1} end
			end
			{DialogText set(text:{Append "Enemy " {Append Name2 " fainted!"}})}
			{Delay Combat_Speed*5}
			{DoTheFaintAnim OpPokeTag}
			{Window close} 
			{CellSet InBattle false}
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
				else 2
				end
			[] fire then
				case DefType
				of grass then 3
				[] fire then 2
				[] water then 1
				else 2
				end
			[] water then
				case DefType
				of grass then 1
				[] fire then 3
				[] water then 2
				else 2
				end
			else
				2
			end
		end
	end
end
