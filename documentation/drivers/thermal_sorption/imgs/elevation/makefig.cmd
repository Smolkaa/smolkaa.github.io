pdflatex mbd_elevation.tex
pdftocairo -svg mbd_elevation.pdf

pdflatex mbfd_elevation.tex
pdftocairo -svg mbfd_elevation.pdf

DEL *.aux
DEL *.dvi
DEL *.fdb_latexmk
DEL *.fls
DEL *.log
DEL *.xdv