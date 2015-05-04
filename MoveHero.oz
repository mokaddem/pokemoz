
functor
import
	System(show:Show)
	Open
	OS
	QTk at 'x-oz://system/wp/QTk.ozf'
	CutImages(allHeroFrames:AllHeroFrames allPokeFrames:AllPokeFrames)
	DisplayMap(heroTrainer:HeroTrainer heroPosition:HeroPosition pokeHandle:PokeHandle pokePosition:PokePosition squareLengthFloat:SquareLengthFloat fieldType:FieldType placeAllowed:PlaceAllowed deplaceAllowedPlace:DeplaceAllowedPlace lookAround:LookAround launchGameOver:LaunchGameOver)
	DisplayBattle(prepareBattle:PrepareBattle)
	Util(customNewCell:CustomNewCell cellSet:CellSet cellGet:CellGet)
	PokeConfig(sQUARE_LENGTH:SQUARE_LENGTH wild_Pokemon_proba:Wild_Pokemon_proba rEAL_SPEED:REAL_SPEED trainer_Max_Foot_Number:Trainer_Max_Foot_Number trainer_Move_Proba:Trainer_Move_Proba)
	Pokemoz(newPokemoz:NewPokemoz generateRandomPokemon:GenerateRandomPokemon)
	Battle(runAutoBattle:RunAutoBattle)
	Game(inBattle:InBattle)
	
export
	MovementHandle
	RandomMove
	GoTo
define	

	

%PROCEDURE THAT ANIMATE AND MOVE THE HERO
	proc {MoveHero Dir HeroHandle Frames IsHero}
		MovementValue={IntToFloat SQUARE_LENGTH}/5.0 
		Movement 
		TrainerFrames
		NewHeroPosition
		HeroPos
	in
		HeroPos={CellGet HeroPosition}
		{Wait HeroPos}
		case Dir
		of r then
		TrainerFrames = Frames.rightFrame
		Movement = move(MovementValue 0)
		NewHeroPosition=pos(x:HeroPos.x+MovementValue y:HeroPos.y)
		[]l then
			TrainerFrames = Frames.leftFrame
			Movement = move(~MovementValue 0)
			NewHeroPosition=pos(x:HeroPos.x-MovementValue y:HeroPos.y)
		[]d then
			TrainerFrames = Frames.downFrame
			Movement = move(0 MovementValue)
			NewHeroPosition=pos(x:HeroPos.x y:HeroPos.y+MovementValue)
		[]u then
			TrainerFrames = Frames.upFrame
			Movement = move(0 ~MovementValue)
			NewHeroPosition=pos(x:HeroPos.x y:HeroPos.y-MovementValue)
		end
		if(IsHero) then thread {Delay 50} {MakeTheFollowMove PokeHandle AllPokeFrames Movement} end end % thread to not wit the end of poke move
		{MakeTheMove HeroHandle TrainerFrames Movement}
		if(IsHero) then {CellSet HeroPosition NewHeroPosition} end
	end

/* Start - Make the follow */
	proc {MakeTheFollowMove Handler FramesDirection HeroMovement}
		NiceFramesDirection
		if {Port.is FramesDirection} then NiceFramesDirection={CellGet FramesDirection}
		else NiceFramesDirection=FramesDirection end
		
		MovementValue=1.0*SquareLengthFloat/5.0 
		NewPokePosition
		HeroPos
		PokePos
		DirectionToTake
		DirectionToFace
		Movement
		in
	
		HeroPos = {CellGet HeroPosition}		
		PokePos = {CellGet PokePosition}
	
		case HeroPos#PokePos 
			of pos(x:Hx y:Hy)#pos(x:Px y:Py) then
			if (Hx-Px)>0.0 then DirectionToTake=rightFrame
			elseif (Hx-Px)<0.0 then DirectionToTake=leftFrame
			else
				if (Hy-Py)>0.0 then DirectionToTake=downFrame
				else DirectionToTake=upFrame
				end
			end
		end
		case DirectionToTake
			of downFrame then Movement=move(0 MovementValue) NewPokePosition=pos(x:PokePos.x y:PokePos.y+MovementValue)
			[]upFrame then Movement=move(0 ~MovementValue) NewPokePosition=pos(x:PokePos.x y:PokePos.y-MovementValue)
			[]rightFrame then Movement=move(MovementValue 0) NewPokePosition=pos(x:PokePos.x+MovementValue y:PokePos.y)
			[]leftFrame then Movement=move(~MovementValue 0) NewPokePosition=pos(x:PokePos.x-MovementValue y:PokePos.y)
		end
	
		{CellSet PokePosition NewPokePosition}
		{MakeTheMove Handler NiceFramesDirection.DirectionToTake Movement}
		
		case HeroMovement
		of move(X Y) then
			if X==0 then
				if Y>0.0 then DirectionToFace=downFrame
				else DirectionToFace=upFrame
				end
			else 
				if X>0.0 then DirectionToFace=rightFrame
				else DirectionToFace=leftFrame
				end
			end
		end
		{Delay 75}
		{Handler set(image:{CellGet AllPokeFrames}.DirectionToFace.1)}
	end

/*  END - Make the follow */

	proc {MakeTheMove Handler FramesDirection Movement}
		NiceFramesDirection
		if {Port.is FramesDirection} then NiceFramesDirection={CellGet FramesDirection}
		else NiceFramesDirection=FramesDirection end
		D=75 in
		{Handler set(image:NiceFramesDirection.2)}
		{Handler Movement}
		{Delay D}
		{Handler Movement}
		{Delay D}
		{Handler set(image:NiceFramesDirection.4)}
		{Handler Movement}
		{Delay D}
		{Handler Movement}
		{Delay D}
		{Handler set(image:NiceFramesDirection.1)}
		{Handler Movement}
	end

		
/* ******************************** */

	proc {MovementHandle M TrainerPort Frames IsHero FootNumber}
		X X2
	in 
		X = {CellGet InBattle} {Wait X}
		if {Not X} then
			thread S X1 Y1 H Flag Field NextX NextY Type NextIsTrainer Waiter in
				{TrainerPort getMovementStatus(S)}
				{Wait S}
				case S of idle() then
					{TrainerPort sendMovementStatus(moving())}
					{TrainerPort getHandler(H)}
					{TrainerPort getPosition(x:X1 y:Y1)}
					{TrainerPort getType(Type)}
					{Wait Y1}
					{Wait Type}
					{Wait H}
				   	case M
				   	of l then NextX = X1-1 NextY = Y1
				   	[] r then NextX = X1+1 NextY = Y1
				   	[] u then NextX = X1 NextY = Y1-1
				   	[] d then NextX = X1 NextY = Y1+1
				   	end
				   	if {FieldType NextX NextY} \= 'null' then E D X in
				   		try {{PlaceAllowed NextX NextY} getPokemoz(X)} {Wait X} NextIsTrainer = 'true' catch error(1:E debug:D) then NextIsTrainer = 'false' end
				   	
				   		if {PlaceAllowed NextX NextY} \= 'occupied' then 
				   			if NextIsTrainer == 'false' then
				   				{TrainerPort move(NextX-X1 NextY-Y1)}
				   				Flag=1 Field={FieldType NextX NextY}
				   			else {Show 'place not allowed'} Flag=0 
				   			end 
				   		else {Show 'place not allowed'} Flag=0 
				   		end
				   	else 
				   		Flag=0  
				   	end
					if Flag==1 then 
						{MoveHero M H Frames IsHero} 
						if FootNumber > 0 andthen {Not X} then thread {Wait Waiter} {MovementHandle M TrainerPort Frames IsHero FootNumber-1} end end
						case Field 
						of 0 then 
							if {LookAround NextX NextY Type} \= 'false' then 
								if(IsHero andthen {Not {CellGet InBattle $}}) then
									{Show 'Battle with Other Trainer !1'}
									local Pok1 Pok2 N Hp in 
									if IsHero then {{LookAround NextX NextY Type} getNumber(N)} else {TrainerPort getNumber(N)} end
									{TrainerPort getPokemoz(Pok1)} {{LookAround NextX NextY Type} getPokemoz(Pok2)} {Wait Pok1} {Wait Pok2} {PrepareBattle Pok1 Pok2 true N}
									if {Pok2 getHp(Hp)} {Wait Hp} Hp == 0 then {{LookAround NextX NextY Type} setDead()} end end
								elseif {Not {CellGet InBattle $}}  then
									{Show 'Battle with Other Trainer !2'}
									local Pok1 Pok2 N Hp in
									if IsHero then {{LookAround NextX NextY Type} getNumber(N)} else {TrainerPort getNumber(N)} end
									{TrainerPort getPokemoz(Pok1)} {{LookAround NextX NextY Type} getPokemoz(Pok2)} {Wait Pok1} {Wait Pok2} {PrepareBattle Pok2 Pok1 true N}
									if {Pok1 getHp(Hp)} {Wait Hp} Hp == 0 then {TrainerPort setDead()} end end
								end 
							end
						[] 1 then 
							if(IsHero andthen {Not {CellGet InBattle $}}) then
								if {LookAround NextX NextY Type} \= 'false' then 
									{Show 'Battle with Other Trainer !3'}
									local Pok1 Pok2 N Hp in 
									if IsHero then {{LookAround NextX NextY Type} getNumber(N)} else {TrainerPort getNumber(N)} end
									{TrainerPort getPokemoz(Pok1)} {{LookAround NextX NextY Type} getPokemoz(Pok2)} {Wait Pok1} {Wait Pok2} {PrepareBattle Pok1 Pok2 true N}
									if {Pok2 getHp(Hp)} {Wait Hp} Hp == 0 then {{LookAround NextX NextY Type} setDead()} end end
								elseif(Wild_Pokemon_proba > {OS.rand} mod 100) then
									local Pok1 Pok2 in
										local Pok in {TrainerPort getPokemoz(Pok)} {Wait Pok} {PrepareBattle Pok {GenerateRandomPokemon} false 0} end
									end
								end
							elseif {Not {CellGet InBattle $}} then
								if {LookAround NextX NextY Type} \= 'false' then 
									{Show 'Battle with Other Trainer !4'}
									local Pok1 Pok2 N Hp in 
									if IsHero then {{LookAround NextX NextY Type} getNumber(N)} else {TrainerPort getNumber(N)} end
									{TrainerPort getPokemoz(Pok1)} {{LookAround NextX NextY Type} getPokemoz(Pok2)} {Wait Pok1} {Wait Pok2} {PrepareBattle Pok2 Pok1 true N}
									if {Pok1 getHp(Hp)} {Wait Hp} Hp == 0 then {TrainerPort setDead()} end end
								end
							end
						[] e then
							{CellSet InBattle true}
							{LaunchGameOver true}
						else
							skip	
						end
					end
					{TrainerPort  sendMovementStatus(idle())}
				else
					skip
				end
					Waiter=1
		   	end
		   end
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
	
	proc {GotoMove Trainer X Y Frames}
		Xc Yc M
	in 
		{Trainer getPosition(x:Xc y:Yc)}
		if Xc < X then M=r
		elseif Xc > X then M=l
		elseif Yc < Y then M=d
		else M=u
		end
		{MovementHandle M Trainer Frames true 0}
	end
	
	fun {GoTo X Y Frames}
		proc {$ T} {GotoMove T X Y Frames} end
	end
end
