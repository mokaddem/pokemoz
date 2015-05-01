functor
import
	OS
	System(show:Show)
	PokeConfig(dELAY:DELAY sPEED:SPEED trainer_Move_Proba:Trainer_Move_Proba)
	MoveHero(movementHandle:MovementHandle)
export
	NewTrainer
	RandomMove
define
	
	% State = state(x:X y:Y pokemoz:P speed:S movement:M handler:H number:N)
	fun {NewTrainer Init}
		proc {Loop S State}
			case S of Msg|S2 then {Loop S2 {HandleMessage Msg State}} end
		end
		proc {LoopMovement P}
			S M in
			{P getSpeed(S)}
			{P getMovement(M)}
			{Wait S}
			{Wait M}
			{Delay (10-S)*DELAY}
			{M P}
			{LoopMovement P}
		end
		fun {HandleMessage Msg State}
			case Msg
			of moveX(X) then state(x:(State.x + X) y:(State.y) pokemoz:(State.pokemoz) speed:(State.speed) movement:(State.movement) handler:(State.handler) 'number':(State.number))
			[] moveY(Y) then state(x:(State.x) y:(State.y + Y) pokemoz:(State.pokemoz) speed:(State.speed) movement:(State.movement) handler:(State.handler) 'number':(State.number))
			[] pokemoz(Pokemoz) then state(x:(State.x) y:(State.y) pokemoz:(Pokemoz) speed:(State.speed) movement:(State.movement) handler:(State.handler) 'number':(State.number))
			[] state(x y pokemoz speed movement) then Msg
			[] getPosition(x:X y:Y) then X=State.x Y=State.y State
			[] getPokemoz(P) then P=State.pokemoz State
			[] getMovement(M) then M=State.movement State
			[] getSpeed(S) then S=State.speed State
			[] getHandler(H) then H=State.handler State
			[] getNumber(N) then N=State.'number' State
			end
		end
		P S
	in
		P = {NewPort S}
		thread {Loop S Init} end
		thread {LoopMovement proc {$ F} {Send P F} end} end
		proc {$ F} {Send P F} end
	end

	proc {RandomlyMoveTrainer Trainer}
			MoveDir
			Proba = {OS.rand} mod 100 
		in
		if (Trainer_Move_Proba >= Proba) then
			if Proba<25 then MoveDir=l
			elseif Proba<50 then MoveDir=r
			elseif Proba<75 then MoveDir=d
			else MoveDir=t end
			{MovementHandle MoveDir Trainer false}
		end
	end
	
	fun {RandomMove}
		proc {$ T} {RandomlyMoveTrainer T} end
	end
	
end
