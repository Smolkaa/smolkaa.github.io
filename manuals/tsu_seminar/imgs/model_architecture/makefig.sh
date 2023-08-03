#pdflatex model_architecture.tex
#latex model_architecture.tex
#dvisvgm model_architecture.dvi

pdflatex loop_I.tex
latex loop_I.tex
dvisvgm loop_I.dvi

rm *.aux
rm *.dvi
rm *.fdb_latexmk
rm *.fls
rm *.log
rm *.xdv