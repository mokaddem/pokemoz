all: compile run

clean:
	rm *ozf

compile:
	ozc -c DisplayMap.oz -o DisplayMap.ozf

run:
	ozengine DisplayMap.ozf > /dev/null &
	
run-verbose:
	ozengine DisplayMap.ozf
