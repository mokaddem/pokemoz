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
	local V1 V2 V3 V4 V5 V6 in
		V1= {Num1 get($)}
		V2= {Num2 get($)}
		V3= {Checkfight get($)}
		V4= {CheckAll get($)}
		V5= {CheckNormal get($)}
		V6= {Name get($)}
	 	{SaveValue V1 V2 V3 V4 V5 V6}
 	end
 	{MakeTheChoice}
 	end image:Prof handle:But_prof_Handler)
	
	Grid2 = grid(empty empty  empty newline
					Button_Pok1 Button_Pok2 Button_Pok3
					handle:Grid_Handler2)
	
	Num1 
	NumEntry1 = numberentry(min:0 max:100 init:30 handle:Num1 action:proc{$} {Show {Num1 get($)}} end glue:w pady:10 padx:10)
	Num2
	NumEntry2 = numberentry(min:0 max:10 init:5 handle:Num2 action:proc{$} {Show {Num2 get($)}} end glue:w pady:10 padx:10)
	Checkfight
	CheckButtonfight = checkbutton(text:"Autofight" init:false handle:Checkfight action:proc{$} {Show {Checkfight get($)}} end glue:w pady:10 padx:10)
	Name
	NameEntry = entry(init:"Enter your name." handle:Name action:proc{$} {Show {String.toAtom {Name get($)}}} end pady:10 padx:10)
	CheckAll
	CheckButtonAll = checkbutton(text:"Unlock All POKEMOZ" init:false handle:CheckAll action:proc{$} {Show {CheckAll get($)}} end glue:w pady:10 padx:10)
	CheckNormal
	CheckButtonNormal = checkbutton(text:"Set the type of new POKEMOZ to type NORMAL" init:false handle:CheckNormal action:proc{$} {Show {CheckNormal get($)}} end glue:w pady:10 padx:10)
	
	Grid1 = grid(newline
					empty newline
					label(text:"Wild POKEMOZ probability: [0,100]" font:Font16 glue:w pady:10 padx:10) empty NameEntry newline
					NumEntry1 empty empty newline
					label(text:"Speed of POKEMOZ trainers: [0,10]" font:Font16 glue:w pady:10 padx:10) newline
					NumEntry2 empty empty newline
					label(text:"Set the autofight active" font:Font10 glue:w pady:10 padx:10) label(text:"Press Here to play -->" font:Font10 glue:e) newline
					CheckButtonfight newline
					newline
					label(text:"Custom Option" font:Font22 glue:w pady:10 padx:10) newline
					CheckButtonAll newline
					CheckButtonNormal newline
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
	  	{Grid_Handler1 configure(label(text:"Hello! Enter your game's parameter below." font:Font22 glue:w) column:1 columnspan:3 row:1 pady:5)}
		{Grid_Handler1 configure(tdspace(glue:w width:10) column:1 columnspan:3 row:2 pady:10)}
		{Grid_Handler1 configure(Button_Prof column:3 rowspan:25 row:4 pady:5 padx:5)}

		{Window show}
		Ok
	end
	
	proc {MakeTheChoice}
		{Placeholder_handler set(G2)}
	end

end	


