functor

import
	System(show:Show)
	Open
	QTk at 'x-oz://system/wp/QTk.ozf'
	
define
	PathPokeStart = "Images/Starter/"
	Prof= {QTk.newImage photo(file:{Append PathPokeStart "prof.gif"})}	
	Pok1= {QTk.newImage photo(file:{Append PathPokeStart "1.gif"})}
	Pok2= {QTk.newImage photo(file:{Append PathPokeStart "2.gif"})}
	Pok3= {QTk.newImage photo(file:{Append PathPokeStart "3.gif"})}
	
	But_1_Handler But_2_Handler But_3_Handler But_prof_Handler Grid_Handler
	Button_Pok1 = button(action:proc{$} {Show 'Pok1'} end image:Pok1 handle:But_1_Handler)
	Button_Pok2 = button(action:proc{$} {Show 'Pok2'} end image:Pok2 handle:But_2_Handler)
	Button_Pok3 = button(action:proc{$} {Show 'Pok3'} end image:Pok3 handle:But_3_Handler)
	Button_Prof = button(action:proc{$} {Show 'Ouch!'} end image:Prof handle:But_prof_Handler)
	
	Grid = grid(empty Button_Prof  empty newline
					Button_Pok1 Button_Pok2 Button_Pok3
					handle:Grid_Handler)

	Window = {QTk.build td(title:'Choose you pokemon!' Grid)}			
%	{Grid_Handler configure(Button_Pok1 Button_Pok2 Button_Pok3 padx:10 pady:10)}	
	
	
in
	{Window show}
%	{Canvas create(image X Y image:Pok1 anchor:nw)
	
	
end

