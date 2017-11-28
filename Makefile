all: build

deploy:
	git stash save --all
	git checkout master
	git push -u origin master
	git checkout gh-pages
	git reset --hard master
	mkdir -pv out
	latexmk -pdf -outdir=out notes.tex
	latexmk -c -outdir=out
	mv out/notes.pdf .
	rm -rf out
	git add notes.pdf
	git commit -m 'Compiled notes.pdf'
	git push --force -u origin gh-pages
	git checkout master
	git clean -Xdf
	git stash pop

build:
	mkdir -pv out
	latexmk -pdf -outdir=out notes.tex
	latexmk -c -outdir=out

continuous:
	mkdir -pv out
	latexmk -pvc -f -pdf -outdir=out notes.tex; pkill evince

clean:
	rm -rf out
