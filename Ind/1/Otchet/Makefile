Main.pdf: *.tex 1.tex
	pdflatex Main.tex

1.tex: ../1.pas
	source-highlight -s pascal -f latex \
		< ../1.pas > 1.tex

clean:
	rm Main.pdf 1.tex
