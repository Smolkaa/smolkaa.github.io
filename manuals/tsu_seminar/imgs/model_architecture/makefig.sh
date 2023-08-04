#pdflatex model_architecture.tex
#latex model_architecture.tex
#dvisvgm model_architecture.dvi

pdflatex loop_I.tex
pdftocairo -svg loop_I.pdf
pdftocairo -png -r 600 loop_I.pdf


rm *.aux
rm *.dvi
rm *.fdb_latexmk
rm *.fls
rm *.log
rm *.xdv