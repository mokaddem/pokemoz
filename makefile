all: compile run

clean:
	rm *ozf

compile:
	ozc -c DisplayMap.oz -o DisplayMap.ozf
	ozc -c CutImages.oz -o CutImages.ozf
	ozc -c MoveHero.oz -o MoveHero.ozf
	ozc -c Util.oz -o Util.ozf

run:
	ozengine DisplayMap.ozf > /dev/null &
	
run-verbose:
	ozengine DisplayMap.ozf
