functor
import
	OS
	Util(customNewCell:CustomNewCell cellSet:CellSet cellGet:CellGet)
	System(show:Show)
	PokeConfig(dELAY:DELAY trainer_Move_Proba:Trainer_Move_Proba trainer_MoveS_Speed:Trainer_MoveS_Speed rEAL_SPEED:REAL_SPEED trainer_Max_Foot_Number:Trainer_Max_Foot_Number)
	MoveHero(movementHandle:MovementHandle)
	DisplayMap(deplaceAllowedPlace:DeplaceAllowedPlace)
export
	NewTrainer
	RandomMove
define
	
	% State = state(x:X y:Y pokemoz:P speed:S movement:M handler:H number:N movementStatus:MovementStatus incombat:IC)
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
			{Delay REAL_SPEED}
			{M P}
			{LoopMovement P}
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

	proc {RandomlyMoveTrainer Trainer Frames}
		MoveDir
		Proba
		Proba2 = {OS.rand} mod 100
	in
		Proba = {OS.rand} mod 100
		if (Trainer_Move_Proba > Proba) then
			if Proba*100<25*Trainer_Move_Proba then MoveDir=l
			elseif Proba*100<50*Trainer_Move_Proba then MoveDir=r
			elseif Proba*100<75*Trainer_Move_Proba then MoveDir=d
			else MoveDir=u 
			end
			{MovementHandle MoveDir Trainer Frames false (Proba2 mod Trainer_Max_Foot_Number)}
		end
	end
	fun {RandomMove Frames}
		proc {$ T} {RandomlyMoveTrainer T Frames} end
	end
	
end
