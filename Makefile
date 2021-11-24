# Nota 1: A pasta final com os arquivos HTML foi alterada para docs para
# atender os requisitos do github pages.

.PHONY: all deps update css js preview check docs html watch_pug watch_css

SERVICOS= \
acolhida.pug \
avaliacao-de-vocacionados.pug \
atividades.pug \
grupo-vivencial-para-formadores.pug \
psicodiagnostico.pug \
psicoterapia-grupal.pug \
psicoterapia-individual.pug \
supervisao-e-grupos-de-estudo-para-psicologos.pug

all: update deps css js html favicon

watch_pug:
	pug --watch *.pug --out docs/ --pretty
	pug --watch es/*.pug --out docs/es/ --pretty

watch_css:
	sass --watch scss/style.scss docs/css/style.css

diff_es:
	for i in *.pug; do diff $$i es/$$i || vi $$i es/$$i; done

editar_servicos:
	vim $(SERVICOS)

html:
	pug *.pug    --out docs/   --pretty
	pug es/*.pug --out docs/es --pretty

favicon:
	inkscape -w 16 -h 16 -o 16.png img/ita-logo-min_1024x1024.svg
	inkscape -w 32 -h 32 -o 32.png img/ita-logo-min_1024x1024.svg
	inkscape -w 48 -h 48 -o 48.png img/ita-logo-min_1024x1024.svg
	convert 16.png 32.png 48.png docs/favicon.ico

deps:
	npm install
	mkdir -p docs/img
	cp -r img/* docs/img/
	mkdir -p docs/css
	cp _variables.scss node_modules/materialize-css/sass/components/_variables.scss

css:
	sass node_modules/materialize-css/sass/materialize.scss docs/css/materialize.css
	sass scss/style.scss docs/css/style.css
	cp node_modules/animate.css/animate.min.css docs/css/
	sed -i "s/\(fa-font-path: *\"\).*\(\".*\)/\1fonts\2/" node_modules/fontawesome-4.7/scss/_variables.scss
	sass node_modules/fontawesome-4.7/scss/font-awesome.scss docs/css/fontawesome.min.css
	cp -r node_modules/fontawesome-4.7/fonts docs/css/

fa5:
	cp node_modules/@fortawesome/fontawesome-free/css/fontawesome.min.css docs/css/
	cp node_modules/@fortawesome/fontawesome-free/svgs/brands/facebook-f.svg img/facebook.svg
	cp node_modules/@fortawesome/fontawesome-free/svgs/brands/instagram.svg  img/instagram.svg
	cp node_modules/@fortawesome/fontawesome-free/svgs/brands/youtube.svg    img/youtube.svg


js:
	cp node_modules/wowjs/dist/wow.min.js       docs/js/

preview:
	google-chrome $(PWD)/docs/index.html &
	git gui &

update:
	rm -rf     docs/
	mkdir -p   js css img
	mkdir -p   docs/
	cp -r js   docs/
	cp -r css  docs/
	cp -r img  docs/

check:
	linkchecker docs/

docs:
	tar zcvf docs.tgz -C docs .
