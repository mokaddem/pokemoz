all: compile run

clean:
	rm *ozf

compile:
	ozc -c PokeConfig.oz -o PokeConfig.ozf
	ozc -c Trainer.oz -o Trainer.ozf
	ozc -c DisplayMap.oz -o DisplayMap.ozf
	ozc -c CutImages.oz -o CutImages.ozf
	ozc -c MoveHero.oz -o MoveHero.ozf

run:
	ozengine DisplayMap.ozf > /dev/null &
	
run-verbose:
	ozengine DisplayMap.ozf
	
open:
	gedit *oz makefile &
