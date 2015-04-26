
functor
import
	System(show:Show)
	Open
	QTk at 'x-oz://system/wp/QTk.ozf'
	CutImages(allHeroFrames:AllHeroFrames)
	DisplayMap(heroHandle:HeroHandle squareLengthFloat:SquareLengthFloat)

export
	UpHandle
	DownHandle
	RightHandle
	LeftHandle

define	
	
	
%PROCEDURE THAT ANIMATE AND MOVE THE HERO
	proc {MoveHero Dir}
		D=75 
		MovementValue=SquareLengthFloat/4.0 
		Movement 
		Frames 
	in
		case Dir
		of r then
		Frames = AllHeroFrames.rightFrame
		Movement = move(MovementValue 0)
		[]l then
			Frames = AllHeroFrames.leftFrame
			Movement = move(~MovementValue 0)
		[]d then
			Frames = AllHeroFrames.downFrame
			Movement = move(0 MovementValue)
		[]u then
			Frames = AllHeroFrames.upFrame
			Movement = move(0 ~MovementValue)
		end
		{HeroHandle set(image:Frames.1)}
		{Delay D}
		{HeroHandle set(image:Frames.2)}
		{HeroHandle Movement}
		{Delay D}
		{HeroHandle set(image:Frames.3)}
		{HeroHandle Movement}
		{Delay D}
		{HeroHandle set(image:Frames.4)}
		{HeroHandle Movement}
		{Delay D}
		{HeroHandle set(image:Frames.1)}
		{HeroHandle Movement}
		end
		
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
