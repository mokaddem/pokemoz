
functor
import
	System(show:Show)
	Open
	OS
	QTk at 'x-oz://system/wp/QTk.ozf'
	CutImages(allHeroFrames:AllHeroFrames allPokeFrames:AllPokeFrames)
	DisplayMap(heroTrainer:HeroTrainer heroPosition:HeroPosition pokeHandle:PokeHandle pokePosition:PokePosition squareLengthFloat:SquareLengthFloat fieldType:FieldType)
	DisplayBattle(prepareBattle:PrepareBattle)
	Util(customNewCell:CustomNewCell cellSet:CellSet cellGet:CellGet)
	PokeConfig(sQUARE_LENGTH:SQUARE_LENGTH wild_Pokemon_proba:Wild_Pokemon_proba)
	Pokemoz(newPokemoz:NewPokemoz)
	Battle(runBattle:RunBattle)
	
export
	MovementHandle

define	
	

%PROCEDURE THAT ANIMATE AND MOVE THE HERO
	proc {MoveHero Dir HeroHandle}
		D=75 
		MovementValue={IntToFloat SQUARE_LENGTH}/5.0 
		Movement 
		HeroFrames
		NewHeroPosition
		HeroPos
	in
		HeroPos={CellGet HeroPosition}
		{Wait HeroPos}
		case Dir
		of r then
		HeroFrames = AllHeroFrames.rightFrame
		Movement = move(MovementValue 0)
		NewHeroPosition=pos(x:HeroPos.x+MovementValue y:HeroPos.y)
		[]l then
			HeroFrames = AllHeroFrames.leftFrame
			Movement = move(~MovementValue 0)
			NewHeroPosition=pos(x:HeroPos.x-MovementValue y:HeroPos.y)
		[]d then
			HeroFrames = AllHeroFrames.downFrame
			Movement = move(0 MovementValue)
			NewHeroPosition=pos(x:HeroPos.x y:HeroPos.y+MovementValue)
		[]u then
			HeroFrames = AllHeroFrames.upFrame
			Movement = move(0 ~MovementValue)
			NewHeroPosition=pos(x:HeroPos.x y:HeroPos.y-MovementValue)
		end
		thread {Delay 50} {MakeTheFollowMove PokeHandle AllPokeFrames Movement} end % thread to not wit the end of poke move
		{MakeTheMove HeroHandle HeroFrames Movement}
		{CellSet HeroPosition NewHeroPosition}
	end

/* Start - Make the follow */
	proc {MakeTheFollowMove Handler FramesDirection HeroMovement}
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
		{MakeTheMove Handler FramesDirection.DirectionToTake Movement}
		
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
		{Handler set(image:AllPokeFrames.DirectionToFace.1)}
	end

/*  END - Make the follow */

	proc {MakeTheMove Handler FramesDirection Movement}
		D=75 in
		{Handler set(image:FramesDirection.2)}
		{Handler Movement}
		{Delay D}
		{Handler Movement}
		{Delay D}
		{Handler set(image:FramesDirection.4)}
		{Handler Movement}
		{Delay D}
		{Handler Movement}
		{Delay D}
		{Handler set(image:FramesDirection.1)}
		{Handler Movement}
		{Delay D}
	end

		
/* ******************************** */
	MovementStatusStream
	MovementStatus = {NewPort MovementStatusStream}
	fun {F Msg State}
		case Msg
		of moving() then moving()
		[] idle() then idle()
		[] get(StateVal) then StateVal=State State
		end
	end
	proc {Loop S State}
		case S of Msg|S2 then
			{Loop S2 {F Msg State}}
		end
	end
	thread {Loop MovementStatusStream idle()} end

	proc {MovementHandle M TrainerPort}
		thread S X1 Y1 X2 Y2 H Flag Field in
			{Send MovementStatus get(S)}
			{Wait S}
			{Send TrainerPort getHandler(H)}
			{Wait H}
			{Send TrainerPort getPosition(x:X1 y:Y1)}
			{Wait X1}
			case S of idle() then
				{Send MovementStatus moving()}
			   	case M
			   	of l then 
			   		if {FieldType X1-1 Y1} \= 'null' then 
			   		{Send TrainerPort moveX(~1)} Flag=1 Field={FieldType X1-1 Y1} else Flag=0 end
			   	[] r then
				   	if {FieldType X1+1 Y1} \= 'null' then 
			   		{Send TrainerPort moveX(1)} Flag=1 Field={FieldType X1+1 Y1} else Flag=0  end
			   	[] u then
						if {FieldType X1 Y1-1} \= 'null' then 
			   		{Send TrainerPort moveY(~1)} Flag=1 Field={FieldType X1 Y1-1} else Flag=0  end
			   	[] d then
						if {FieldType X1 Y1+1} \= 'null' then 
			   		{Send TrainerPort moveY(1)} Flag=1 Field={FieldType X1 Y1+1} else Flag=0  end
			   	end
				if Flag==1 then 
					{MoveHero M H} 
					case Field 
					of	0 then skip
					[]1 then 
						if(Wild_Pokemon_proba >= {OS.rand} mod 100) then
							local Pok1 Pok2 in
								Pok1 = {NewPokemoz state(type:grass num:1 name:bulbozar maxlife:20 currentLife:20 experience:0 level:5)}
								Pok2 = {NewPokemoz state(type:fire num:7 name:charmozer maxlife:20 currentLife:20 experience:0 level:5)}
								%{RunBattle Bulba Charmo} 
								{PrepareBattle Pok1 Pok2}
								
							end
						end
					else skip	
					end
				end
				{Send TrainerPort getPosition(x:X2 y:Y2)}
				{Wait X2}
				{Show 'Trainer is on'#{FieldType X2 Y2}#'at'#X2#' '#Y2}
				{Send MovementStatus idle()}
			else
				skip
			end
	   	end
	end
end
