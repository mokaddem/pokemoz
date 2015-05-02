functor
import
	System(show:Show)
	OS
export
	NewPokemoz
	GenerateRandomPokemon
define
	% State = state(type:T num:Num name:N maxlife:Ml currentLife:Cl experience:E level:L)
	fun {NewPokemoz Init}
		proc {Loop S State}
			case S of Msg|S2 then {Loop S2 {HandleMessage Msg State}} end
		end
		fun {HandleMessage Msg State}
			case Msg
			of heal() then state(type:(State.type) num:(State.num) name:(State.name) maxlife:(State.maxlife) currentLife:(State.maxlife) experience:(State.experience) level:(State.level))
			[] damage(X) then
				{Show State.name#' took '#X#' damage'}
				if State.currentLife - X < 1 then
					{Show State.name#' fainted'}
					state(type:(State.type) num:(State.num) name:(State.name) maxlife:(State.maxlife) currentLife:(0) experience:(State.experience) level:(State.level))
				else state(type:(State.type) num:(State.num) name:(State.name) maxlife:(State.maxlife) currentLife:(State.currentLife - X) experience:(State.experience) level:(State.level))
				end
			[] 'exp'(X) then
				{Show State.name#' earn '#X#' experience'}
				local Hp L Xp=State.experience+X in
					L = {GetLevel Xp}.l
					Hp = {GetLevel Xp}.hp
					{Show state(type:(State.type) num:(State.num) name:(State.name) maxlife:Hp currentLife:Hp experience:(State.experience)+X level:L)}
					if L > State.level then
						{Show State.name#' is now level '#State.level} 
						state(type:(State.type) num:(State.num) name:(State.name) maxlife:Hp currentLife:Hp experience:(State.experience)+X level:L)
					else state(type:(State.type) num:(State.num) name:(State.name) maxlife:(State.maxlife) currentLife:(State.maxlife) experience:(State.experience)+X level:(State.level))
					end
				end
			[] getEvolution(X) then
				if State.level < 7 then X = 1 end
				if State.level < 9 then X = 2
				else X = 3 end
				State
			[] getType(X) then X=State.type State
			[] getHp(X) then X=State.currentLife State
			[] getHpMax(X) then X=State.maxlife State
			[] getName(X) then X=State.name State
			[] getLevel(X) then X=State.level State
			[] getExp(X) then 
				if State.level == 10 then X = 100
				else X = {FloatToInt ({IntToFloat (State.experience - {GetExpNeeded State.level})}/{IntToFloat ({GetExpNeeded (State.level + 1)} - {GetExpNeeded State.level})})} end State
			[] getExpNeeded(X) then X={GetExpNeeded State.level+1} State 
			[] getNum(X) then X=State.num State
			[] setNum(X) then state(type:(State.type) num:(X) name:(State.name) maxlife:(State.maxlife) currentLife:(State.currentLife - X) experience:(State.experience) level:(State.level))
			end
		end
		P S
	in
		P = {NewPort S}
		thread {Loop S Init} end
		proc{$ F} {Send P F} end
	end
	
	fun {GetLevel Xp}
		if Xp < 5 then level(l:5 hp:20) 
		else if Xp < 12 then level(l:6 hp:22) 
		else if Xp < 20 then level(l:7 hp:24) 
		else if Xp < 30 then level(l:8 hp:26) 
		else if Xp < 50 then level(l:9 hp:28)
		else level(l:10 hp:30)
		end end end end end
	end
	
	fun{GetExpNeeded Lvl}
		case Lvl
		of 5 then 0
		[] 6 then 5
		[] 7 then 12
		[] 8 then 20
		[] 9 then 30
		[] 10 then 50
		else {Show 'Error'#Lvl} 0
		end
	end
	
	fun {GenerateRandomPokemon}
		Type Num Name in
		Num = ({OS.rand} mod 3)*3+1
		if Num == 1 then 
			Type=grass Name='Bulbasoz'
		elseif Num==4 
			then Type=fire  Name='Charmandoz'
		else 
			Type=water  Name='Oztirtle'
		end
		{NewPokemoz state(type:Type num:Num name:Name maxlife:20 currentLife:20 experience:0 level:5)}
	end
	
end
