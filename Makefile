# Nota 1: A pasta final com os arquivos HTML foi alterada para docs para
# atender os requisitos do github pages.

.PHONY: all deps update css js preview check docs html watch_pug watch_css

SERVICOS= \
acolhida.pug \
avaliacao-de-vocacionados.pug \
atividades.pug \
cursos-e-assessorias.pug \
grupo-vivencial-para-formadores.pug \
psicodiagnostico.pug \
psicoterapia-grupal.pug \
psicoterapia-individual.pug \
supervisao-e-grupos-de-estudo-para-psicologos.pug

all: update deps fixme css js html favicon publish

watch_pug:
	pug --watch *.pug --out docs/ --pretty
	pug --watch es/*.pug --out docs/es/ --pretty

watch_css:
	sass --watch scss/style.scss docs/css/style.css

diff_es:
	for i in *.pug; do diff $$i es/$$i || vi $$i es/$$i; done

diff_es_md:
	for i in textos/*.md; do diff $$i es/$$i || vi $$i es/$$i; done

fixme:
	echo "extends componentes/layout.pug" > fixme.pug
	echo "block main" >> fixme.pug
	echo "  pre" >> fixme.pug
	find . -type f -name "*.pug" -exec grep -HC 5 FIXME {} \; | sed "s/^/    |/" | grep -v "fixme.pug" >> fixme.pug
	find . -type f -name "*.md"  -exec grep -HC 5 FIXME {} \; | sed "s/^/    |/" >> fixme.pug

editar_servicos:
	vim $(SERVICOS)

html:
	pug *.pug    --out docs/   --pretty 2> pug.log  || echo "FALHA"
	pug es/*.pug --out docs/es --pretty 2>> pug.log || echo "FALHA"

favicon:
	cp favicon.ico docs/

favicon.real:
	inkscape -w 16 -h 16 -o 16.png img/ita-logo-min_1024x1024.svg
	inkscape -w 32 -h 32 -o 32.png img/ita-logo-min_1024x1024.svg
	inkscape -w 48 -h 48 -o 48.png img/ita-logo-min_1024x1024.svg
	convert 16.png 32.png 48.png docs/favicon.ico
	inkscape -w 1080 -h 1080 -o img/ita-logo_1080x1080.png img/ita-logo-min_1024x1024.svg
	convert img/ita-logo_1080x1080.png -background white -flatten -alpha off docs/img/ita-logo_1080x1080.png
	optipng docs/img/ita-logo_1080x1080.png
	cp docs/img/ita-logo_1080x1080.png img/

publish:
	cp CNAME docs/
	git add docs/
	git add pug.log
	git commit -m "Atualização automática" && git push || echo "Sem atualização"

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

check_members:
	grep slug componentes/membros.pug \
		| sed "s/\",//" \
		| sed "s/.*\"//" \
		| while read -r slug; do if [ ! -f $$slug.pug ]; then \
		echo Faltando $$slug; \
		echo "extends componentes/layout.pug" > $$slug.pug; \
		echo "block main" >> $$slug.pug; \
		echo "  - var slug = \"$$slug\"" >> $$slug.pug; \
		echo "  include componentes/detalhes_do_membro" >> $$slug.pug; \
		echo "  include:markdown-it(html) textos/$$slug.md" >> $$slug.pug; \
		fi; done

copy_members_es:
	grep slug componentes/membros.pug \
		| sed "s/\",//" \
		| sed "s/.*\"//" \
		| while read -r slug; do cp $$slug.pug es/$$slug.pug; done

js:
	cp node_modules/wowjs/dist/wow.min.js       docs/js/

preview:
	google-chrome $(PWD)/docs/index.html &
	git gui &

update:
	echo rm -rf     docs/
	mkdir -p   js css img
	mkdir -p   docs/
	cp -r js   docs/
	cp -r css  docs/
	cp -r img  docs/

check:
	linkchecker docs/

docs:
	tar zcvf docs.tgz -C docs .
