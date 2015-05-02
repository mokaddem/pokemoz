functor
import
	System(show:Show)
	Open

	Offset_data(op_Offset:Op_Offset mi_Offset:Mi_Offset) at 'Data/Offset_data.ozf'
	CutImages(heroFace:HeroFace pokeFace:PokeFace grass_Tile:Grass_Tile road_Tile:Road_Tile allSprites_B:AllSprites_B allSprites_Op:AllSprites_Op background_Battle_Trainer:Background_Battle_Trainer background_Battle_Grass:Background_Battle_Grass)
	MoveHero(movementHandle:MovementHandle)
	Util(customNewCell:CustomNewCell cellSet:CellSet cellGet:CellGet)
	QTk at 'x-oz://system/wp/QTk.ozf'
	PokeConfig(sQUARE_LENGTH:SQUARE_LENGTH hERO_SUBSAMPLE:HERO_SUBSAMPLE gRASS_ZOOM:GRASS_ZOOM dELAY:DELAY bAR_WIDTH:BAR_WIDTH bAR_LENGTH:BAR_LENGTH pokeAttackDelay:PokeAttackDelay	barRegressionDelay:BarRegressionDelay)
	Trainer(newTrainer:NewTrainer)
	Pokemoz(newPokemoz:NewPokemoz)
	Battle(runAutoBattle:RunAutoBattle attack:Attack)
	
export
	PrepareBattle
	DrawHpBar
	ComputeBarLength
	DoTheBarAnimation
	DoThePokeAttackAnimation
	DoTheXpBarAnimation

define
	UI_LENGTH = 255*2
	UI_HEIGHT = 143*2

	OpPokePosX = 192*2
	OpPokePosY = (88-38)*2
	MiPokePosX = (90+20)*2
%	MiPokePosY = (143+24)*2
	MiPokePosY = (143+8)*2

	proc {DrawBattleUI MiPoke OpPoke TrainerPort}
		UICanvas
		UICanvasHandler
		Window
		MiNumber
		OpNumber
		HpRecord
		PokeTagsRecord
	in
		{MiPoke getNum(MiNumber)} {OpPoke getNum(OpNumber)}
		UICanvas = canvas(handle:UICanvasHandler width:UI_LENGTH height:UI_HEIGHT)
		Window = {QTk.build td(title:'PokemOz battle!' UICanvas)}
		{Window show}
		{UICanvasHandler create(image 0 0 image:Background_Battle_Grass anchor:nw)}
		PokeTagsRecord = {DrawPokemoz OpNumber MiNumber UICanvasHandler}
		HpRecord = {DrawHpBar UICanvasHandler Window MiPoke OpPoke}
		{DrawUI_Control Window MiPoke OpPoke TrainerPort HpRecord PokeTagsRecord}
	end
	
	fun {DrawPokemoz OpNumber MiNumber UICanvasHandler}
		OpPokeTag = {UICanvasHandler newTag($)}
		MiPokeTag = {UICanvasHandler newTag($)}
	in
		local Poke_Offset_Op Poke_Offset_Mi in
			Poke_Offset_Op = 2*Op_Offset.OpNumber
			Poke_Offset_Mi = 2*Mi_Offset.MiNumber
			{UICanvasHandler create(image OpPokePosX OpPokePosY+Poke_Offset_Op image:AllSprites_Op.OpNumber.1 anchor:center tags:OpPokeTag)}
			{UICanvasHandler create(image MiPokePosX MiPokePosY+Poke_Offset_Mi image:AllSprites_B.MiNumber anchor:se tags:MiPokeTag)}
		end
		poketags(mi:MiPokeTag op:OpPokeTag)
	end
	
	
	%Compute BarLength
	fun {ComputeBarLength Val ValMax}
		{FloatToInt ({IntToFloat Val}/{IntToFloat ValMax})*{IntToFloat BAR_LENGTH}}
	end
	
	fun {DrawHpBar UICanvasHandler Window MiPoke OpPoke}		
		Font18={QTk.newFont font(size:18)} Font14={QTk.newFont font(size:14)} Font8={QTk.newFont font(size:8)}
		MiStartX = UI_LENGTH-25 - BAR_LENGTH
		MiStartY = UI_HEIGHT-45 
		MiEndX = UI_LENGTH-25 
		MiEndY = UI_HEIGHT-45 + BAR_WIDTH		
		MiBarLength

		OpStartX = 15
		OpStartY = 65
		OpEndX = 15 + BAR_LENGTH
		OpEndY = 65 + BAR_WIDTH
		OpBarLength
		

		XpHandler MiPvHandler MiPokeTextHandler MiPokeLvlHandler	MiPokeHPtxtHandler
		OpPvHandler OpPokeTextHandler OpPokeLvlHandler OpPokeHPtxtHandler
		XpTag={UICanvasHandler newTag($)} 
		MiPvBarTag={UICanvasHandler newTag($)}
		OpPvBarTag={UICanvasHandler newTag($)}
		
		in
		
		local MiName OpName MiLvl OpLvl MiHp OpHp MiHpMax OpHpMax MiExp Hp1Text Hp2Text in 
		{MiPoke getName(MiName)} {OpPoke getName(OpName)}
		{MiPoke getLevel(MiLvl)} {OpPoke getLevel(OpLvl)}
		{MiPoke getHp(MiHp)} {OpPoke getHp(OpHp)} 
		{MiPoke getHpMax(MiHpMax)} {OpPoke getHpMax(OpHpMax)} 
		{MiPoke getHp(MiExp)} %TODO !!  --> Get Exp
		{Wait MiExp}
		
		MiBarLength = {ComputeBarLength MiHp MiHpMax}
		OpBarLength = {ComputeBarLength OpHp OpHpMax}
		
		Hp1Text = set(text:{Append "Hp: " {Append {IntToString MiHp} {Append "/" {IntToString MiHpMax}}}})
		Hp2Text = set(text:{Append "Hp: " {Append {IntToString OpHp} {Append "/" {IntToString OpHpMax}}}})
		
	%Mi
		%Bars
		{UICanvasHandler create(rectangle MiStartX+3 MiEndY MiEndX-2 MiEndY+7 fill:white width:2.0)}
      {UICanvasHandler create(rectangle MiStartX+3 MiEndY MiEndX-2 MiEndY+7 fill:blue outline:nil handle:XpHandler tags:XpTag)}
      {UICanvasHandler create(rectangle MiStartX MiStartY MiEndX MiEndY+2 fill:white width:3.0)}
      {UICanvasHandler create(rectangle MiStartX+2 MiStartY+2 MiEndX-BAR_LENGTH+MiBarLength-1 MiEndY+2-1 fill:green outline:nil handle:MiPvHandler tags:MiPvBarTag)}
      %Texts
      {UICanvasHandler create(text MiStartX MiStartY-28 text:MiName font:Font18 anchor:nw fill:black handle:MiPokeTextHandler)}
      {UICanvasHandler create(text MiEndX-30 MiStartY-23 text:"Lv." font:Font14 anchor:ne fill:black)}
		{UICanvasHandler create(text MiEndX-8 MiStartY-28 text:MiLvl font:Font18 anchor:ne fill:black handle:MiPokeLvlHandler)}
		{UICanvasHandler create(text MiEndX-(BAR_LENGTH div 2) MiStartY+1 text:Hp1Text font:Font8 anchor:n fill:black handle:MiPokeHPtxtHandler)}
	%Op	
		%Bars
      {UICanvasHandler create(rectangle OpStartX OpStartY OpEndX OpEndY+2 fill:white width:3.0)}
      {UICanvasHandler create(rectangle OpStartX+2 OpStartY+2 OpEndX-BAR_LENGTH+OpBarLength-1 OpEndY+2-1 fill:red outline:nil handle:OpPvHandler tags:OpPvBarTag)}
      %Texts
      {UICanvasHandler create(text OpStartX OpStartY-28 text:OpName font:Font18 anchor:nw fill:black handle:OpPokeTextHandler)}
      {UICanvasHandler create(text OpEndX-30 OpStartY-23 text:"Lv." font:Font14 anchor:ne fill:black)}
		{UICanvasHandler create(text OpEndX-8 OpStartY-28 text:OpLvl font:Font18 anchor:ne fill:black handle:OpPokeLvlHandler)}
		{UICanvasHandler create(text OpStartX+(BAR_LENGTH div 2) OpStartY+1 text:Hp2Text font:Font8 anchor:n fill:black handle:OpPokeHPtxtHandler)}
		
		
		hpbar(miBar:MiPvBarTag opBar:OpPvBarTag miTxt:MiPokeHPtxtHandler opTxt:OpPokeHPtxtHandler expBar:XpTag)
		end %local
	end

	
	proc {PrepareBattle MiPoke OpPoke TrainerPort}
		{TrainerPort setInCombat(true)}
		{DrawBattleUI MiPoke OpPoke TrainerPort}
	end
	
	proc {DrawUI_Control Window MiPoke OpPoke TrainerPort HpRecord PokeTagsRecord}		
		UI_Control
		UI_Control_Handler
		UI_Control_Window
		UI_Components = components(window:Window ui_control_window:UI_Control_Window)
		
		But_Attk_Handler
		But_Poke_Handler
		But_Fuite_Handler
		But_Capt_Handler
		But_Auto_Handler

		Button_Attack = button(text:"Attack" action:proc{$} {Show 'Attack'} {Attack MiPoke OpPoke TrainerPort UI_Components HpRecord PokeTagsRecord} end handle:But_Attk_Handler)
		Button_PokemOz = button(text:"PokemOz" action:proc{$} {Show 'PokemOz'} end handle:But_Poke_Handler)
		Button_Fuite = button(text:"Runaway" action:proc{$} {Show 'Runaway'} {UI_Control_Window close} {Window close} end handle:But_Capt_Handler)
		Button_Capture = button(text:"Capture" action:proc{$} {Show 'Capture'} end handle:But_Fuite_Handler)
		Button_AutoBattle = button(text:"Auto-Battle" action:proc{$} {Show 'Run Auto Battle'} {RunAutoBattle MiPoke OpPoke TrainerPort UI_Components HpRecord PokeTagsRecord} end handle:But_Auto_Handler)
	
	
		UI_Control = grid(empty Button_Attack  empty newline
								Button_PokemOz Button_AutoBattle Button_Capture newline
								empty Button_Fuite empty
								handle:UI_Control_Handler)
	
		in
			
			% Get info about window and place the dialog ont the right place
			UI_Control_Window = {QTk.build td(title:'PokemOz battle!' UI_Control)}
			{UI_Control_Handler configure(But_Attk_Handler But_Poke_Handler But_Fuite_Handler But_Capt_Handler padx:10 pady:10)}	 
		local X Y in 
			{Window winfo(geometry:X)} {UI_Control_Handler winfo(geometry:Y)}
			{UI_Control_Window set(geometry:geometry(x:X.x+{FloatToInt {IntToFloat X.width}/2.0-{IntToFloat Y.width}/2.0} y:X.y+X.height))}
		end
		{UI_Control_Window show(modal:true)}
		thread
			{Delay 500}
			{UI_Control_Window bind(event:"<Up>" action:proc{$} {Show 'Attack'} {Attack MiPoke OpPoke TrainerPort UI_Components HpRecord PokeTagsRecord} end)} %trying to bind to an action
			{UI_Control_Window bind(event:"<Down>" action:proc{$} {Show 'Runaway'} {TrainerPort setInCombat(false)} {UI_Control_Window close} {Window close} end)}
			{UI_Control_Window bind(event:"<Left>" action:proc{$} {Show 'PokemOz'} end)}
			{UI_Control_Window bind(event:"<Right>" action:proc{$} {Show 'Capture'} end)}
			{UI_Control_Window bind(event:"<Return>" action:proc{$} {Show 'Run Auto Battle'} {RunAutoBattle MiPoke OpPoke TrainerPort UI_Components HpRecord PokeTagsRecord} end)}
		end
		
	end
	
	%Bar Animation
	proc {DoTheBarAnimation TxtTag BarTag X1 Y1 BarLen PBarLen X2 Y2 HpP HpC HpMax} 
		if HpP-HpC > 0 then
			for I in 0..PBarLen-BarLen do
				{Delay BarRegressionDelay}
				if(X2-I < X1+1) then skip
				else
					{BarTag setCoords(X1 Y1 X2-I Y2)}
				end
				local Factor = {IntToFloat (PBarLen-BarLen)} / {IntToFloat (HpP-HpC)} in
				{Show Factor#{IntToFloat I}/Factor#HpP-{FloatToInt ({IntToFloat I}/Factor)}}
					{TxtTag set(text:{Append "Hp: " {Append {IntToString HpP-{FloatToInt ({IntToFloat I}/Factor)}} {Append "/" {IntToString HpMax}}}})}
				end
			end
		end
	end
	
	%Poke Attack anim
	proc {DoThePokeAttackAnimation PokeTag Mibool}
		if (Mibool) then
			{PokeTag move(30 0)}
			{Delay PokeAttackDelay}
			{PokeTag move(~30 0)}
		else	
			{PokeTag move(~30 15)}
			{Delay DELAY}
			{PokeTag move(30 ~15)}
		end
		{Delay 3*PokeAttackDelay}
	end
	
	proc {DoTheXpBarAnimation Pok1 Level2 ExpBarTag}
		{ExpBarTag setCoords(50 50 150 150)}
	end

end
