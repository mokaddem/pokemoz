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

%%%%% CREATE MOVEMENT IMAGES %%%%%   
fun {CreateMovementImages Path}
	PathHeroTotal = photo(file:Path)
	HeroImage = {QTk.newImage PathHeroTotal}
	AllFrames
%Down
	Down1 = {QTk.newImage photo()}
	Down2 = {QTk.newImage photo()}
	Down3 = {QTk.newImage photo()}
	Down4 = {QTk.newImage photo()}
	{Down1 copy(HeroImage 'from':o(0 0 64 64) subsample:o(HERO_SUBSAMPLE))}
	{Down2 copy(HeroImage 'from':o(64 0 128 64) subsample:o(HERO_SUBSAMPLE))}
	{Down3 copy(HeroImage 'from':o(128 0 192 64) subsample:o(HERO_SUBSAMPLE))}
	{Down4 copy(HeroImage 'from':o(192 0 256 64) subsample:o(HERO_SUBSAMPLE))}
	DownFrame = frame(Down1 Down2 Down3 Down4)
%Right
	Right1 = {QTk.newImage photo()}
	Right2 = {QTk.newImage photo()}
	Right3 = {QTk.newImage photo()}
	Right4 = {QTk.newImage photo()}
	{Right1 copy(HeroImage 'from':o(0 128 64 192) subsample:o(HERO_SUBSAMPLE))}
	{Right2 copy(HeroImage 'from':o(64 128 128 192) subsample:o(HERO_SUBSAMPLE))}
	{Right3 copy(HeroImage 'from':o(128 128 192 192) subsample:o(HERO_SUBSAMPLE))}
	{Right4 copy(HeroImage 'from':o(192 128 256 192) subsample:o(HERO_SUBSAMPLE))}
	RightFrame = frame(Right1 Right2 Right3 Right4)
%Left
	Left1 = {QTk.newImage photo()}
	Left2 = {QTk.newImage photo()}
	Left3 = {QTk.newImage photo()}
	Left4 = {QTk.newImage photo()}
	{Left1 copy(HeroImage 'from':o(0 64 64 128) subsample:o(HERO_SUBSAMPLE))}
	{Left2 copy(HeroImage 'from':o(64 64 128 128) subsample:o(HERO_SUBSAMPLE))}
	{Left3 copy(HeroImage 'from':o(128 64 192 128) subsample:o(HERO_SUBSAMPLE))}
	{Left4 copy(HeroImage 'from':o(192 64 256 128) subsample:o(HERO_SUBSAMPLE))}
	LeftFrame = frame(Left1 Left2 Left3 Left4)
%Up
	Up1 = {QTk.newImage photo()}
	Up2 = {QTk.newImage photo()}
	Up3 = {QTk.newImage photo()}
	Up4 = {QTk.newImage photo()}
	{Up1 copy(HeroImage 'from':o(0 192 64 256) subsample:o(HERO_SUBSAMPLE))}
	{Up2 copy(HeroImage 'from':o(64 192 128 256) subsample:o(HERO_SUBSAMPLE))}
	{Up3 copy(HeroImage 'from':o(128 192 192 256) subsample:o(HERO_SUBSAMPLE))}
	{Up4 copy(HeroImage 'from':o(192 192 256 256) subsample:o(HERO_SUBSAMPLE))}
	UpFrame = frame(Up1 Up2 Up3 Up4)

in
	AllFrames = allFrames(upFrame:UpFrame rightFrame:RightFrame leftFrame:LeftFrame downFrame:DownFrame)
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

