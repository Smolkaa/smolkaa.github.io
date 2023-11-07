pdflatex mbd_elevation.tex
pdftocairo -svg mbd_elevation.pdf
# pdftocairo -png -r 600 mbd_elevation.pdf
# mv mbd_elevation-1.png mbd_elevation.png

rm *.aux
rm *.dvi
rm *.fdb_latexmk
rm *.fls
rm *.log
rm *.xdv