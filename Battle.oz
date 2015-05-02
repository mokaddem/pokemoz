functor
import
	System(show:Show)
	OS
	DisplayBattle(drawHpBar:DrawHpBar computeBarLength:ComputeBarLength doTheBarAnimation:DoTheBarAnimation doThePokeAttackAnimation:DoThePokeAttackAnimation)
export
	RunAutoBattle
	Attack
define
	/* 
	 * Pok1 attacks first
	 */
	proc {RunAutoBattle Pok1 Pok2 TrainerPort UI_Components HpRecord PokeTagsRecord}
		Hp1 Hp2 in
		{Pok1 getHp(Hp1)}
		{Pok2 getHp(Hp2)}
		if Hp1 > 0 then if Hp2 > 0 then {Attack Pok1 Pok2 TrainerPort UI_Components HpRecord PokeTagsRecord} {RunAutoBattle Pok1 Pok2 TrainerPort UI_Components HpRecord PokeTagsRecord} end end
	end
	
	proc {Attack Pok1 Pok2 TrainerPort UI_Components HpRecord PokeTagsRecord}
		Name1 Name2 Type1 Type2 Damage Hp1C Hp1P Hp2C Hp2P Hp2Max Hp1Max Level1 Level2 
		MiPvBarTag = HpRecord.miBar	OpPvBarTag = HpRecord.opBar
		MiPvTxtTag = HpRecord.miTxt	OpPvTxtTag = HpRecord.opTxt
		MiPokeTag = PokeTagsRecord.mi	OpPokeTag = PokeTagsRecord.op
		CoordOp
		CoordMi
		in
		{Pok1 getType(Type1)}
		{Pok2 getType(Type2)}
		{Pok1 getName(Name1)}
		{Pok2 getName(Name2)}
		{Pok1 getLevel(Level1)}
		{Pok2 getLevel(Level2)}
		Damage = {GetDamage Type1 Type2 Level1 Level2}
		{Show Name1#' attacks'}
		{Pok2 getHp(Hp2P)}
		{Pok2 damage(Damage)}
		
		{OpPvBarTag getCoords(1:CoordOp)}
		{Pok2 getHp(Hp2C)} 
		{Pok2 getHpMax(Hp2Max)}
		{Wait Hp2Max} 		{Wait Hp2C}
		{DoThePokeAttackAnimation MiPokeTag true}
		local X1 X2 Y1 Y2 BarLen PBarLen in
			X1 = {FloatToInt {String.toFloat {VirtualString.toString CoordOp.1}}}
			X2 = {FloatToInt {String.toFloat {VirtualString.toString CoordOp.2.2.1}}}
			Y1 = {FloatToInt {String.toFloat {VirtualString.toString CoordOp.2.1}}}
			Y2 = {FloatToInt {String.toFloat {VirtualString.toString CoordOp.2.2.2.1}}}
			PBarLen = {ComputeBarLength Hp2P Hp2Max}
			BarLen = {ComputeBarLength Hp2C Hp2Max}
			{DoTheBarAnimation OpPvTxtTag OpPvBarTag X1 Y1 BarLen PBarLen X2 Y2 Hp2P Hp2C Hp2Max}
		end

		
		if Hp2C > 0 then
			Damage2 in Damage2 = {GetDamage Type2 Type1 Level2 Level1}
			{Show Name2#' attacks'}
			{Pok1 getHp(Hp1P)}
			{Pok1 damage(Damage2)}
			{MiPvBarTag getCoords(1:CoordMi)}
			{Pok1 getHp(Hp1C)}
			{Pok1 getHpMax(Hp1Max)}
			{Wait Hp1Max} 		{Wait Hp1C}
			{DoThePokeAttackAnimation OpPokeTag false}
			local X1 X2 Y1 Y2 BarLen PBarLen in
				X1 = {FloatToInt {String.toFloat {VirtualString.toString CoordMi.1}}}
				X2 = {FloatToInt {String.toFloat {VirtualString.toString CoordMi.2.2.1}}}
				Y1 = {FloatToInt {String.toFloat {VirtualString.toString CoordMi.2.1}}}
				Y2 = {FloatToInt {String.toFloat {VirtualString.toString CoordMi.2.2.2.1}}}
				PBarLen = {ComputeBarLength Hp1P Hp2Max}
				BarLen = {ComputeBarLength Hp1C Hp1Max}
				{DoTheBarAnimation MiPvTxtTag MiPvBarTag X1 Y1 BarLen PBarLen X2 Y2 Hp1P Hp1C Hp1Max}
			end
			
			if Hp1C =< 0 then
				{Delay 1000}
				{UI_Components.window close} 
				{UI_Components.ui_control_window close}
				{TrainerPort setInCombat(false)}
			end
		else
			{Pok1 'exp'(Level2)}
			{Delay 1000}
			{UI_Components.window close} 
			{UI_Components.ui_control_window close}
			{TrainerPort setInCombat(false)}
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
end
