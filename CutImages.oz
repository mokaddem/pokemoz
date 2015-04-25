functor
import
	System(show:Show)
	QTk at 'x-oz://system/wp/QTk.ozf'
	DisplayMap(heroHandle:HeroHandle)
export 
	MoveHero
	Face
define


%%%%% CREATE MOUVEMENT IMAGES %%%%%   
   PathHeroTotal = photo(file:'Images/HGSS_143.gif')
   HeroImage = {QTk.newImage PathHeroTotal}   
%Down
   Down1 = {QTk.newImage photo()}
   Down2 = {QTk.newImage photo()}
   Down3 = {QTk.newImage photo()}
   Down4 = {QTk.newImage photo()}
   {Down1 copy(HeroImage 'from':o(0 0 64 64))} Face=Down1
   {Down2 copy(HeroImage 'from':o(64 0 128 64))}
   {Down3 copy(HeroImage 'from':o(128 0 192 64))}
   {Down4 copy(HeroImage 'from':o(192 0 256 64))}
%Right
   Right1 = {QTk.newImage photo()}
   Right2 = {QTk.newImage photo()}
   Right3 = {QTk.newImage photo()}
   Right4 = {QTk.newImage photo()}
   {Right1 copy(HeroImage 'from':o(0 128 64 192))}
   {Right2 copy(HeroImage 'from':o(64 128 128 192))}
   {Right3 copy(HeroImage 'from':o(128 128 192 192))}
   {Right4 copy(HeroImage 'from':o(192 128 256 192))}
%Left
   Left1 = {QTk.newImage photo()}
   Left2 = {QTk.newImage photo()}
   Left3 = {QTk.newImage photo()}
   Left4 = {QTk.newImage photo()}
   {Left1 copy(HeroImage 'from':o(0 64 64 128))}
   {Left2 copy(HeroImage 'from':o(64 64 128 128))}
   {Left3 copy(HeroImage 'from':o(128 64 192 128))}
   {Left4 copy(HeroImage 'from':o(192 64 256 128))}
%Up
   Up1 = {QTk.newImage photo()}
   Up2 = {QTk.newImage photo()}
   Up3 = {QTk.newImage photo()}
   Up4 = {QTk.newImage photo()}
   {Up1 copy(HeroImage 'from':o(0 192 64 256))}
   {Up2 copy(HeroImage 'from':o(64 192 128 256))}
   {Up3 copy(HeroImage 'from':o(128 192 192 256))}
   {Up4 copy(HeroImage 'from':o(192 192 256 256))}
%PROCEDURE THAT ANIMATE AND MOVE THE HERO
   proc {MoveHero Dir}
      D=75 in
      case Dir
      of r then
	 {HeroHandle set(image:Right1)}
	 {Delay D}
	 {HeroHandle set(image:Right2)}
	 {HeroHandle move(8.5 0)}
	 {Delay D}
	 {HeroHandle set(image:Right3)}
	 {HeroHandle move(8.5 0)}
	 {Delay D}
	 {HeroHandle set(image:Right4)}
	 {HeroHandle move(8.5 0)}
	 {Delay D}
	 {HeroHandle set(image:Right1)}
	 {HeroHandle move(8.5 0)}
      []l then
	 {HeroHandle set(image:Left1)}
	 {Delay D}
	 {HeroHandle set(image:Left2)}
	 {HeroHandle move(~8.5 0)}
	 {Delay D}
	 {HeroHandle set(image:Left3)}
	 {HeroHandle move(~8.5 0)}
	 {Delay D}
	 {HeroHandle set(image:Left4)}
	 {HeroHandle move(~8.5 0)}
	 {Delay D}
	 {HeroHandle set(image:Left1)}
	 {HeroHandle move(~8.5 0)}
       []d then
         {HeroHandle set(image:Down1)}
	 {Delay D}
	 {HeroHandle set(image:Down2)}
	 {HeroHandle move(0 8.5)}
	 {Delay D}
	 {HeroHandle set(image:Down3)}
	 {HeroHandle move(0 8.5)}
	 {Delay D}
	 {HeroHandle set(image:Down4)}
	 {HeroHandle move(0 8.5)}
	 {Delay D}
	 {HeroHandle set(image:Down1)}
	 {HeroHandle move(0 8.5)}
      []u then
         {HeroHandle set(image:Up1)}
	 {Delay D}
	 {HeroHandle set(image:Up2)}
	 {HeroHandle move(0 ~8.5)}
	 {Delay D}
	 {HeroHandle set(image:Up3)}
	 {HeroHandle move(0 ~8.5)}
	 {Delay D}
	 {HeroHandle set(image:Up4)}
	 {HeroHandle move(0 ~8.5)}
	 {Delay D}
	 {HeroHandle set(image:Up1)}
	 {HeroHandle move(0 ~8.5)}
      end
   end

end


%   HeroLibrary = {QTk.newImageLibrary}
%  {HeroLibrary newPhoto(name:({String.toAtom "Yo.gif"}) BeerImage)}

