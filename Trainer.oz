functor
import
	System
export
	NewTrainer
define
	% State = state(x:X y:Y pokemoz:Pokemoz)
	fun {NewTrainer Speed MoveFct Init}
		proc {Loop S State}
			case S of Msg|S2 then {Loop S2 {HandleMessage Msg State} end
		end
		fun {HandleMessage Msg State}
			case Msg
			of moveX(X) then state(x:(State.x + X) y:(State.y) pokemoz:(State.pokemoz))
			[] moveY(Y) then state(x:(State.x) y:(State.y + Y) pokemoz:(State.pokemoz))
			[] pokemoz(Pokemoz) then state(x:(State.x) y:(State.y) pokemoz:(Pokemoz))
			[] state(x:X y:Y pokemoz:Pokemoz) then state(x:X y:Y pokemoz:Pokemoz)
			[] getPosition(x:X y:Y) then X=State.x Y=State.y State
			[] getPokemoz(P) then P=State.pokemoz State
			end
		end
		P S
	in
		P = {NewPort S}
		thread {Loop S Init} end
		P
	end
end
