pdflatex lunar_orbit_orientation.tex
pdftocairo -svg lunar_orbit_orientation.pdf

rm *.aux
rm *.dvi
rm *.fdb_latexmk
rm *.fls
rm *.log
rm *.xdv