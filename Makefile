build:
	mkdir -pv out
	latexmk -pdf -outdir=out notes.tex
	latexmk -c -outdir=out

continuous:
	mkdir -pv out
	latexmk -pvc -f -pdf -outdir=out notes.tex; pkill evince

clean:
	rm -rf out
