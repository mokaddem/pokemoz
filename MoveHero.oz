
functor
import
	System(show:Show)
	CutImages(allHeroFrames:AllHeroFrames)
	DisplayMap(heroHandle:HeroHandle)
	PokeConfig(sQUARE_LENGTH:SQUARE_LENGTH)

export
	MovementHandle

define	
	
	
%PROCEDURE THAT ANIMATE AND MOVE THE HERO
	proc {MoveHero Dir}
		D=75 
		MovementValue={IntToFloat SQUARE_LENGTH}/4.0 
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

	proc {MovementHandle M}
		thread X in
			{Send MovementStatus get(X)}
			{Wait X}
			{Show X}
		   	case X of idle() then
		   		{Send MovementStatus moving()}
			   	case M
			   	of l then {Show move_left}
			   	[] r then {Show move_right}
			   	[] u then {Show move_up}
			   	[] d then {Show move_down}
			   	end
		   		{MoveHero M}
		   		{Send MovementStatus idle()}
		   	else
		   		skip
		   	end
	   	end
	end
end
