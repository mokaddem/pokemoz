functor
import
	System
export
	NewTrainer
define
	DELAY=200
	
	% State = state(x:X y:Y pokemoz:P speed:S movement:M)
	fun {NewTrainer Init}
		proc {Loop S State}
			case S of Msg|S2 then {Loop S2 {HandleMessage Msg State} end
		end
		proc {LoopMovement P}
			S M in
			{Send P getSpeed(S)}
			{Send P getMovement(M)}
			{Delay (10-S)*DELAY}
			{M P}
			{LoopMovement}
		end
		fun {HandleMessage Msg State}
			case Msg
			of moveX(X) then state(x:(State.x + X) y:(State.y) pokemoz:(State.pokemoz) speed:(State.speed) movement:(State.movement))
			[] moveY(Y) then state(x:(State.x) y:(State.y + Y) pokemoz:(State.pokemoz) speed:(State.speed) movement:(State.movement))
			[] pokemoz(Pokemoz) then state(x:(State.x) y:(State.y) pokemoz:(Pokemoz) speed:(State.speed) movement:(State.movement))
			[] state(x:X y:Y pokemoz:P speed:S movement:M) then Msg
			[] getPosition(x:X y:Y) then X=State.x Y=State.y State
			[] getPokemoz(P) then P=State.pokemoz State
			[] getMovement(M) then M=State.movement State
			[] getSpeed(S) then S=State.speed State
			end
		end
		P S
	in
		P = {NewPort S}
		thread {Loop S Init} end
		thread {LoopMovement P} end
		P
	end
end
