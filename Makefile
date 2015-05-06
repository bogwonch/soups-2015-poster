all: abstract.pdf README.md
abstract.pdf: abstract.tex abstract.bib
	latexmk -pdf abstract
	latexmk -c
	open abstract.pdf

README.md: abstract.tex
	pandoc -f latex -t markdown_github $< -o $@

clean:
	latexmk -C abstract
