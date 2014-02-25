sada.html: sada.Rmd
	echo "require(knitr); knit2html('sada.Rmd')" | R --vanilla --no-save
clean:
	rm cache/*
	touch sada.Rmd
