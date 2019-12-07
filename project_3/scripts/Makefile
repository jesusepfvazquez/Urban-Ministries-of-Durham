mydocker:
	docker build -t mydocker .

../results/Project3.html:
	docker run -d --rm -v "$(pwd):$(pwd)" -w "$(pwd)" mydocker
	python tax.py 
	python patientsdata.py 
	Rscript -e "library(rmarkdown); rmarkdown::render('Project3.Rmd', 'html_document')" && mv Project3.html ../results
	rm *.csv