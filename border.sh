#! /bin/bash

#script per creare una immagine trasparente con bordo nero
# @param 1 width
# @param 2 height
# @param 3 border

# out: widthxheightxborder.png

width=$1
height=$2
border=$3

convert -size $[width]x$height xc:#FFFFFF00 $[width]x$[height]x$border.png
convert $[width]x$[height]x$border.png -draw "rectangle 0,0 $width,$border" $[width]x$[height]x$border.png
convert $[width]x$[height]x$border.png -draw "rectangle 0,0 $border,$height" $[width]x$[height]x$border.png
convert $[width]x$[height]x$border.png -draw "rectangle 0,$height $width,$[$height - $border]" $[width]x$[height]x$border.png
convert $[width]x$[height]x$border.png -draw "rectangle $width,0 $[$width - $border],$height" $[width]x$[height]x$border.png
