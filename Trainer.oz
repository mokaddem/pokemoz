functor
import
	OS
	System(show:Show)
	PokeConfig(dELAY:DELAY sPEED:SPEED trainer_Move_Proba:Trainer_Move_Proba trainer_MoveS_Speed:Trainer_MoveS_Speed)
	MoveHero(movementHandle:MovementHandle)
export
	NewTrainer
	RandomlyMoveTrainer
define
	
	% State = state(x:X y:Y pokemoz:P speed:S movement:M handler:H number:N movementStatus:MovementStatus incombat:IC)
	fun {NewTrainer Init}
		proc {Loop S State}
			case S of Msg|S2 then {Loop S2 {HandleMessage Msg State}} end
		end
		fun {HandleMessage Msg State}
			case Msg
			of moveX(X) then state(x:(State.x + X) y:(State.y) pokemoz:(State.pokemoz) speed:(State.speed) movement:(State.movement) handler:(State.handler) 'number':(State.number) movementStatus:(State.movementStatus) incombat:(State.incombat))
			[] moveY(Y) then state(x:(State.x) y:(State.y + Y) pokemoz:(State.pokemoz) speed:(State.speed) movement:(State.movement) handler:(State.handler) 'number':(State.number) movementStatus:(State.movementStatus) incombat:(State.incombat))
			[] pokemoz(Pokemoz) then state(x:(State.x) y:(State.y) pokemoz:(Pokemoz) speed:(State.speed) movement:(State.movement) handler:(State.handler) 'number':(State.number) movementStatus:(State.movementStatus) incombat:(State.incombat))
			[] state(x y pokemoz speed movement) then Msg
			[] getPosition(x:X y:Y) then X=State.x Y=State.y State
			[] getPokemoz(P) then P=State.pokemoz State
			[] getMovement(M) then M=State.movement State
			[] getSpeed(S) then S=State.speed State
			[] getHandler(H) then H=State.handler State
			[] getNumber(N) then N=State.'number' State
			[] getMovementStatus(MS) then {Send State.movementStatus get(MS)} State
			[] sendMovementStatus(MS) then {Send State.movementStatus MS} State
			[] getInCombat(IC) then IC=State.incombat State
			[] setInCombat(SIC) then state(x:(State.x) y:(State.y) pokemoz:(State.pokemoz) speed:(State.speed) movement:(State.movement) handler:(State.handler) 'number':(State.number) movementStatus:(State.movementStatus) incombat:SIC)
			end
		end
		P S
		
		/* The INDIVIDUAL Movement Status Port for each trainer */
		MovementStatusStream
		MovementStatus = {NewPort MovementStatusStream}
		fun {MovementStatusMsgHandler MSMsg MSState}
			case MSMsg
			of moving() then moving()
			[] idle() then idle()
			[] inbattle() then inbattle()
			[] get(MSStateVal) then MSStateVal=MSState MSState
			end
		end
		proc {LoopMovementStatus MSS MSState}
			case MSS of MSMsg|MSS2 then
				{LoopMovementStatus MSS2 {MovementStatusMsgHandler MSMsg MSState}}
			end
		end
		thread {LoopMovementStatus MovementStatusStream idle()} end
		Init_Final
	in
		P = {NewPort S}
		Init_Final={Record.adjoinAt Init movementStatus MovementStatus}
		thread {Loop S Init_Final} end
	%	thread {LoopMovement P} end
		proc {$ F} {Send P F} end
	end

	proc {RandomlyMoveTrainer Trainer HeroTrainer}
		MoveDir
		Proba  
		X
		{HeroTrainer getInCombat(X)} 
	in
		{Wait X}
		if {Not X} then
			Proba = {OS.rand} mod 100
			{Delay Trainer_MoveS_Speed}
			if (Trainer_Move_Proba >= Proba) then
				if Proba*100<25*Trainer_Move_Proba then MoveDir=l
				elseif Proba*100<50*Trainer_Move_Proba then MoveDir=r
				elseif Proba*100<75*Trainer_Move_Proba then MoveDir=d
				else MoveDir=u 
				end
				{MovementHandle MoveDir Trainer false}
			end
		end
		{RandomlyMoveTrainer Trainer HeroTrainer}
	end
	
end
