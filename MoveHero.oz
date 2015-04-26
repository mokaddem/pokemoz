
functor
import
	System(show:Show)
	CutImages(allHeroFrames:AllHeroFrames)
	DisplayMap(heroHandle:HeroHandle fieldType:FieldType)
	PokeConfig(sQUARE_LENGTH:SQUARE_LENGTH)

export
	MovementHandle

define	
	
	
%PROCEDURE THAT ANIMATE AND MOVE THE HERO
	proc {MoveHero Dir HeroHandle}
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

	proc {MovementHandle M TrainerPort}
		thread S X Y H in
			{Send MovementStatus get(S)}
			{Wait S}
			%{Show S}
			{Send TrainerPort getPosition(x:X y:Y)}
			{Wait X}
			{Show 'Trainer was on'#{FieldType X Y}#'at'#X#' '#Y}
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
				{Send MovementStatus idle()}
			else
				skip
			end
	   	end
	end
end
