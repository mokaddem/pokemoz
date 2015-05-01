functor
import
	System(show:Show)
	OS
	DisplayBattle(drawHpBar:DrawHpBar computeBarLength:ComputeBarLength)
export
	RunAutoBattle
	Attack
define
	/* 
	 * Pok1 attacks first
	 */
	proc {RunAutoBattle Pok1 Pok2 TrainerPort UI_Components HpBarRecord}
		Hp1 Hp2 in
		{Pok1 getHp(Hp1)}
		{Pok2 getHp(Hp2)}
		if Hp1 > 0 then if Hp2 > 0 then {Attack Pok1 Pok2 TrainerPort UI_Components HpBarRecord} {RunAutoBattle Pok1 Pok2 TrainerPort UI_Components HpBarRecord} end end
	end
	
	proc {Attack Pok1 Pok2 TrainerPort UI_Components HpBarRecord}
		Name1 Name2 Type1 Type2 Damage Hp1 Hp2 Hp2Max Hp1Max Level1 Level2 
		MiPvBarTag = HpBarRecord.mi
		OpPvBarTag = HpBarRecord.op
		CoordOp
		CoordMi
		NewMiPvBarTag
		NewOpPvBarTag
		in
		{Pok1 getType(Type1)}
		{Pok2 getType(Type2)}
		{Pok1 getName(Name1)}
		{Pok2 getName(Name2)}
		{Pok1 getLevel(Level1)}
		{Pok2 getLevel(Level2)}
		Damage = {GetDamage Type1 Type2 Level1 Level2}
		{Show Name1#' attacks'}
		{Pok2 damage(Damage)}
		
		{OpPvBarTag getCoords(1:CoordOp)}
		{Pok2 getHp(Hp2)} 
		{Pok2 getHpMax(Hp2Max)}
		{Wait Hp2Max} 		{Wait Hp2}
		local X1 X2 Y1 Y2 BarLen in
			X1 = {FloatToInt {String.toFloat {VirtualString.toString CoordOp.1}}}
			X2 = {FloatToInt {String.toFloat {VirtualString.toString CoordOp.2.2.1}}}
			Y1 = {FloatToInt {String.toFloat {VirtualString.toString CoordOp.2.1}}}
			Y2 = {FloatToInt {String.toFloat {VirtualString.toString CoordOp.2.2.2.1}}}
			{Show {ComputeBarLength X2-X1 Hp2 Hp2Max}}
			BarLen = {ComputeBarLength X2-X1 Hp2 Hp2Max}
			{OpPvBarTag setCoords(X1 Y1 X1+BarLen Y2)}
		end

		
		if Hp2 > 0 then
			Damage2 in Damage2 = {GetDamage Type2 Type1 Level2 Level1}
			{Show Name2#' attacks'}
			{Pok1 damage(Damage2)}
			{MiPvBarTag getCoords(1:CoordMi)}
			{Pok1 getHp(Hp1)}
			{Pok1 getHpMax(Hp1Max)}
			{Wait Hp1Max} 		{Wait Hp1}
			local X1 X2 Y1 Y2 BarLen in
				X1 = {FloatToInt {String.toFloat {VirtualString.toString CoordMi.1}}}
				X2 = {FloatToInt {String.toFloat {VirtualString.toString CoordMi.2.2.1}}}
				Y1 = {FloatToInt {String.toFloat {VirtualString.toString CoordMi.2.1}}}
				Y2 = {FloatToInt {String.toFloat {VirtualString.toString CoordMi.2.2.2.1}}}
				{Show {ComputeBarLength X2-X1 Hp1 Hp1Max}}
				BarLen = {ComputeBarLength X2-X1 Hp1 Hp1Max}
				{MiPvBarTag setCoords(X1 Y1 X1+BarLen Y2)}
			end
			
			if Hp1 =< 0 then
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
