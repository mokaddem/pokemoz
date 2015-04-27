
functor
import
	System(show:Show)
	Open
	QTk at 'x-oz://system/wp/QTk.ozf'
	CutImages(allHeroFrames:AllHeroFrames allPokeFrames:AllPokeFrames)
	DisplayMap(heroHandle:HeroHandle heroPosition:HeroPosition pokeHandle:PokeHandle pokePosition:PokePosition squareLengthFloat:SquareLengthFloat fieldType:FieldType)
	Util(customNewCell:CustomNewCell cellSet:CellSet cellGet:CellGet)
	PokeConfig(sQUARE_LENGTH:SQUARE_LENGTH)
	
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
%		{MakeTheFollowMove PokeHandle AllPokeFrames Movement}
		{CellSet HeroPosition NewHeroPosition}
	end

/* Start - Make the follow */
	proc {MakeTheFollowMove Handler FramesDirection HeroMovement}
		MovementValue=SquareLengthFloat/5.0
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
		thread S X Y H in
			{Send MovementStatus get(S)}
			{Wait S}
			%{Show S}
			{Send TrainerPort getHandler(H)}
			{Wait H}
			case S of idle() then
				{Send MovementStatus moving()}
			   	case M
			   	of l then 
			   		%{Show move_left}
			   		{Send TrainerPort moveX(~1)}
			   	[] r then
			   		%{Show move_right}
			   		{Send TrainerPort moveX(1)}
			   	[] u then
			   		%{Show move_up}
			   		{Send TrainerPort moveY(~1)}
			   	[] d then
			   		%{Show move_down}
			   		{Send TrainerPort moveY(1)}
			   	end
				{MoveHero M H}
				{Send TrainerPort getPosition(x:X y:Y)}
				{Wait X}
				{Show 'Trainer was on'#{FieldType X Y}#'at'#X#' '#Y}
				{Send MovementStatus idle()}
			else
				skip
			end
	   	end
	end
end
