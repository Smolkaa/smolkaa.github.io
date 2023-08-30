pdflatex landing_position_calc.tex
pdftocairo -svg landing_position_calc.pdf
pdftocairo -png -r 600 landing_position_calc.pdf
mv landing_position_calc-1.png landing_position_calc.png

rm *.aux
rm *.dvi
rm *.fdb_latexmk
rm *.fls
rm *.log
rm *.xdv