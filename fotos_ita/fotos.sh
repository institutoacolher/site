#!/bin/bash -x

for ano in 2???
do
  pushd "$ano" || exit 1
  filename=../../fotos_$ano.pug
  {
    echo "extends componentes/layout.pug"
    echo "block main"
    echo "  h1 $ano"
    #echo "  .carousel"
  } > "$filename"

  # duration	Number	200	Transition duration in milliseconds.
  # dist	Number	-100	Perspective zoom. If 0, all items are the same size.
  # shift	Number	0	Set the spacing of the center item.
  # padding	Number	0	Set the padding between non center items.
  # numVisible	Number	5	Set the number of visible items.
  # fullWidth	Boolean	false	Make the carousel a full width slider like the second example.
  # indicators	Boolean	false	Set to true to show indicators.
  # noWrap	Boolean	false	Don't wrap around and cycle through items.
  # onCycleTo	Function	null	Callback for when a new slide is cycled to.

  #echo "    .row" >> "$filename"
  for jpg in *.jpg
  do
    # echo "  p $jpg" >> "$filename"
    echo "  img.materialboxed(width=300,src='img/fotos/$jpg') " >> "$filename"
    # echo "    a.carousel-item(href='#$jpg!')" >> "$filename"
    # echo "      img(src='img/fotos/$jpg')" >> "$filename"
    # convert "$jpg" -resize 800x800 "../../img/fotos/$jpg"
  done

  {
    echo "  script."
    echo "    document.addEventListener('DOMContentLoaded', function() {"
    # echo "      var elems = document.querySelectorAll('.carousel');"
    # echo "      var options = {"
    # echo "        fullWidth: true,"
    # echo "        indicators: true,"
    # echo "        numVisible: 1,"
    # echo "      };"
    # echo "      var instances = M.Carousel.init(elems, options);"
    echo "      var elems = document.querySelectorAll('.materialboxed');"
    echo "      var options = {"
    echo "      };"
    echo "      var instances = M.Materialbox.init(elems, options);"
    echo "    });"
  } >> "$filename"

  popd || exit 1
done
