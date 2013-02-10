#!/usr/bin/env ruby

usage = "USAGE: adaptPdfSlidesForKindle filename"

description = "This script adapt page sizes to fit kindle.
we need to use ghostscript directly in order to preserve text:
we do not want to obtain images instead of plain text."

example = "no example."
Process::exit!
puts 'asd'

# if ARGV.length == 0
# 	puts usage 
# 	puts
# 	puts description
# 	puts
# 	puts example
# 	Kernel::exit!
# end

# # L'obiettivo è far leggere le slides una per pagina.
# # Bisogna prima croppare i margini bianchi, altrimenti vengono rimossi dal kindle sballando la visualizzazione
# # e quindi adattare la dimensione a 85x114 mm

# # Dependancies pdftk imagemagick texlive-extra-utils

# # @param 1 file pdf da elaborare
# # clear
# # puts ARGV

# abort("foaf")
# filename = $1
# newFilename = "adapted_#{filename}"
# # puts "Elaboro file #{filename}. Verrà salvato come #{newFilename}"
# borderSize=5

# tmpFolder="/tmp/"+$0+$filename+$RANDOM
# p tmpFolder
# Kernel::exit
# echo "Creata tmp folder: $tmpFolder"

# #nella cartella temporanea verranno messe le singole pagine da elaborare ad una ad una
# mkdir $tmpFolder

# pdftk $1 burst output $tmpFolder/%04d.pdf
# echo "Estratte singole pagine"

# totPagine=$(ls $tmpFolder | wc -l)
# echo "$totPagine pagine da elaborare"
# echo "Croppo tutte le pagine"

# for tmpFile in $tmpFolder/*.pdf; do
# 	pdfcrop $tmpFile $tmpFile > /dev/null &
# done
# wait
# echo "Croppate tutte le pagine. Ora creo i margini ottimi"

# for tmpFile in $tmpFolder/*.pdf; do
# 	width=`convert $tmpFile -ping -format "%w" info:`
# 	height=`convert $tmpFile -ping -format "%h" info:`
# 	optimalWidth=$(echo "scale=0; 120*$height/85+1" | bc)
# 	if [ $optimalWidth -gt $width ]; then
# 		marginLeftAndRight=$[($optimalWidth-$width)/2]
# 		pdfcrop --margins "$marginLeftAndRight 0" $tmpFile  $tmpFile > /dev/null &
# 	else
# 		optimalWidth=$width
# #		echo -n " -> dimensione ok"
# 	fi

# done
# wait
# for tmpFile in $tmpFolder/*.pdf; do
# 	pdfcrop --margins "$borderSize $borderSize" $tmpFile  $tmpFile > /dev/null &
# done
# wait

# echo "creati tutti i margini"

# pagina=1;
# for tmpFile in $tmpFolder/*.pdf; do
# 	width=`convert $tmpFile -ping -format "%w" info:`
# 	height=`convert $tmpFile -ping -format "%h" info:`
# 	echo -n "$pagina / $totPagine"
# 	if [ ! -e  $[width]x$[height]x$borderSize.pdf ]; then
# 		border.sh $width $height $borderSize
# 		convert $[width]x$[height]x$borderSize.png $[width]x$[height]x$borderSize.pdf 
# 		rm $[width]x$[height]x$borderSize.png
# 		echo -n " -> creato bordo"
# #	else
# #		echo -n " -> bordo già pronto"
# 	fi
# 	pdftk $tmpFile stamp $[width]x$[height]x$borderSize.pdf output $tmpFile.pdf
# 	echo -n " -> bordo"
# 	echo " -> fatta"
# 	pagina=$[$pagina+1]
# done

# echo "Elaborate tutte le pagine"
# # merge
# pdftk $tmpFolder/*.pdf.pdf cat output $newFilename
# echo "Creato il pdf finale: $newFilename"

# rm -r $tmpFolder
# rm *x*x$borderSize.pdf
# echo "rimossi i files temporanei"
