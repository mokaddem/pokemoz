
functor
import
	System(show:Show)
	Open
	QTk at 'x-oz://system/wp/QTk.ozf'
	CutImages(allHeroFrames:AllHeroFrames allPokeFrames:AllPokeFrames)
	DisplayMap(heroHandle:HeroHandle heroPosition:HeroPosition pokeHandle:PokeHandle squareLengthFloat:SquareLengthFloat)
	Util(customNewCell:CustomNewCell cellSet:CellSet cellGet:CellGet)
	
export
	UpHandle
	DownHandle
	RightHandle
	LeftHandle

define	
	
	
%PROCEDURE THAT ANIMATE AND MOVE THE HERO
	proc {MoveHero Dir}
		MovementValue=SquareLengthFloat/5.0 
		Movement 
		HeroFrames 
		PokeFrames
	in
		case Dir
		of r then
		HeroFrames = AllHeroFrames.rightFrame
		PokeFrames = AllPokeFrames.rightFrame
		Movement = move(MovementValue 0)
		[]l then
			HeroFrames = AllHeroFrames.leftFrame
			PokeFrames = AllPokeFrames.leftFrame
			Movement = move(~MovementValue 0)
		[]d then
			HeroFrames = AllHeroFrames.downFrame
			PokeFrames = AllPokeFrames.downFrame
			Movement = move(0 MovementValue)
		[]u then
			HeroFrames = AllHeroFrames.upFrame
			PokeFrames = AllPokeFrames.upFrame
			Movement = move(0 ~MovementValue)
		end
		thread {Delay 150} {MakeTheMove PokeHandle PokeFrames Movement} end % thread to not wit the end of poke move
		{MakeTheMove HeroHandle HeroFrames Movement}
	end
	
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

/* ************** Hero Position Cell ************** */
	
		
/* ******************************** */
	MovementStatusStream
	MovementStatus = {NewPort MovementStatusStream}
	fun {F Msg State}
		case Msg
		of moving() then moving()
		[] idle() then idle()
		[] get(X) then X=State State
		end
	end
	proc {Loop S State}
		case S of Msg|S2 then
			{Loop S2 {F Msg State}}
		end
	end
	thread {Loop MovementStatusStream idle()} end

	proc {LeftHandle}
	   	thread X in
			{Send MovementStatus get(X)}
			{Wait X}
			{Show X}
		   	case X of idle() then
		   		{Send MovementStatus moving()}
			   	{Show move_left}
		   		{MoveHero l}
		   		{Send MovementStatus idle()}
		   	else
		   		skip
		   	end
	   	end
	end

	proc {RightHandle}
	   	thread X in
			{Send MovementStatus get(X)}
			{Wait X}
			{Show X}
		   	case X of idle() then
		   		{Send MovementStatus moving()}
			   	{Show move_right}
		   		{MoveHero r}
		   		{Send MovementStatus idle()}
		   	else
		   		skip
		   	end
	   	end
	end

	proc {UpHandle}
	   	thread X in
			{Send MovementStatus get(X)}
			{Wait X}
			{Show X}
		   	case X of idle() then
		   		{Send MovementStatus moving()}
			   	{Show move_up}
		   		{MoveHero u}
		   		{Send MovementStatus idle()}
		   	else
		   		skip
		   	end
	   	end
	end

	proc {DownHandle}
	   	thread X in
			{Send MovementStatus get(X)}
			{Wait X}
			{Show X}
		   	case X of idle() then
		   		{Send MovementStatus moving()}
			   	{Show move_down}
		   		{MoveHero d}
		   		{Send MovementStatus idle()}
		   	else
		   		skip
		   	end
	   	end
	end		

end
