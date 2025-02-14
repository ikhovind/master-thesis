#!/bin/sh
pdflatex -synctex=1 -interaction=nonstopmode "main".tex
rm -r -f *.aux *.bcf *.lof *.log *.lot *.out *.xml *.toc *.fls *.gz *.fdb_latexmk

# rm main.fdb_latexmk
# rm *.fls
# rm *.synctex.gz
