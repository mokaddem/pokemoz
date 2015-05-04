functor
import
	QTk at 'x-oz://system/wp/QTk.ozf'
	PokeConfig(hERO_SUBSAMPLE:HERO_SUBSAMPLE gRASS_ZOOM:GRASS_ZOOM pOKE_ZOOM:POKE_ZOOM pathTrainersTotal:PathTrainersTotal pathPokeTotal:PathPokeTotal starter:Starter)
	Util(customNewCell:CustomNewCell cellSet:CellSet cellGet:CellGet)

export 
	Grass_Tile
	Road_Tile
	Start_Tile
	End_Tile
	Stone_Tile_Grass
	Stone_Tile_Dirt
	Tree_Cont
	Tree_End
	Tree_Grass
	HouseAll
	Tomb
	Background_Battle_Trainer
	Background_Battle_Grass
	
	HeroFace
	PokeFace
	Pokeball
	
	AllHeroFrames
	AllPokeFrames
	AllSprites_B
	AllSprites_Op
	AllTrainerBattleFrames
	
	CreateMovementImages
	GetSprite_frame_Op
	GetNewPokeFrames

define
PathPokeBattleSpritesBack = "Images/Pokemon-sprites-battle/own/sprite_B"
PathPokeBattleSpritesOp = "Images/Pokemon-sprites-battle/op-separeted/"

L = 64

fun {GetFrame X Image}
	Frame = frame({QTk.newImage photo()} {QTk.newImage photo()} {QTk.newImage photo()} {QTk.newImage photo()}) in
	{Frame.1 copy(Image 'from':o(0*L X*L 1*L (X+1)*L) subsample:o(HERO_SUBSAMPLE))}
	{Frame.2 copy(Image 'from':o(1*L X*L 2*L (X+1)*L) subsample:o(HERO_SUBSAMPLE))}
	{Frame.3 copy(Image 'from':o(2*L X*L 3*L (X+1)*L) subsample:o(HERO_SUBSAMPLE))}
	{Frame.4 copy(Image 'from':o(3*L X*L 4*L (X+1)*L) subsample:o(HERO_SUBSAMPLE))}
	Frame
end

%%%%% CREATE MOVEMENT IMAGES %%%%%   
fun {CreateMovementImages Path}
	PathTotal = photo(file:Path)
	TrainerImage = {QTk.newImage PathTotal}

	in
	allFrames(upFrame:{GetFrame 3 TrainerImage} rightFrame:{GetFrame 2 TrainerImage} leftFrame:{GetFrame 1 TrainerImage} downFrame:{GetFrame 0 TrainerImage})
end

proc {GetNewPokeFrames N}
	{CellSet AllPokeFrames {CreateMovementImages {Append PathPokeTotal {Append {IntToString N} ".gif"}}}}
end

AllHeroFrames = {CreateMovementImages {Append PathTrainersTotal "overworld/hero.gif"}}
HeroFace = AllHeroFrames.downFrame.1
AllPokeFrames = {CustomNewCell {CreateMovementImages {Append PathPokeTotal {Append {IntToString Starter} ".gif"}}}}
PokeFace = {CellGet AllPokeFrames}.downFrame.1

%%%% Create Ground Tile %%%%%
Grass_Tile_old = {QTk.newImage photo(file:'Images/Ground/grass-modif.gif')} %In the case if we need to adapt ground size
Grass_Tile = {QTk.newImage photo()}	
{Grass_Tile copy(Grass_Tile_old 'from':o(0 0 16 16) zoom:o(GRASS_ZOOM))}

Road_Tile_old = {QTk.newImage photo(file:'Images/Ground/dirt-modif.gif')}
Road_Tile = {QTk.newImage photo()}	
{Road_Tile copy(Road_Tile_old 'from':o(0 0 16 16) zoom:o(GRASS_ZOOM))}

Stone_Tile_Grass_old = {QTk.newImage photo(file:'Images/Ground/stone.gif')}
Stone_Tile_Grass = {QTk.newImage photo()}	
{Stone_Tile_Grass copy(Stone_Tile_Grass_old 'from':o(0 0 16 16) zoom:o(GRASS_ZOOM))}

Stone_Tile_Dirt_old = {QTk.newImage photo(file:'Images/Ground/stone-dirt.gif')}
Stone_Tile_Dirt = {QTk.newImage photo()}	
{Stone_Tile_Dirt copy(Stone_Tile_Dirt_old 'from':o(0 0 16 16) zoom:o(GRASS_ZOOM))}

Start_Tile_old = {QTk.newImage photo(file:'Images/Ground/start-tile.gif')}
Start_Tile = {QTk.newImage photo()}	
{Start_Tile copy(Start_Tile_old 'from':o(0 0 16 16) zoom:o(GRASS_ZOOM))}
End_Tile = {QTk.newImage photo(file:'Images/Ground/end-tile.gif')}

Tree_Cont = {QTk.newImage photo(file:'Images/Ground/tree/tree-cont.gif')}
Tree_End = {QTk.newImage photo(file:'Images/Ground/tree/tree-end.gif')}
Tree_Grass = {QTk.newImage photo(file:'Images/Ground/tree/tree-grass.gif')}

Tomb = {QTk.newImage photo(file:'Images/Ground/tomb.gif')}

% HOUSE %
House1_old = {QTk.newImage photo(file:'Images/Ground/house/house2.gif')}
House2_old = {QTk.newImage photo(file:'Images/Ground/house/house3.gif')}
House3_old = {QTk.newImage photo(file:'Images/Ground/house/house4.gif')}
House4_old = {QTk.newImage photo(file:'Images/Ground/house/house5.gif')}
House5_old = {QTk.newImage photo(file:'Images/Ground/house/house6.gif')}
House6_old = {QTk.newImage photo(file:'Images/Ground/house/house7.gif')}
House7_old = {QTk.newImage photo(file:'Images/Ground/house/house8.gif')}
House8_old = {QTk.newImage photo(file:'Images/Ground/house/house9.gif')}
House9_old = {QTk.newImage photo(file:'Images/Ground/house/house10.gif')}
House10_old = {QTk.newImage photo(file:'Images/Ground/house/house11.gif')}
House11_old = {QTk.newImage photo(file:'Images/Ground/house/house12.gif')}
House12_old = {QTk.newImage photo(file:'Images/Ground/house/house13.gif')}

House1 = {QTk.newImage photo()}
House2 = {QTk.newImage photo()}
House3 = {QTk.newImage photo()}
House4 = {QTk.newImage photo()}
House5 = {QTk.newImage photo()}
House6 = {QTk.newImage photo()}
House7 = {QTk.newImage photo()}
House8 = {QTk.newImage photo()}
House9 = {QTk.newImage photo()}
House10 = {QTk.newImage photo()}
House11 = {QTk.newImage photo()}
House12 = {QTk.newImage photo()}

{House1 copy(House1_old 'from':o(0 0 16 16) zoom:o(GRASS_ZOOM))}
{House2 copy(House2_old 'from':o(0 0 16 16) zoom:o(GRASS_ZOOM))}
{House3 copy(House3_old 'from':o(0 0 16 16) zoom:o(GRASS_ZOOM))}
{House4 copy(House4_old 'from':o(0 0 16 16) zoom:o(GRASS_ZOOM))}
{House5 copy(House5_old 'from':o(0 0 16 16) zoom:o(GRASS_ZOOM))} 
{House6 copy(House6_old 'from':o(0 0 16 16) zoom:o(GRASS_ZOOM))} 
{House7 copy(House7_old 'from':o(0 0 16 16) zoom:o(GRASS_ZOOM))} 
{House8 copy(House8_old 'from':o(0 0 16 16) zoom:o(GRASS_ZOOM))}
{House9 copy(House9_old 'from':o(0 0 16 16) zoom:o(GRASS_ZOOM))} 
{House10 copy(House10_old 'from':o(0 0 16 16) zoom:o(GRASS_ZOOM))} 
{House11 copy(House11_old 'from':o(0 0 16 16) zoom:o(GRASS_ZOOM))}
{House12 copy(House12_old 'from':o(0 0 16 16) zoom:o(GRASS_ZOOM))}
HouseAll = house(House1 House2 House3 House4 House5 House6 House7 House8 House9 House10 House11 House12)

Pokeball = {QTk.newImage photo(file:'Images/Pokemon-sprites-battle/pokeball.gif')}
%%% Create Trainer Battle Sprites %%%
AllTrainerBattleFrames_temp = {CustomNewCell trainerbattleframes()}
for I in 1..4 do
	local TrainerImg TrainerImg_old in
		TrainerImg_old = {QTk.newImage photo(file:{Append PathTrainersTotal {Append {IntToString I} ".gif"}})} %In the case if we need to adapt ground size
		TrainerImg = {QTk.newImage photo()}	
		{TrainerImg copy(TrainerImg_old zoom:o(POKE_ZOOM))}
		{CellSet AllTrainerBattleFrames_temp {AdjoinAt {CellGet AllTrainerBattleFrames_temp} I TrainerImg}}
	end
end
AllTrainerBattleFrames = {CellGet AllTrainerBattleFrames_temp}
	
%%% Create Pokemoz Battle Sprites %%%
	Background_Battle_Grass_old = {QTk.newImage photo(file:'Images/Pokemon-sprites-battle/grass-background.gif')}
	Background_Battle_Trainer_old = {QTk.newImage photo(file:'Images/Pokemon-sprites-battle/trainer-background.gif')}
	
	Background_Battle_Grass = {QTk.newImage photo()}
	Background_Battle_Trainer = {QTk.newImage photo()}
	{Background_Battle_Grass copy(Background_Battle_Grass_old zoom:o(POKE_ZOOM-1))}
	{Background_Battle_Trainer copy(Background_Battle_Trainer_old zoom:o(POKE_ZOOM-1))}
	
%MiPoke
	
	fun {GetSprite_frame_B Num}
		Sprite_B_old Sprite_B in
		Sprite_B_old = {QTk.newImage photo(file:{Append PathPokeBattleSpritesBack {Append {IntToString Num} ".gif"}})}
		Sprite_B = {QTk.newImage photo()}
		{Sprite_B copy(Sprite_B_old zoom:o(POKE_ZOOM))}
		Sprite_B
	end
	
	AllSprites_B = sprite_b({GetSprite_frame_B 1} {GetSprite_frame_B 2} {GetSprite_frame_B 3} {GetSprite_frame_B 4} {GetSprite_frame_B 5} {GetSprite_frame_B 6} {GetSprite_frame_B 7} {GetSprite_frame_B 8} {GetSprite_frame_B 9}) 

%OpPoke
	fun {GetSprite_frame_Op Num}
/*		L=64 Sprites_Op_old Sprites_Op in
		Sprites_Op_old = {QTk.newImage photo(file:{Append PathPokeBattleSpritesOp {Append Num ".gif"}})}*/
		Frame1_old Frame2_old Sprites_Op in 
		Frame1_old = {QTk.newImage photo(file:{Append PathPokeBattleSpritesOp {Append "frame1/" {Append {IntToString Num} ".png.gif"}}})}
		Frame2_old = {QTk.newImage photo(file:{Append PathPokeBattleSpritesOp {Append "frame2/" {Append {IntToString Num} ".png.gif"}}})}
		Sprites_Op = sprite_op({QTk.newImage photo()} {QTk.newImage photo()})
		{Sprites_Op.1 copy(Frame1_old 'from':o(0 0 L L)  zoom:o(POKE_ZOOM))}
		{Sprites_Op.2 copy(Frame2_old 'from':o(0 0 L L)  zoom:o(POKE_ZOOM))}
		Sprites_Op
	end
	
	AllSprites_Op = all_sprite_op({GetSprite_frame_Op 1} {GetSprite_frame_Op 2} {GetSprite_frame_Op 3} {GetSprite_frame_Op 4} 
	{GetSprite_frame_Op 5} {GetSprite_frame_Op 6} {GetSprite_frame_Op 7} {GetSprite_frame_Op 8} {GetSprite_frame_Op 9})
		
end

%   HeroLibrary = {QTk.newImageLibrary}
%  {HeroLibrary newPhoto(name:({String.toAtom "Yo.gif"}) BeerImage)}

