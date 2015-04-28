functor
import
	QTk at 'x-oz://system/wp/QTk.ozf'

	PokeConfig(sQUARE_LENGTH:SQUARE_LENGTH hERO_SUBSAMPLE:HERO_SUBSAMPLE gRASS_ZOOM:GRASS_ZOOM pOKE_ZOOM:POKE_ZOOM)


export 
	Grass_Tile
	Road_Tile
	HeroFace
	PokeFace
	AllHeroFrames
	AllPokeFrames
	AllSprites_B
	

define
PathHeroTotal = 'Images/HGSS_143.gif'
PathPokeTotal = 'Images/001_0.gif'
PathPokeBattleSprites = "Images/Pokemon-sprites-battle/own/sprite_B"

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
{Grass_Tile copy(Grass_Tile_old 'from':o(0 0 16 16) zoom:o(GRASS_ZOOM))}

Road_Tile_old = {QTk.newImage photo(file:'Images/Ground/dirt-modif.gif')}
Road_Tile = {QTk.newImage photo()}	
{Road_Tile copy(Road_Tile_old 'from':o(0 0 16 16) zoom:o(GRASS_ZOOM))}

%%% Create Pokemoz Battle Sprites %%%
	
	Sprite_B1_old = {QTk.newImage photo(file:{Append PathPokeBattleSprites "1.gif"})}
	Sprite_B2_old = {QTk.newImage photo(file:{Append PathPokeBattleSprites "2.gif"})}
	Sprite_B3_old = {QTk.newImage photo(file:{Append PathPokeBattleSprites "3.gif"})}
	Sprite_B4_old = {QTk.newImage photo(file:{Append PathPokeBattleSprites "4.gif"})}
	Sprite_B5_old = {QTk.newImage photo(file:{Append PathPokeBattleSprites "5.gif"})}
	Sprite_B6_old = {QTk.newImage photo(file:{Append PathPokeBattleSprites "6.gif"})}
	Sprite_B7_old = {QTk.newImage photo(file:{Append PathPokeBattleSprites "7.gif"})}
	Sprite_B8_old = {QTk.newImage photo(file:{Append PathPokeBattleSprites "8.gif"})}
	Sprite_B9_old = {QTk.newImage photo(file:{Append PathPokeBattleSprites "9.gif"})}

	Sprite_B1 = {QTk.newImage photo()}
	Sprite_B2 = {QTk.newImage photo()}
	Sprite_B3 = {QTk.newImage photo()}
	Sprite_B4 = {QTk.newImage photo()}
	Sprite_B5 = {QTk.newImage photo()}
	Sprite_B6 = {QTk.newImage photo()}
	Sprite_B7 = {QTk.newImage photo()}
	Sprite_B8 = {QTk.newImage photo()}
	Sprite_B9 = {QTk.newImage photo()}
	
	{Sprite_B1 copy(Sprite_B1_old zoom:o(POKE_ZOOM))}
	{Sprite_B2 copy(Sprite_B2_old zoom:o(POKE_ZOOM))}
	{Sprite_B3 copy(Sprite_B3_old zoom:o(POKE_ZOOM))}
	{Sprite_B4 copy(Sprite_B4_old zoom:o(POKE_ZOOM))}
	{Sprite_B5 copy(Sprite_B5_old zoom:o(POKE_ZOOM))}
	{Sprite_B6 copy(Sprite_B6_old zoom:o(POKE_ZOOM))}
	{Sprite_B7 copy(Sprite_B7_old zoom:o(POKE_ZOOM))}
	{Sprite_B8 copy(Sprite_B8_old zoom:o(POKE_ZOOM))}
	{Sprite_B9 copy(Sprite_B9_old zoom:o(POKE_ZOOM))}
	

	AllSprites_B = sprite_b(Sprite_B1 Sprite_B2 Sprite_B3 Sprite_B4 Sprite_B5 Sprite_B6 Sprite_B7 Sprite_B8 Sprite_B9) 

end

%   HeroLibrary = {QTk.newImageLibrary}
%  {HeroLibrary newPhoto(name:({String.toAtom "Yo.gif"}) BeerImage)}

