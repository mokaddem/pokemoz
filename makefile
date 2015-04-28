all: compile run-verbose

clean:
	rm *ozf

%.ozf: %.oz
	ozc -c $< -o $@

compile: PokeConfig.ozf Trainer.ozf DisplayMap.ozf CutImages.ozf MoveHero.ozf Util.oz

run:
	ozengine DisplayMap.ozf > /dev/null &
	
run-verbose:
	ozengine DisplayMap.ozf
	
open:
	gedit *oz makefile &
