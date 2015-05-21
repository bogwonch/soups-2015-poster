abstract.pdf: abstract.tex abstract.bib
	latexmk -pdf abstract
	latexmk -c
	open abstract.pdf

%.ps: %.pdf
	pdf2ps $<

all: abstract.pdf abstract.ps 

README.md: abstract.tex
	pandoc -f latex -t markdown_github $< -o $@

clean:
	latexmk -C abstract
