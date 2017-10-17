# pokemoz

## Installation

- [The Mozart Programming System](https://sourceforge.net/projects/mozart-oz/files/v2.0.0-alpha.0/) Runtime and development environment of Oz
- run ```$ make``` and wait (should take ~2min)
- to start a new game, simply run ```$ make run```

## More info

The makefile helps to compile, run and do other stuff.
Here are the main commands (don't forget to extract all the files) :

- make all (or make) : Compile then run verbosely the game
- make compile : Compile every file needed by the program to run
- make run-verbose : Runs the game with all comments in the shell. You must have compiled first.
- make run : Run the game without showing the logs in the shell. You will have to run "make kill" after that.
- make kill : If something went wrong, use it. It will close all the ozwish processes.
- make open : See the result of our labour !
- make clean : Get rid of all this useless files after you saw the best ever PokeMoz !

If you want to run it manually after the compilation, write "ozengine Game.ozf" in the shell

All the parameters of the game are asked at the beginning in a beautiful GUI !

Enjoy !
