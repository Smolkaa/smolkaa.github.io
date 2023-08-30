pdflatex landing_position_calc.tex
pdftocairo -svg landing_position_calc.pdf
pdftocairo -png -r 600 landing_position_calc.pdf
move landing_position_calc-1.png landing_position_calc.png

DEL *.aux
DEL *.dvi
DEL *.fdb_latexmk
DEL *.fls
DEL *.log
DEL *.xdv