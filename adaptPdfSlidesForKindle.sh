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
echo "$totPagine pagine da elaborare"
echo "Croppo tutte le pagine"

for tmpFile in $tmpFolder/*.pdf; do
	pdfcrop $tmpFile $tmpFile > /dev/null &
done
wait
echo "Croppate tutte le pagine. Ora creo i margini ottimi"

for tmpFile in $tmpFolder/*.pdf; do
	width=`convert $tmpFile -ping -format "%w" info:`
	heigth=`convert $tmpFile -ping -format "%h" info:`
	optimalWidth=$(echo "scale=0; 120*$heigth/85+1" | bc)
	if [ $optimalWidth -gt $width ]; then
		marginLeftAndRight=$[($optimalWidth-$width)/2]
		pdfcrop --margins "$marginLeftAndRight 0" $tmpFile  $tmpFile > /dev/null &
	else
		optimalWidth=$width
#		echo -n " -> dimensione ok"
	fi

done
wait
echo "creati tutti i margini"

pagina=1;
for tmpFile in $tmpFolder/*.pdf; do
	width=`convert $tmpFile -ping -format "%w" info:`
	heigth=`convert $tmpFile -ping -format "%h" info:`
	echo -n "$pagina / $totPagine"
	if [ ! -e  $[width]x$[heigth]x$borderSize.pdf ]; then
		border.sh $width $heigth $borderSize
		convert $[width]x$[heigth]x$borderSize.png $[width]x$[heigth]x$borderSize.pdf 
		rm $[width]x$[heigth]x$borderSize.png
		echo -n " -> creato bordo"
#	else
#		echo -n " -> bordo già pronto"
	fi
	pdftk $tmpFile stamp $[width]x$[heigth]x$borderSize.pdf output $tmpFile.pdf
	echo -n " -> bordo"
	echo " -> fatta"
	pagina=$[$pagina+1]
done

echo "Elaborate tutte le pagine"
# merge
pdftk $tmpFolder/*.pdf.pdf cat output $newFilename
echo "Creato il pdf finale: $newFilename"

rm -r $tmpFolder
rm *x*x$borderSize.pdf
echo "rimossi i files temporanei"
