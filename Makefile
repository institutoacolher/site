all: deps
	pug --watch *.pug --obj componentes/membros.js --out dist/ --pretty

deps:
	mkdir -p dist/img
	cp img/* dist/img/
	mkdir -p dist/css
	cp _variables.scss node_modules/materialize-css/sass/components/_variables.scss
	sass node_modules/materialize-css/sass/materialize.scss dist/css/materialize.css

watch:
	rm -rf     dist/
	mkdir -p   dist/
	cp *.html  dist/
	cp -r font dist/
	cp -r img  dist/
	cp -r css  dist/
	cp -r js   dist/
	pug --watch *.pug --out dist/ --pretty

check:
	linkchecker dist/

dist:
	tar zcvf dist.tgz -C dist .
