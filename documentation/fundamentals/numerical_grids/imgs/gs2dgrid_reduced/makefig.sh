pdflatex gs2dgrid_reduced.tex
pdftocairo -png -r 600 gs2dgrid_reduced.pdf
mv gs2dgrid_reduced-1.png gs2dgrid_reduced.png

rm *.aux
rm *.dvi
rm *.fdb_latexmk
rm *.fls
rm *.log
rm *.xdv