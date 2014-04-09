all: changes.html about.html index.html
about.html: about.md
	markdown about.md > about.html
index.html: index.Rmd data/Learning_Processed.RDS
	echo "require(knitr); knit2html('index.Rmd')" | R --vanilla --no-save
changes.html: changes.Rmd
	echo "require(knitr); knit2html('changes.Rmd')" | R --vanilla --no-save
download:
	Rscript DownloadAndPreProcess.R
clean:
	rm cache/*
	touch *.Rmd
