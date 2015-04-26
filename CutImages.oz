functor
import
	QTk at 'x-oz://system/wp/QTk.ozf'
	DisplayMap(heroHandle:HeroHandle squareLengthFloat:SquareLengthFloat)

export 
	Grass_Tile
	Road_Tile
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
	{Down1 copy(HeroImage 'from':o(0 0 64 64) subsample:o(2))} Face=Down1
	{Down2 copy(HeroImage 'from':o(64 0 128 64) subsample:o(2))}
	{Down3 copy(HeroImage 'from':o(128 0 192 64) subsample:o(2))}
	{Down4 copy(HeroImage 'from':o(192 0 256 64) subsample:o(2))}
	DownFrame = frame(Down1 Down2 Down3 Down4)
%Right
	Right1 = {QTk.newImage photo()}
	Right2 = {QTk.newImage photo()}
	Right3 = {QTk.newImage photo()}
	Right4 = {QTk.newImage photo()}
	{Right1 copy(HeroImage 'from':o(0 128 64 192) subsample:o(2))}
	{Right2 copy(HeroImage 'from':o(64 128 128 192) subsample:o(2))}
	{Right3 copy(HeroImage 'from':o(128 128 192 192) subsample:o(2))}
	{Right4 copy(HeroImage 'from':o(192 128 256 192) subsample:o(2))}
	RightFrame = frame(Right1 Right2 Right3 Right4)
%Left
	Left1 = {QTk.newImage photo()}
	Left2 = {QTk.newImage photo()}
	Left3 = {QTk.newImage photo()}
	Left4 = {QTk.newImage photo()}
	{Left1 copy(HeroImage 'from':o(0 64 64 128) subsample:o(2))}
	{Left2 copy(HeroImage 'from':o(64 64 128 128) subsample:o(2))}
	{Left3 copy(HeroImage 'from':o(128 64 192 128) subsample:o(2))}
	{Left4 copy(HeroImage 'from':o(192 64 256 128) subsample:o(2))}
	LeftFrame = frame(Left1 Left2 Left3 Left4)
%Up
	Up1 = {QTk.newImage photo()}
	Up2 = {QTk.newImage photo()}
	Up3 = {QTk.newImage photo()}
	Up4 = {QTk.newImage photo()}
	{Up1 copy(HeroImage 'from':o(0 192 64 256) subsample:o(2))}
	{Up2 copy(HeroImage 'from':o(64 192 128 256) subsample:o(2))}
	{Up3 copy(HeroImage 'from':o(128 192 192 256) subsample:o(2))}
	{Up4 copy(HeroImage 'from':o(192 192 256 256) subsample:o(2))}
	UpFrame = frame(Up1 Up2 Up3 Up4)
%
AllHeroFrames = heroFrames(upFrame:UpFrame rightFrame:RightFrame leftFrame:LeftFrame downFrame:DownFrame)

%%%% Create Ground Tile %%%%%
%Grass_Tile_old = {QTk.newImage photo(file:'Images/Ground/grass-modif.gif')} %In the case if we need to adapt ground size
%Grass_Tile = {QTk.newImage photo()}	
%{Grass_Tile copy(Grass_Tile_old 'from':o(0 0 16 16) zoom:o(2))}
Grass_Tile = {QTk.newImage photo(file:'Images/Ground/grass-modif.gif')}
Road_Tile = {QTk.newImage photo(file:'Images/Ground/dirt-modif.gif')}
end


%   HeroLibrary = {QTk.newImageLibrary}
%  {HeroLibrary newPhoto(name:({String.toAtom "Yo.gif"}) BeerImage)}

