#! /bin/bash

# L'obiettivo è far leggere le slides una per pagina.
# Bisogna prima croppare i margini bianchi, altrimenti vengono rimossi dal kindle sballando la visualizzazione
# e quindi adattare la dimensione a 85x114 mm

# Dependancies pdftk imagemagick texlive-extra-utils

# @param 1 file pdf da elaborare
clear
filename=$1
newFilename=adapted_$filename
echo "Elaboro file $filename. Verrà salvato come $newFilename"
borderSize=5

tmpFolder="/tmp/"${0##*/}$filename$RANDOM
echo "Creata tmp folder: $tmpFolder"

#nella cartella temporanea verranno messe le singole pagine da elaborare ad una ad una
mkdir $tmpFolder

pdftk $1 burst output $tmpFolder/%04d.pdf
echo "Estratte singole pagine"

totPagine=$(ls $tmpFolder | wc -l)
pagina=1;
echo "$totPagine pagine da elaborare"

for tmpFile in $tmpFolder/*.pdf; do
	pdfcrop $tmpFile $tmpFile > /dev/null &
	echo "crop "
done
wait
pagina=1;
for tmpFile in $tmpFolder/*.pdf; do
	echo -n "$pagina / $totPagine"
#	pdfcrop $tmpFile $tmpFile > /dev/null
#	echo -n " -> crop"
	width=`convert $tmpFile -ping -format "%w" info:`
	heigth=`convert $tmpFile -ping -format "%h" info:`
	optimalWidth=$(echo "scale=0; 120*$heigth/85+1" | bc)

	if [ $optimalWidth -gt $width ]; then
		marginLeftAndRight=$[($optimalWidth-$width)/2]
		#convert $tmpFile -border ${border}x0 $tmpFile #ma questo trasforma in immagine
		pdfcrop --margins "$marginLeftAndRight 0" $tmpFile  $tmpFile > /dev/null
		echo -n " -> margini"
	else
		optimalWidth=$width
#		echo -n " -> dimensione ok"
	fi

	if [ ! -e  $[optimalWidth]x$[heigth]x$borderSize.pdf ]; then
		border.sh $optimalWidth $heigth $borderSize
		convert $[optimalWidth]x$[heigth]x$borderSize.png $[optimalWidth]x$[heigth]x$borderSize.pdf 
		rm $[optimalWidth]x$[heigth]x$borderSize.png
		echo -n " -> creato bordo"
#	else
#		echo -n " -> bordo già pronto"
	fi
	pdftk $tmpFile stamp $[optimalWidth]x$[heigth]x$borderSize.pdf output $tmpFile.pdf
	echo -n " -> bordo"
	echo " -> fatta"
	pagina=$[$pagina+1]
done

echo "Elaborate tutte le pagine"
# merge
#convert "$tmpFolder/*.pdf" "n.$filename"
pdftk $tmpFolder/*.pdf.pdf cat output $newFilename
echo "Creato il pdf finale: $newFilename"

rm -r $tmpFolder
rm *x*x$borderSize.pdf
echo "rimossi i files temporanei"
