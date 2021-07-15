# Nota 1: A pasta final com os arquivos HTML foi alterada para docs para
# atender os requisitos do github pages.

all: deps
	pug --watch *.pug --obj componentes/membros.js --out docs/ --pretty

deps:
	mkdir -p docs/img
	cp img/* docs/img/
	mkdir -p docs/css
	cp _variables.scss node_modules/materialize-css/sass/components/_variables.scss
	sass node_modules/materialize-css/sass/materialize.scss docs/css/materialize.css

watch:
	rm -rf     docs/
	mkdir -p   docs/
	cp *.html  docs/
	cp -r font docs/
	cp -r img  docs/
	cp -r css  docs/
	cp -r js   docs/
	pug --watch *.pug --out docs/ --pretty

check:
	linkchecker docs/

docs:
	tar zcvf docs.tgz -C docs .
