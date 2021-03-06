functor
import
	System(show:Show)
	Offset_data(op_Offset:Op_Offset mi_Offset:Mi_Offset) at 'Data/Offset_data.ozf'
	CutImages(allSprites_B:AllSprites_B background_Battle_Trainer:Background_Battle_Trainer background_Battle_Grass:Background_Battle_Grass allTrainerBattleFrames:AllTrainerBattleFrames getNewPokeFrames:GetNewPokeFrames getSprite_frame_Op:GetSprite_frame_Op pokeball:Pokeball)
	Util(cellSet:CellSet)
	QTk at 'x-oz://system/wp/QTk.ozf'
	PokeConfig(bAR_WIDTH:BAR_WIDTH bAR_LENGTH:BAR_LENGTH barRegressionDelay:BarRegressionDelay autofight:Autofight combat_Speed:Combat_Speed)
	Battle(runAutoBattle:RunAutoBattle attack:Attack)
	Game(inBattle:InBattle)
	
export
	PrepareBattle
	DrawHpBar
	ComputeBarLength
	DoTheBarAnimation
	DoThePokeAttackAnimation
	DoTheXpBarAnimation
	DoTheFaintAnim
	DoTheEvolution

define
	UI_LENGTH = 255*2
	UI_HEIGHT = 143*2

	OpPokePosX = 192*2
	OpPokePosY = (88-38)*2
	MiPokePosX = (90+20)*2
%	MiPokePosY = (143+24)*2
	MiPokePosY = (143+8)*2

	proc {DrawBattleUI MiPoke OpPoke IsTrainer Number}
		Font16={QTk.newFont font(size:16)}
		
		Grid GridHandler
		UIControl
		UICanvas
		UICanvasHandler
		Window
		MiNumber
		OpNumber
		HpRecord
		PokeTagsRecord
		DialogImg DialogImg_old
		DialogText
		EndBattle
		
		/* UI CONTROL */
		UI_Control_Handler

		But_Attk_Handler	Button_Attack
		But_Poke_Handler	Button_PokemOz
		But_Fuite_Handler	Button_Fuite
		But_Capt_Handler	Button_Capture
		But_Auto_Handler	Button_AutoBattle		
	in
			
		{MiPoke getNum(MiNumber)} {OpPoke getAdjustedNum(OpNumber)}
		UICanvas = canvas(handle:UICanvasHandler width:UI_LENGTH height:UI_HEIGHT)
		
		DialogImg_old = {QTk.newImage photo(file:"Images/dialogbar.gif")} 
		DialogImg = {QTk.newImage photo()}
		{DialogImg copy(DialogImg_old zoom:o(1 2))}
		Grid = grid(empty empty newline
						empty empty newline
						empty empty
				handle:GridHandler bg:grey)
				
		Window = {QTk.build td(title:'PokemOz battle!' Grid)}
		{Window show}
		
		{GridHandler configure(UICanvas column:1 row:1 rowspan:2 sticky:nw)}
		{GridHandler configure(label(text:"" font:Font16 bg:grey handle:DialogText) column:2 row:1 ipadx:10 ipady:10)}
		%{GridHandler configure(label(image:DialogImg) column:2 row:1 rowspan:3 sticky:n)}
		
		if IsTrainer then {UICanvasHandler create(image 0 0 image:Background_Battle_Trainer anchor:nw)} 
		else
			{UICanvasHandler create(image 0 0 image:Background_Battle_Grass anchor:nw)}
		end
		PokeTagsRecord = {DrawPokemoz OpNumber MiNumber UICanvasHandler DialogText IsTrainer Number}
		HpRecord = {DrawHpBar UICanvasHandler Window MiPoke OpPoke DialogText}
		
		if Autofight == 0 then 
		
		/* START UI CONTROL */

				Button_Attack = button(text:"Attack" action:proc{$} {Show 'Attack'} {Attack MiPoke OpPoke Window HpRecord PokeTagsRecord DialogText} if {OpPoke getHp($)}>=0 then EndBattle=true end end handle:But_Attk_Handler)
				Button_PokemOz = button(text:"PokemOz" action:proc{$} {Show 'PokemOz'} {DialogText set(text:"You have only one PokemOz!")} end handle:But_Poke_Handler)
			if {Not IsTrainer} then	
				Button_Fuite = button(text:"Runaway" action:proc{$} {Show 'Runaway'} {CellSet InBattle false} EndBattle = true {Window close} end handle:But_Capt_Handler)
			else
				Button_Fuite = button(text:"Runaway" action:proc{$} {Show 'Runaway'} end handle:But_Capt_Handler)
			end		
				Button_Capture = button(text:"Capture" action:proc{$} {Show 'Capture'} {ThrowPokeball UICanvasHandler DialogText PokeTagsRecord OpNumber} end handle:But_Fuite_Handler)
				Button_AutoBattle = button(text:"Auto-Battle" action:proc{$} {Show 'Run Auto Battle'} {RunAutoBattle MiPoke OpPoke Window HpRecord PokeTagsRecord DialogText} if {OpPoke getHp($)}>=0 then EndBattle=true end end handle:But_Auto_Handler)
				

               
				UIControl = grid(empty Button_Attack  empty newline
										Button_PokemOz Button_AutoBattle Button_Capture newline
										empty Button_Fuite empty newline
										handle:UI_Control_Handler)
		
		/* END UI CONTROL */

			{GridHandler configure(UIControl column:2 row:2)}
			{UI_Control_Handler configure(But_Attk_Handler But_Poke_Handler But_Fuite_Handler But_Capt_Handler padx:20 pady:10)}	
		
				{Window bind(event:"<Up>" action:proc{$} {Show 'Attack'} {Attack MiPoke OpPoke Window HpRecord PokeTagsRecord DialogText} if {OpPoke getHp($)}>=0 then EndBattle=true end end)}
			if {Not IsTrainer} then	
				{Window bind(event:"<Down>" action:proc{$} {Show 'Runaway'} {CellSet InBattle false} EndBattle = true {Window close} end)}
			else
				{Window bind(event:"<Down>" action:proc{$} {Show 'Runaway'} end)}
			end
				{Window bind(event:"<Left>" action:proc{$} {Show 'PokemOz'} {DialogText set(text:"You have only one PokemOz!")} end)}
				{Window bind(event:"<Right>" action:proc{$} {Show 'Capture'} {ThrowPokeball UICanvasHandler DialogText PokeTagsRecord OpNumber} end)}
				{Window bind(event:"<Return>" action:proc{$} {Show 'Run Auto Battle'} {RunAutoBattle MiPoke OpPoke Window HpRecord PokeTagsRecord DialogText} if {OpPoke getHp($)}>=0 then EndBattle=true end end)}
		
		elseif Autofight==1 then 
			{RunAutoBattle MiPoke OpPoke Window HpRecord PokeTagsRecord DialogText}
		else
			if {Not IsTrainer} then {CellSet InBattle false} EndBattle = true {Window close}
			else {RunAutoBattle MiPoke OpPoke Window HpRecord PokeTagsRecord DialogText}
			end
		end
		{Wait EndBattle}
		{Show endBattle}	
	end
	
	fun {DrawPokemoz OpNumber MiNumber UICanvasHandler DialogText IsTrainer Number}
		OpPokeTag = {UICanvasHandler newTag($)}
		MiPokeTag = {UICanvasHandler newTag($)}
		TrainerTag = {UICanvasHandler newTag($)}
		CorrectOpSprites = {GetSprite_frame_Op OpNumber}
	in
		local Poke_Offset_Op Poke_Offset_Mi D in
			D=250
			Poke_Offset_Op = 2*Op_Offset.OpNumber
			Poke_Offset_Mi = 2*Mi_Offset.MiNumber
			if(IsTrainer) then
				{DialogText set(text:"A trainer want to chalenge you!")}
				{UICanvasHandler create(image OpPokePosX OpPokePosY image:AllTrainerBattleFrames.Number anchor:center tags:TrainerTag)}
				{Delay 1000}			
				{DialogText set(text:"Opponent trainer send his POKEMOZ!")}
				for I in 0..100 do
					{Delay 15}
					{TrainerTag move(I*2 ~I)}
				end
				{Delay 750}
			else
				{DialogText set(text:"A wild POKEMOZ appeared!")}
			end
			
				%{UICanvasHandler create(image OpPokePosX OpPokePosY+Poke_Offset_Op image:AllSprites_Op.OpNumber.1 anchor:center tags:OpPokeTag)}
				{UICanvasHandler create(image OpPokePosX OpPokePosY+Poke_Offset_Op image:CorrectOpSprites.1 anchor:center tags:OpPokeTag)}
				{UICanvasHandler create(image MiPokePosX MiPokePosY+Poke_Offset_Mi image:AllSprites_B.MiNumber anchor:se tags:MiPokeTag)}
				
				{Delay 2*D}
				{OpPokeTag set(image:CorrectOpSprites.2)}
				{Delay D}
				{OpPokeTag set(image:CorrectOpSprites.1)}
				{Delay D}
				{OpPokeTag set(image:CorrectOpSprites.2)}
				{Delay D}
				{OpPokeTag set(image:CorrectOpSprites.1)}
				{Delay D}
				{OpPokeTag set(image:CorrectOpSprites.1)}
				{Delay 3*D}
			
		end
		poketags(mi:MiPokeTag op:OpPokeTag)
	end
	
	
	%Compute BarLength
	fun {ComputeBarLength Val ValMax}
		{FloatToInt ({IntToFloat Val}/{IntToFloat ValMax})*{IntToFloat BAR_LENGTH}}
	end
	
	fun {ComputeXpBarLength Val ValMax}
		Bar_Length = ((UI_LENGTH-25-2) - (UI_LENGTH-25 - BAR_LENGTH+3))
		in
		{FloatToInt ({IntToFloat Val}/{IntToFloat ValMax})*{IntToFloat Bar_Length}}
	end
	
	fun {DrawHpBar UICanvasHandler Window MiPoke OpPoke DialogText}		
		Font18={QTk.newFont font(size:18)} Font14={QTk.newFont font(size:14)} Font8={QTk.newFont font(size:8)}
		MiStartX = UI_LENGTH-25 - BAR_LENGTH
		MiStartY = UI_HEIGHT-45 
		MiEndX = UI_LENGTH-25 
		MiEndY = UI_HEIGHT-45 + BAR_WIDTH		
		MiBarLength
		ExpBarLength

		OpStartX = 15
		OpStartY = 65
		OpEndX = 15 + BAR_LENGTH
		OpEndY = 65 + BAR_WIDTH
		OpBarLength
		

		MiPokeLvlHandler MiPokeHPtxtHandler
		OpPokeHPtxtHandler
		XpTag={UICanvasHandler newTag($)} 
		MiPvBarTag={UICanvasHandler newTag($)}
		OpPvBarTag={UICanvasHandler newTag($)}
		
		in
		
		local MiName OpName MiLvl OpLvl MiHp OpHp MiHpMax OpHpMax Exp XpNeeded XpLevel Hp1Text Hp2Text in 
		{MiPoke getName(MiName)} {OpPoke getName(OpName)}
		{MiPoke getLevel(MiLvl)} {OpPoke getLevel(OpLvl)}
		{MiPoke getHp(MiHp)} {OpPoke getHp(OpHp)} 
		{MiPoke getHpMax(MiHpMax)} {OpPoke getHpMax(OpHpMax)} 
		{MiPoke getExp(Exp)} 
		{MiPoke getExpNeeded(XpNeeded)}
		{MiPoke getExpLevel(XpLevel)}
		MiBarLength = {ComputeBarLength MiHp MiHpMax}
		OpBarLength = {ComputeBarLength OpHp OpHpMax}
		ExpBarLength = {ComputeXpBarLength Exp-XpLevel XpNeeded}
		
		Hp1Text = set(text:{Append "Hp: " {Append {IntToString MiHp} {Append "/" {IntToString MiHpMax}}}})
		Hp2Text = set(text:{Append "Hp: " {Append {IntToString OpHp} {Append "/" {IntToString OpHpMax}}}})
		
	%Mi
		%Bars
		{UICanvasHandler create(rectangle MiStartX+3 MiEndY MiEndX-2 MiEndY+7 fill:white width:2.0)}
      {UICanvasHandler create(rectangle MiStartX+4 MiEndY MiStartX+5+ExpBarLength MiEndY+7 fill:blue outline:nil tags:XpTag)}
      {UICanvasHandler create(rectangle MiStartX MiStartY MiEndX MiEndY+2 fill:white width:3.0)}
      {UICanvasHandler create(rectangle MiStartX+2 MiStartY+2 MiEndX-BAR_LENGTH+MiBarLength-1 MiEndY+2-1 fill:green outline:nil tags:MiPvBarTag)}
      %Texts
      {UICanvasHandler create(text MiStartX MiStartY-23 text:MiName font:Font14 anchor:nw fill:black)}
      {UICanvasHandler create(text MiEndX-30 MiStartY-23 text:"Lv." font:Font14 anchor:ne fill:black)}
		{UICanvasHandler create(text MiEndX-8 MiStartY-28 text:MiLvl font:Font18 anchor:ne fill:black handle:MiPokeLvlHandler)}
		{UICanvasHandler create(text MiEndX-(BAR_LENGTH div 2) MiStartY+1 text:Hp1Text font:Font8 anchor:n fill:black handle:MiPokeHPtxtHandler)}
	%Op	
		%Bars
      {UICanvasHandler create(rectangle OpStartX OpStartY OpEndX OpEndY+2 fill:white width:3.0)}
      {UICanvasHandler create(rectangle OpStartX+2 OpStartY+2 OpEndX-BAR_LENGTH+OpBarLength-1 OpEndY+2-1 fill:red outline:nil tags:OpPvBarTag)}
      %Texts
      {UICanvasHandler create(text OpStartX OpStartY-23 text:OpName font:Font14 anchor:nw fill:black)}
      {UICanvasHandler create(text OpEndX-30 OpStartY-23 text:"Lv." font:Font14 anchor:ne fill:black)}
		{UICanvasHandler create(text OpEndX-8 OpStartY-28 text:OpLvl font:Font18 anchor:ne fill:black)}
		{UICanvasHandler create(text OpStartX+(BAR_LENGTH div 2) OpStartY+1 text:Hp2Text font:Font8 anchor:n fill:black handle:OpPokeHPtxtHandler)}
		
		
		hpbar(miBar:MiPvBarTag opBar:OpPvBarTag miTxt:MiPokeHPtxtHandler opTxt:OpPokeHPtxtHandler lvlTxt:MiPokeLvlHandler expBar:XpTag)
		end %local
	end

	
	proc {PrepareBattle MiPoke OpPoke IsTrainer Number}
		{CellSet InBattle true}	
		{DrawBattleUI MiPoke OpPoke IsTrainer Number}
	end
		
	%Bar Animation
	proc {DoTheBarAnimation TxtTag BarTag BarLen PBarLen HpP HpC HpMax} 
		local X1 X2 Y1 Y2 Coord in
			{BarTag getCoords(1:Coord)}
			X1 = {FloatToInt {String.toFloat {VirtualString.toString Coord.1}}}
			X2 = {FloatToInt {String.toFloat {VirtualString.toString Coord.2.2.1}}}
			Y1 = {FloatToInt {String.toFloat {VirtualString.toString Coord.2.1}}}
			Y2 = {FloatToInt {String.toFloat {VirtualString.toString Coord.2.2.2.1}}}
			if HpP-HpC > 0 then
				for I in 0..PBarLen-BarLen do
					{Delay BarRegressionDelay-(500 div Combat_Speed)}
					if(X2-I < X1+1) then skip
					else
						{BarTag setCoords(X1 Y1 X2-I Y2)}
					end
					local Factor = {IntToFloat (PBarLen-BarLen)} / {IntToFloat (HpP-HpC)} in
						{TxtTag set(text:{Append "Hp: " {Append {IntToString HpP-{FloatToInt ({IntToFloat I}/Factor)}} {Append "/" {IntToString HpMax}}}})}
					end
				end
			end
		end
	end
	
	%Poke Attack anim
	proc {DoThePokeAttackAnimation PokeTag OpNumber Mibool}
		CorrectOpSprites = {GetSprite_frame_Op OpNumber}
		in
		if (Mibool) then
			{PokeTag move(30 0)}
			{Delay Combat_Speed*2}
			{PokeTag move(~30 0)}
		else	
			{PokeTag move(~30 15)}
			{Delay Combat_Speed}
			{PokeTag set(image:CorrectOpSprites.2)}
			{Delay Combat_Speed*2}
			{PokeTag set(image:CorrectOpSprites.1)}
			{Delay Combat_Speed}
			{PokeTag move(30 ~15)}
		end
		{Delay 3*Combat_Speed}
	end
	
	proc {DoTheXpBarAnimation BarLen PBarLen ExpBarTag LvlTxt}
		{Show 'doTheXpBarAnimation'}
		proc {Newlevel LvlTxt}
			Font24 Font22 Font20 Font19 Font18 Lvl Nlvl 
		in
			Font24={QTk.newFont font(size:28)} Font22={QTk.newFont font(size:26)} Font20={QTk.newFont font(size:22)} Font19={QTk.newFont font(size:20)} Font18={QTk.newFont font(size:18)}
			{LvlTxt get(text:Lvl)} {Wait Lvl}
			Nlvl= {IntToString {StringToInt Lvl}+1}
			{LvlTxt set(text:Nlvl font:Font24)}
			{Delay 15}
			{LvlTxt set(font:Font22)}
			{Delay 15}
			{LvlTxt set(font:Font20)}
			{Delay 15}
			{LvlTxt set(font:Font19)}
			{Delay 15}
			{LvlTxt set(font:Font18)}
		end
	in
		local X1 X2 Xend Y1 Y2 Coord in
			{ExpBarTag getCoords(1:Coord)}
			X1 = {FloatToInt {String.toFloat {VirtualString.toString Coord.1}}}
			X2 = {FloatToInt {String.toFloat {VirtualString.toString Coord.2.2.1}}}
			Y1 = {FloatToInt {String.toFloat {VirtualString.toString Coord.2.1}}}
			Y2 = {FloatToInt {String.toFloat {VirtualString.toString Coord.2.2.2.1}}}
			Xend = UI_LENGTH-25-2
			{Show BarLen#PBarLen}
			{Show X1#Xend}
			for I in 0..BarLen-PBarLen do
				{Delay BarRegressionDelay-(500 div Combat_Speed)}
				if(X2+I > Xend) then skip
				else
					{ExpBarTag setCoords(X1 Y1 X2+I Y2)}
				end
			end
			if X2+BarLen-PBarLen > Xend then {Newlevel LvlTxt} end
		end
	end
	
	proc {DoTheFaintAnim PokeTag}
		for I in 0..UI_HEIGHT do
			{Delay 10}
			{PokeTag move(0 I)}
		end
	end
	
	proc {DoTheEvolution Pok}
		CanvasEvolHandler 
		CanvasEvol= canvas(handle:CanvasEvolHandler width:500 height:300 bg:black)
		WindowEvol PokN1 PokN2 PokE1 PokE2 PokTag SpritesEvo N CorrectOpSprites1 CorrectOpSprites2
	in
		{Pok getNum(N)}
		CorrectOpSprites1 = {GetSprite_frame_Op N}
		CorrectOpSprites2 = {GetSprite_frame_Op N+1}
		WindowEvol = {QTk.build td(title:'PokemOz evolution!' CanvasEvol)}
		{WindowEvol show}
		
		PokTag = {CanvasEvolHandler newTag($)}

		PokN1=CorrectOpSprites1.1
		PokN2=CorrectOpSprites1.2
		PokE1=CorrectOpSprites2.1
		PokE2=CorrectOpSprites2.2
		SpritesEvo=sprites(PokN1 PokE1)

		{CanvasEvolHandler create(image 250 150 image:PokN1 anchor:center tags:PokTag)}
		{Delay 200}
		{CanvasEvolHandler set(bg:white)}
		{Delay 75}
		{CanvasEvolHandler set(bg:black)}
		{Delay 200}
		{CanvasEvolHandler set(bg:white)}
		{Delay 75}
		{CanvasEvolHandler set(bg:black)}
		{Delay 200}
		{CanvasEvolHandler set(bg:white)}
		{Delay 75}
		{CanvasEvolHandler set(bg:black)}
		{Delay 200}
		{PokTag set(image:PokN2)}
		{Delay 500}
		{PokTag set(image:PokN1)}
		{Delay 100}
		{PokTag set(image:PokN2)}
		{Delay 200}
		{PokTag set(image:PokN1)}
		{Delay 2000}
		for I in 0..50 do
			if I>30 then 
				if (I mod 2)>0 then {CanvasEvolHandler set(bg:white)}
				else {CanvasEvolHandler set(bg:black)} end
			end
			{PokTag set(image:SpritesEvo.((I mod 2)+1))}	
			{Delay (50-I)*(7)}
		end
		{PokTag set(image:PokE1)}
		{Delay 200}
		{PokTag set(image:PokE2)}
		{Delay 500}
		{PokTag set(image:PokE1)}
		{Delay 200}
		{PokTag set(image:PokE2)}
		{Delay 1000}
		{PokTag set(image:PokE1)}
		{Delay 2000}
		{Pok setNum(N+1)}
		{GetNewPokeFrames N+1}
		{WindowEvol close}
	end

	proc {ThrowPokeball Canvas DialogText PokeTagsRecord OpNumber}
		PokeHandler 
		CorrectOpSprites = {GetSprite_frame_Op OpNumber}
		in
		{Canvas create(image 0 UI_HEIGHT image:Pokeball anchor:ne handle:PokeHandler)}
		for I in 0.. (OpPokePosX)	do
			{Delay 1}
			{PokeHandler move((1) ~(I mod 2))}
			{Show I}
		end
		{PokeTagsRecord.op set(image:CorrectOpSprites.2)}
		{Delay 110}
		{PokeTagsRecord.op set(image:CorrectOpSprites.1)}
		for I in 0.. 200	do
			{Delay 1}
			{PokeHandler move((I mod 3) ~(2))}
			{Show I}
		end	
		{DialogText set(text:"You missed!")}
		{Delay 500}
	end

end
