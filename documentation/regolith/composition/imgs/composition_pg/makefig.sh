pdflatex composition_pg.tex
pdftocairo -svg composition_pg.pdf
# pdftocairo -png -r 600 lwcm.pdf
# mv lwcm-1.png lwcm.png

rm *.aux
rm *.dvi
rm *.fdb_latexmk
rm *.fls
rm *.log
rm *.xdv