Main.pdf: *.tex unit1.tex graphwork.tex unit2.tex
	pdflatex Main.tex

%.tex: ../%.pas
	source-highlight -s pascal -f latex \
		< $< > $@

clean:
	rm Main.pdf 1.tex S.tex
