all: compile run-verbose

clean:
	rm *ozf

%.ozf: %.oz
	ozc -c $< -o $@

compile: PokeConfig.ozf Trainer.ozf DisplayMap.ozf CutImages.ozf MoveHero.ozf Util.ozf Pokemoz.ozf Battle.ozf Data/Offset_data.ozf DisplayBattle.ozf Game.ozf PokeChoice.oz

run:
	ozengine Game.ozf > /dev/null &
	
run-verbose:
	ozengine Game.ozf
	
open:
	gedit *oz makefile &
	
edit: open

kill:
	kill -9 $$(pidof /usr/bin/ozwish)
