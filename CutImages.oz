functor
import
	QTk at 'x-oz://system/wp/QTk.ozf'
export 
	Grass_Tile
	Road_Tile
	HeroFace
	PokeFace
	AllHeroFrames
	AllPokeFrames
define

PathHeroTotal = 'Images/HGSS_143.gif'
PathPokeTotal = 'Images/006_0.gif'
L = 64

fun {GetFrame X Image}
	Frame = frame({QTk.newImage photo()} {QTk.newImage photo()} {QTk.newImage photo()} {QTk.newImage photo()}) in
	{Frame.1 copy(Image 'from':o(0*L X*L 1*L (X+1)*L) subsample:o(1))}
	{Frame.2 copy(Image 'from':o(1*L X*L 2*L (X+1)*L) subsample:o(1))}
	{Frame.3 copy(Image 'from':o(2*L X*L 3*L (X+1)*L) subsample:o(1))}
	{Frame.4 copy(Image 'from':o(3*L X*L 4*L (X+1)*L) subsample:o(1))}
	Frame
end

%%%%% CREATE MOVEMENT IMAGES %%%%%   
fun {CreateMovementImages Path}
	PathHeroTotal = photo(file:Path)
	HeroImage = {QTk.newImage PathHeroTotal}
	in
	allFrames(upFrame:{GetFrame 3 HeroImage} rightFrame:{GetFrame 2 HeroImage} leftFrame:{GetFrame 1 HeroImage} downFrame:{GetFrame 0 HeroImage})
end

AllHeroFrames = {CreateMovementImages PathHeroTotal}
HeroFace = AllHeroFrames.downFrame.1
AllPokeFrames = {CreateMovementImages PathPokeTotal}
PokeFace = AllPokeFrames.downFrame.1


%%%% Create Ground Tile %%%%%
Grass_Tile_old = {QTk.newImage photo(file:'Images/Ground/grass-modif.gif')} %In the case if we need to adapt ground size
Grass_Tile = {QTk.newImage photo()}	
{Grass_Tile copy(Grass_Tile_old 'from':o(0 0 16 16) zoom:o(2))}
%Grass_Tile = {QTk.newImage photo(file:'Images/Ground/grass-modif.gif')}
Road_Tile_old = {QTk.newImage photo(file:'Images/Ground/dirt-modif.gif')}
Road_Tile = {QTk.newImage photo()}	
{Road_Tile copy(Road_Tile_old 'from':o(0 0 16 16) zoom:o(2))}
end
