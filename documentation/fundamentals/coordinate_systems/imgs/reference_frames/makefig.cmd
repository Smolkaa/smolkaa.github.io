latex global_cartesian.tex
dvisvgm global_cartesian.dvi
pdftocairo -png -r 600 global_cartesian.pdf
move global_cartesian-1.png global_cartesian.png

DEL *.aux
DEL *.dvi
DEL *.fdb_latexmk
DEL *.fls
DEL *.log
DEL *.xdv