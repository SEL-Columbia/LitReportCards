all: sada.html about.html index.html
about.html: about.md
	markdown about.md > about.html
index.html: index.Rmd
	echo "require(knitr); knit2html('index.Rmd')" | R --vanilla --no-save
sada.html: sada.Rmd
	echo "require(knitr); knit2html('sada.Rmd')" | R --vanilla --no-save
download:
	Rscript Download.R
clean:
	rm cache/*
	touch sada.Rmd
