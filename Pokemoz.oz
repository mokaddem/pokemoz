functor

export
	NewPokemoz
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
				if State.currentLife - X < 0 then state(type:(State.type) num:(State.num) name:(State.name) maxlife:(State.maxlife) currentLife:(0) experience:(State.experience) level:(State.level))
				else state(type:(State.type) num:(State.num) name:(State.name) maxlife:(State.maxlife) currentLife:(State.currentLife - X) experience:(State.experience) level:(State.level))
				end
			[] 'exp'(X) then
				local Hp L Xp=State.experience+X in
					L = {GetLevel Xp}.l
					Hp = {GetLevel Xp}.hp
					if L > State.level then state(type:(State.type) num:(State.num) name:(State.name) maxlife:Hp currentLife:Hp experience:(State.experience)+X level:L)
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
			[] getNum(X) then X=State.num State
			[] setNum(X) then state(type:(State.type) num:(X) name:(State.name) maxlife:(State.maxlife) currentLife:(State.currentLife - X) experience:(State.experience) level:(State.level))
			end
		end
		P S
	in
		P = {NewPort S}
		thread {Loop S Init} end
		P
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
end
