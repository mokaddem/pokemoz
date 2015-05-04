functor

import
	System(show:Show)
	Open
	QTk at 'x-oz://system/wp/QTk.ozf'
	PokeConfig(saveValue:SaveValue saveStarter:SaveStarter)
	
export
	LaunchTheIntro
	
define
	LaunchTheIntro MakeTheChoice Ok

	Font22={QTk.newFont font(size:22)}
	Font16={QTk.newFont font(size:16)}
	Font14={QTk.newFont font(size:14)}
	Font12={QTk.newFont font(size:12)}
	Font10={QTk.newFont font(size:10)}
	
	PathPokeStart = "Images/Starter/"
	Prof= {QTk.newImage photo(file:{Append PathPokeStart "prof.gif"})}	
	Pok1= {QTk.newImage photo(file:{Append PathPokeStart "1.gif"})}
	Pok2= {QTk.newImage photo(file:{Append PathPokeStart "2.gif"})}
	Pok3= {QTk.newImage photo(file:{Append PathPokeStart "3.gif"})}
	
	Window
	But_1_Handler But_2_Handler But_3_Handler But_prof_Handler 
	Grid_Handler1 Grid_Handler2 PlaceHolder_Handle
	Button_Pok1 = button(action:proc{$} {Show 'Pok1'} {SaveStarter 1} {Window close} Ok=1 end image:Pok1 handle:But_1_Handler)
	Button_Pok2 = button(action:proc{$} {Show 'Pok2'} {SaveStarter 4} {Window close} Ok=1 end image:Pok2 handle:But_2_Handler)
	Button_Pok3 = button(action:proc{$} {Show 'Pok3'} {SaveStarter 7} {Window close} Ok=1 end image:Pok3 handle:But_3_Handler)
	Button_Prof = button(action:proc{$} {Show 'Ouch!'}
	local V1 V2 V3 V4 V5 V6 V7 V8 in
		V1= {Num1 get($)}
		V2= {Num2 get($)}
		V3= [{Checkfight1 get($)} {Checkfight2 get($)} {Checkfight3 get($)}]
		V4= {CheckAll get($)}
		V5= {CheckMap get($)}
		V6= {CheckTrain get($)}
		V7= {CheckAutoMove get($)}
		V8= {Scale_handler get(firstselection:$)}
	 	{SaveValue V1 V2 V3 V4 V5 V6 V7 V8}
 	end
 	{MakeTheChoice}
 	end image:Prof handle:But_prof_Handler)
	
	Grid2 = grid(empty label(image:Prof) empty newline
					newline
					Button_Pok1 Button_Pok2 Button_Pok3
					handle:Grid_Handler2)
	
	Num1 
	NumEntry1 = numberentry(min:0 max:100 init:30 handle:Num1 action:proc{$} {Show {Num1 get($)}} end glue:w pady:10 padx:10)
	Num2
	NumEntry2 = numberentry(min:0 max:10 init:5 handle:Num2 action:proc{$} {Show {Num2 get($)}} end glue:w pady:10 padx:10)
	
	%CheckButtonfight = checkbutton(text:"Autofight" init:false handle:Checkfight action:proc{$} {Show {Checkfight get($)}} end glue:w pady:10 padx:10)
	Checkfight1 Checkfight2 Checkfight3
	CheckButtonfight = lr(radiobutton(text:"Manual"
                       init:true
                       handle:Checkfight1
                       group:radio1)
         						radiobutton(text:"AutoFight"
                     		handle:Checkfight2
                      		group:radio1)
		       						radiobutton(text:"AutoRun"
		                		   handle:Checkfight3
		                 		   group:radio1)
                 		  glue:w pady:10 padx:10)
	
	CheckAutoMove
	CheckButtonMove = checkbutton(text:"AutoMove" init:false handle:CheckAutoMove action:proc{$} {Show {CheckAutoMove get($)}} end glue:w pady:5 padx:5)
	CheckAll
	CheckButtonAll = checkbutton(text:"Unlock All POKEMOZ (set them to normal type)" init:false handle:CheckAll action:proc{$} {Show {CheckAll get($)}} end glue:w pady:5 padx:5)
	CheckMap
	CheckButtonMap = checkbutton(text:"Custom map" init:false handle:CheckMap action:proc{$} {Show {CheckMap get($)}} end glue:w pady:5 padx:5)
	CheckTrain
	CheckButtonTrain = checkbutton(text:"More randoms events!" init:false handle:CheckTrain action:proc{$} {Show {CheckTrain get($)}} end glue:w pady:5 padx:5)
	
	Scale_handler
	Scale = listbox(init:[10 9 8 7 6 5 4 3 2 1]
    handle:Scale_handler action:proc{$} {Show {Scale_handler get(firstselection:$)}} end tdscrollbar:false glue:w)
	
	Grid1 = grid(newline
					empty newline
					newline	%hello!
					newline %NumEntry1 -- 4
					newline	%speed of -- 5
					newline %NumEntry2 --6
					newline	%autopilot -- 7
					newline %autofight
					newline  %Automove -- 9
					newline
					newline %Custom Option - 11
					newline
					newline %speed of combat - 13
					newline %Scale + CheckButtonAll - 14
					newline %Map choice - 15
					newline %trainer move choice - 16
					handle:Grid_Handler1)
			
	Placeholder_handler G1 G2
   Desc=placeholder(glue:nswe handle:Placeholder_handler)
in
	fun {LaunchTheIntro}
		Window = {QTk.build td(title:'Choose you pokemon!' Desc)}
	
	%Build the two grid	
		{Placeholder_handler set(td(handle:G2
             Grid2))} 
       {Placeholder_handler set(td(handle:G1
             Grid1))} 
             		                 
	%The parameters window
	  	{Grid_Handler1 configure(label(text:"Hello! Enter your game's parameters below." font:Font22 glue:w) column:1 columnspan:3 row:1 pady:5)}
	  	{Grid_Handler1 configure(NumEntry1 column:1 columnspan:3 row:4 pady:5 sticky:w)}
	  	{Grid_Handler1 configure(NumEntry2 column:1 columnspan:3 row:6 pady:5 sticky:w)}
	  	{Grid_Handler1 configure(label(text:"Wild POKEMOZ probability: [0,100]" font:Font12 glue:w) pady:5 padx:5 column:1 columnspan:2 row:3 sticky:w)}
	  	{Grid_Handler1 configure(label(text:"Auto-pilote options:" font:Font16 glue:w pady:10 padx:10)  column:1 columnspan:3 row:7 pady:5 padx:5 sticky:w)}
	  	{Grid_Handler1 configure(CheckButtonfight column:1 columnspan:3 row:8 pady:5 sticky:w)}
		{Grid_Handler1 configure(CheckButtonMove column:1 columnspan:3 row:9 pady:1 sticky:w)}
		{Grid_Handler1 configure(label(text:"Custom Option" font:Font22 glue:w pady:10 padx:10) column:1 columnspan:3 row:11 pady:5 padx:5 sticky:w)}
		{Grid_Handler1 configure(label(text:"Speed of combat:" font:Font12 glue:w pady:5 padx:5) column:1 row:13 sticky:nw pady:5 padx:5)}
		{Grid_Handler1 configure(Scale column:1 row:14 rowspan:10 sticky:nw pady:5 padx:5)}
		{Grid_Handler1 configure(CheckButtonAll column:2 row:14 sticky:nw)}
		{Grid_Handler1 configure(CheckButtonMap column:2 row:15 sticky:nw)}
		{Grid_Handler1 configure(CheckButtonTrain column:2 row:16 sticky:nw)}
		
	  	{Grid_Handler1 configure(label(text:"Speed of POKEMOZ trainers: [0,10]" font:Font12 glue:w pady:5 padx:5)  pady:10 padx:10 column:1 columnspan:2 row:5 sticky:w)}
		{Grid_Handler1 configure(tdspace(glue:w width:10) column:1 columnspan:3 row:2 pady:5)}
		{Grid_Handler1 configure(Button_Prof column:3 rowspan:25 row:3 pady:5 padx:15 sticky:n)}
		{Window show}
		Ok
	end
	
	proc {MakeTheChoice}
		{Placeholder_handler set(G2)}
	end

end	


