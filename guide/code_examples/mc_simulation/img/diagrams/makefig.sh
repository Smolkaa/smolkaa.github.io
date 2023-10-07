pdflatex mc_basic.tex
pdftocairo -svg mc_basic.pdf
# pdftocairo -png -r 600 mc_basic.pdf
# mv mc_basic-1.png mc_basic.png

rm *.aux
rm *.dvi
rm *.fdb_latexmk
rm *.fls
rm *.log
rm *.xdv