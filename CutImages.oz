functor
import
	QTk at 'x-oz://system/wp/QTk.ozf'
	DisplayMap(heroHandle:HeroHandle squareLengthFloat:SquareLengthFloat)

export 
	Face
	AllHeroFrames
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
	DownFrame = frame(Down1 Down2 Down3 Down4)
%Right
	Right1 = {QTk.newImage photo()}
	Right2 = {QTk.newImage photo()}
	Right3 = {QTk.newImage photo()}
	Right4 = {QTk.newImage photo()}
	{Right1 copy(HeroImage 'from':o(0 128 64 192))}
	{Right2 copy(HeroImage 'from':o(64 128 128 192))}
	{Right3 copy(HeroImage 'from':o(128 128 192 192))}
	{Right4 copy(HeroImage 'from':o(192 128 256 192))}
	RightFrame = frame(Right1 Right2 Right3 Right4)
%Left
	Left1 = {QTk.newImage photo()}
	Left2 = {QTk.newImage photo()}
	Left3 = {QTk.newImage photo()}
	Left4 = {QTk.newImage photo()}
	{Left1 copy(HeroImage 'from':o(0 64 64 128))}
	{Left2 copy(HeroImage 'from':o(64 64 128 128))}
	{Left3 copy(HeroImage 'from':o(128 64 192 128))}
	{Left4 copy(HeroImage 'from':o(192 64 256 128))}
	LeftFrame = frame(Left1 Left2 Left3 Left4)
%Up
	Up1 = {QTk.newImage photo()}
	Up2 = {QTk.newImage photo()}
	Up3 = {QTk.newImage photo()}
	Up4 = {QTk.newImage photo()}
	{Up1 copy(HeroImage 'from':o(0 192 64 256))}
	{Up2 copy(HeroImage 'from':o(64 192 128 256))}
	{Up3 copy(HeroImage 'from':o(128 192 192 256))}
	{Up4 copy(HeroImage 'from':o(192 192 256 256))}
	UpFrame = frame(Up1 Up2 Up3 Up4)
%
AllHeroFrames = heroFrames(upFrame:UpFrame rightFrame:RightFrame leftFrame:LeftFrame downFrame:DownFrame)

end


%   HeroLibrary = {QTk.newImageLibrary}
%  {HeroLibrary newPhoto(name:({String.toAtom "Yo.gif"}) BeerImage)}

