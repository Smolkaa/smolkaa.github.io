pdflatex gs2dgrid.tex
pdftocairo -png -r 600 gs2dgrid.pdf
mv gs2dgrid-1.png gs2dgrid.png

rm *.aux
rm *.dvi
rm *.fdb_latexmk
rm *.fls
rm *.log
rm *.xdv