
functor
import
	System(show:Show)
	Open
	QTk at 'x-oz://system/wp/QTk.ozf'
	CutImages(allHeroFrames:AllHeroFrames allPokeFrames:AllPokeFrames)
	DisplayMap(heroHandle:HeroHandle heroPosition:HeroPosition pokeHandle:PokeHandle pokePosition:PokePosition squareLengthFloat:SquareLengthFloat)
	Util(customNewCell:CustomNewCell cellSet:CellSet cellGet:CellGet)
	
export
	UpHandle
	DownHandle
	RightHandle
	LeftHandle

define	
	
	

	proc {MoveHero Dir}
		MovementValue=SquareLengthFloat/5.0
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

	proc {LeftHandle}
	   	thread StateVal in
			{Send MovementStatus get(StateVal)}
			{Wait StateVal}
%			{Show StateVal}
		   	case StateVal of idle() then
		   		{Send MovementStatus moving()}
%			   	{Show move_left}
		   		{MoveHero l}
		   		{Send MovementStatus idle()}
		   	else
		   		skip
		   	end
	   	end
	end

	proc {RightHandle}
	   	thread StateVal in
			{Send MovementStatus get(StateVal)}
			{Wait StateVal}
%			{Show StateVal}
		   	case StateVal of idle() then
		   		{Send MovementStatus moving()}
%			   	{Show move_right}
		   		{MoveHero r}
		   		{Send MovementStatus idle()}
		   	else
		   		skip
		   	end
	   	end
	end

	proc {UpHandle}
	   	thread StateVal in
			{Send MovementStatus get(StateVal)}
			{Wait StateVal}
%			{Show StateVal}
		   	case StateVal of idle() then
		   		{Send MovementStatus moving()}
%			   	{Show move_up}
		   		{MoveHero u}
		   		{Send MovementStatus idle()}
		   	else
		   		skip
		   	end
	   	end
	end

	proc {DownHandle}
	   	thread StateVal in
			{Send MovementStatus get(StateVal)}
			{Wait StateVal}
%			{Show StateVal}
		   	case StateVal of idle() then
		   		{Send MovementStatus moving()}
%			   	{Show move_down}
		   		{MoveHero d}
		   		{Send MovementStatus idle()}
		   	else
		   		skip
		   	end
	   	end
	end		

end
