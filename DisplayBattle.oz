functor
import
	System(show:Show)
	Open

	Offset_data(op_Offset:Op_Offset mi_Offset:Mi_Offset) at 'Data/Offset_data.ozf'
	CutImages(heroFace:HeroFace pokeFace:PokeFace grass_Tile:Grass_Tile road_Tile:Road_Tile allSprites_B:AllSprites_B allSprites_Op:AllSprites_Op background_Battle_Trainer:Background_Battle_Trainer background_Battle_Grass:Background_Battle_Grass)
	MoveHero(movementHandle:MovementHandle)
	Util(customNewCell:CustomNewCell cellSet:CellSet cellGet:CellGet)
	QTk at 'x-oz://system/wp/QTk.ozf'
	PokeConfig(sQUARE_LENGTH:SQUARE_LENGTH hERO_SUBSAMPLE:HERO_SUBSAMPLE gRASS_ZOOM:GRASS_ZOOM)
	Trainer(newTrainer:NewTrainer)
	Pokemoz(newPokemoz:NewPokemoz)
	Battle(runAutoBattle:RunAutoBattle attack:Attack)
	
export
	PrepareBattle

define
	UI_LENGTH = 255*2
	UI_HEIGHT = 143*2

	OpPokePosX = 192*2
	OpPokePosY = (88-38)*2
	MiPokePosX = (90+20)*2
%	MiPokePosY = (143+24)*2
	MiPokePosY = (143+8)*2

	proc {DrawBattleUI MiPoke OpPoke}
		UICanvas
		UICanvasHandler
		Window
		MiNumber
		OpNumber 
	in
		{MiPoke getNum(MiNumber)} {OpPoke getNum(OpNumber)}
		UICanvas = canvas(handle:UICanvasHandler width:UI_LENGTH height:UI_HEIGHT)
		Window = {QTk.build td(title:'PokemOz battle!' UICanvas)}
		{Window show}
		{UICanvasHandler create(image 0 0 image:Background_Battle_Grass anchor:nw)}
		{DrawPokemoz OpNumber MiNumber UICanvasHandler}
		{DrawHpBar UICanvasHandler Window MiPoke OpPoke}
		{DrawUI_Control Window MiPoke OpPoke}
	end
	
	proc {DrawPokemoz OpNumber MiNumber UICanvasHandler}
		OpPokeHandle MiPokeHandle
	in
		local Poke_Offset_Op Poke_Offset_Mi in
			Poke_Offset_Op = 2*Op_Offset.OpNumber
			Poke_Offset_Mi = 2*Mi_Offset.MiNumber
			{UICanvasHandler create(image OpPokePosX OpPokePosY+Poke_Offset_Op image:AllSprites_Op.OpNumber.1 anchor:center handle:OpPokeHandle)}
			{UICanvasHandler create(image MiPokePosX MiPokePosY+Poke_Offset_Mi image:AllSprites_B.MiNumber anchor:se handle:MiPokeHandle)}
		end
%		V in
%	{AllSprites_Op.1.1 getColor(1 1 V)}	--> to correctly place the pokemon on the ground. (bulb/draco)
	end
	
	
	%Compute BarLength
	fun {ComputeBarLength TotalBarLength Val ValMax}
		{Show Val#ValMax}
		{Show {IntToFloat Val}/{IntToFloat ValMax}}
		{Show ({IntToFloat Val}/{IntToFloat ValMax})*{IntToFloat TotalBarLength}}
		{Show '------------------------' }
		{FloatToInt ({IntToFloat Val}/{IntToFloat ValMax})*{IntToFloat TotalBarLength}}
	end
	
	proc {DrawHpBar UICanvasHandler Window MiPoke OpPoke}		
		Font18={QTk.newFont font(size:18)} Font14={QTk.newFont font(size:14)}
		BarWidth = 10 BarLength = 200
		MiStartX = UI_LENGTH-25 - BarLength
		MiStartY = UI_HEIGHT-45 
		MiEndX = UI_LENGTH-25 
		MiEndY = UI_HEIGHT-45 + BarWidth		
		MiBarLength

		OpStartX = 15
		OpStartY = 65
		OpEndX = 15 + BarLength
		OpEndY = 65 + BarWidth
		OpBarLength
		

		XpHandler MiPvHandler MiPokeTextHandler MiPokeLvlHandler	
		OpPvHandler OpPokeTextHandler OpPokeLvlHandler	
		XpTag={UICanvasHandler newTag($)} 
		MiPvTag={UICanvasHandler newTag($)}
		OpPvTag={UICanvasHandler newTag($)}
		
		in
		
		local MiName OpName MiLvl OpLvl MiHp OpHp MiHpMax OpHpMax MiExp in 
		{MiPoke getName(MiName)} {OpPoke getName(OpName)}
		{MiPoke getLevel(MiLvl)} {OpPoke getLevel(OpLvl)}
		{MiPoke getHp(MiHp)} {OpPoke getHp(OpHp)} 
		{MiPoke getHpMax(MiHpMax)} {OpPoke getHpMax(OpHpMax)} 
		{MiPoke getHp(MiExp)} %TODO !!  --> Get Exp
		{Wait MiExp}
		
		MiBarLength = {ComputeBarLength BarLength MiHp MiHpMax}
		OpBarLength = {ComputeBarLength BarLength OpHp OpHpMax}
		
	%Mi
		%Bars
		{UICanvasHandler create(rectangle MiStartX+3 MiEndY MiEndX-2 MiEndY+7 fill:white width:2.0)}
      {UICanvasHandler create(rectangle MiStartX+3 MiEndY MiEndX-2 MiEndY+7 fill:white outline:nil handle:XpHandler tags:XpTag)}
      {UICanvasHandler create(rectangle MiStartX MiStartY MiEndX MiEndY+2 fill:white width:3.0)}
      {UICanvasHandler create(rectangle MiStartX MiStartY MiEndX-BarLength+MiBarLength MiEndY+2 fill:green width:3.0 handle:MiPvHandler tags:MiPvTag)}
      %Texts
      {UICanvasHandler create(text MiStartX MiStartY-28 text:MiName font:Font18 anchor:nw fill:black handle:MiPokeTextHandler)}
      {UICanvasHandler create(text MiEndX-30 MiStartY-23 text:"Lv." font:Font14 anchor:ne fill:black)}
		{UICanvasHandler create(text MiEndX-8 MiStartY-28 text:MiLvl font:Font18 anchor:ne fill:black handle:MiPokeLvlHandler)}
		
	%Op	
		%Bars
      {UICanvasHandler create(rectangle OpStartX OpStartY OpEndX OpEndY+2 fill:white width:3.0)}
      {UICanvasHandler create(rectangle OpStartX OpStartY OpEndX-BarLength+OpBarLength OpEndY+2 fill:red width:3.0 handle:OpPvHandler tags:OpPvTag)}
      %Texts
      {UICanvasHandler create(text OpStartX OpStartY-28 text:OpName font:Font18 anchor:nw fill:black handle:OpPokeTextHandler)}
      {UICanvasHandler create(text OpEndX-30 OpStartY-23 text:"Lv." font:Font14 anchor:ne fill:black)}
		{UICanvasHandler create(text OpEndX-8 OpStartY-28 text:OpLvl font:Font18 anchor:ne fill:black handle:OpPokeLvlHandler)}
		
		end %local
	end

	
	proc {PrepareBattle MiPoke OpPoke}
		{DrawBattleUI MiPoke OpPoke}
	end
	
	proc {DrawUI_Control Window MiPoke OpPoke}
		UI_Control
		UI_Control_Handler
		UI_Control_Window
		
		But_Attk_Handler
		But_Poke_Handler
		But_Fuite_Handler
		But_Capt_Handler
		But_Auto_Handler

		Button_Attack = button(text:"Attack" action:proc{$} {Show 'Attack'} end handle:But_Attk_Handler)
		Button_PokemOz = button(text:"PokemOz" action:proc{$} {Show 'PokemOz'} end handle:But_Poke_Handler)
		Button_Fuite = button(text:"Runaway" action:proc{$} {Show 'Runaway'} {UI_Control_Window close} {Window close} end handle:But_Capt_Handler)
		Button_Capture = button(text:"Capture" action:proc{$} {Show 'Capture'} end handle:But_Fuite_Handler)
		Button_AutoBattle = button(text:"Auto-Battle" action:proc{$} {Show 'Run Auto Battle'} {RunAutoBattle MiPoke OpPoke} end handle:But_Auto_Handler)
	
	
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
			{UI_Control_Window bind(event:"<Up>" action:proc{$} {Show 'Attack'} {Attack MiPoke OpPoke} end)} %trying to bind to an action
			{UI_Control_Window bind(event:"<Down>" action:proc{$} {Show 'Runaway'} {UI_Control_Window close} {Window close} end)}
			{UI_Control_Window bind(event:"<Left>" action:proc{$} {Show 'PokemOz'} end)}
			{UI_Control_Window bind(event:"<Right>" action:proc{$} {Show 'Capture'} end)}
			{UI_Control_Window bind(event:"<Return>" action:proc{$} {Show 'Run Auto Battle'} {RunAutoBattle MiPoke OpPoke} end)}
		end
		
	end
	
	
/*	in
		local Pok1 Pok2 in
			Pok1 = {NewPokemoz state(type:grass num:1 name:bulbozar maxlife:20 currentLife:18 experience:0 level:5)}
			Pok2 = {NewPokemoz state(type:fire num:4 name:charmozer maxlife:20 currentLife:2 experience:0 level:5)}
			%{RunBattle Bulba Charmo} 
			{PrepareBattle Pok1 Pok2}
		end*/
end
