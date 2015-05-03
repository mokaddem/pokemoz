functor
import
	PokeConfig(rEAL_SPEED:REAL_SPEED)
	DisplayMap(deplaceAllowedPlace:DeplaceAllowedPlace)
export
	NewTrainer
define
	
	% State = state(x:X y:Y pokemoz:P speed:S movement:M handler:H number:N movementStatus:MovementStatus incombat:IC)
	fun {NewTrainer Init}
		proc {Loop S State}
			if State.type \= 'dead' then case S of Msg|S2 then {Loop S2 {HandleMessage Msg State}} end end
		end

		proc {LoopMovement P}
			S M T in
			{P getSpeed(S)}
			{P getMovement(M)}
			{P getType(T)}
			{Wait S}
			{Wait M}
			{Delay REAL_SPEED}
			{M P}
			if T \= 'dead' then {LoopMovement P} end
		end

		fun {HandleMessage Msg State}
			case Msg
			of moveX(X) then 
				{DeplaceAllowedPlace (State.x + X) State.y State.x State.y proc {$ F} {Send P F} end}
				state(x:(State.x + X) y:(State.y) pokemoz:(State.pokemoz) speed:(State.speed) movement:(State.movement) handler:(State.handler) 'number':(State.number) movementStatus:(State.movementStatus) type:(State.type))
			[] moveY(Y) then
				{DeplaceAllowedPlace State.x (State.y + Y) State.x State.y proc {$ F} {Send P F} end}
				state(x:(State.x) y:(State.y + Y) pokemoz:(State.pokemoz) speed:(State.speed) movement:(State.movement) handler:(State.handler) 'number':(State.number) movementStatus:(State.movementStatus) type:(State.type))
			[] move(X Y) then
				{DeplaceAllowedPlace (State.x + X) (State.y + Y) State.x State.y proc {$ F} {Send P F} end}
				state(x:(State.x + X) y:(State.y + Y) pokemoz:(State.pokemoz) speed:(State.speed) movement:(State.movement) handler:(State.handler) 'number':(State.number) movementStatus:(State.movementStatus) type:(State.type))
			[] pokemoz(Pokemoz) then state(x:(State.x) y:(State.y) pokemoz:(Pokemoz) speed:(State.speed) movement:(State.movement) handler:(State.handler) 'number':(State.number) movementStatus:(State.movementStatus) type:(State.type))
			[] state(x y pokemoz speed movement) then {DeplaceAllowedPlace Msg.x Msg.y Msg.x Msg.y proc {$ F} {Send P F} end} Msg
			[] setDead() then state(x:(State.x) y:(State.y) pokemoz:(State.pokemoz) speed:0 movement:proc {$} 1=1 end handler:(State.handler) 'number':(State.number) movementStatus:moving() type:'dead')
			[] getPosition(x:X y:Y) then X=State.x Y=State.y State
			[] getPokemoz(P) then P=State.pokemoz State
			[] getMovement(M) then M=State.movement State
			[] getSpeed(S) then S=State.speed State
			[] getHandler(H) then H=State.handler State
			[] getNumber(N) then N=State.'number' State
			[] getType(T) then T=State.type State
			[] getMovementStatus(MS) then MS=State.movementStatus State
			[] sendMovementStatus(MS) then state(x:(State.x) y:(State.y) pokemoz:(State.pokemoz) speed:(State.speed) movement:(State.movement) handler:(State.handler) 'number':(State.number) movementStatus:MS type:(State.type))
			end
		end
		P S
	in
		P = {NewPort S}
		thread {Loop S Init} end
		thread {LoopMovement proc {$ F} {Send P F} end} end
		proc {$ F} {Send P F} end
	end
		
	
end
