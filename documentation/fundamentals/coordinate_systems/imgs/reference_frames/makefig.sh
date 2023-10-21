pdflatex global_cartesian.tex
pdftocairo -png -r 600 global_cartesian.pdf
mv global_cartesian-1.png global_cartesian.png

rm *.aux
rm *.dvi
rm *.fdb_latexmk
rm *.fls
rm *.log
rm *.xdv