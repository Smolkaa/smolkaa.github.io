#pdflatex model_architecture.tex
#latex model_architecture.tex
#dvisvgm model_architecture.dvi

#pdflatex loop_I.tex
#pdftocairo -svg loop_I.pdf
#pdftocairo -png -r 600 loop_I.pdf
#mv loop_I-1.png loop_I.png

#pdflatex loop_II.tex
#pdftocairo -svg loop_II.pdf
#pdftocairo -png -r 600 loop_II.pdf
#mv loop_II-1.png loop_II.png

#pdflatex loop_III.tex
#pdftocairo -svg loop_III.pdf
#pdftocairo -png -r 600 loop_III.pdf
#mv loop_III-1.png loop_III.png

pdflatex loop_IV.tex
pdftocairo -svg loop_IV.pdf
pdftocairo -png -r 600 loop_IV.pdf
mv loop_IV-1.png loop_IV.png

rm *.aux
rm *.dvi
rm *.fdb_latexmk
rm *.fls
rm *.log
rm *.xdv