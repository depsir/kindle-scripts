#!/usr/bin/env ruby

usage = "USAGE: splitFour filename"

description = "This script splits a pdf document with 4 subpages for each page into a single paged document.
we need to use ghostscript directly in order to preserve text:
we do not want to obtain images instead of plain text."

example = "example:
|----|----|
| 1  | 2  |		|----| |----| |----| |----|
|    |    |		| 1  | | 2  | | 3  | | 4  |
|----|----|	->	|    | |    | |    | |    |
| 3  | 4  |		|----| |----| |----| |----|
|    |    |
|----|----|"

if ARGV.length == 0
	puts usage 
	puts
	puts description
	puts
	puts example
	Kernel::exit
end

#gather input document
##handle input arguments
## @param 1 file pdf to be modified
filename = ARGV[0]
if !File.exists?(filename)
	puts "Il file non esiste"
	Kernel::exit
end

newFilename = "adapted_" + filename
puts "Elaboro file #{filename}. Verrà salvato come #{newFilename}"
borderSize=5

##nella cartella temporanea verranno messe le singole pagine da elaborare ad una ad una
tmpFolder="/tmp/" + filename + rand(10000).to_s
Dir.mkdir(tmpFolder)
puts "Creata tmp folder: " + tmpFolder

#pdftk $1 burst output $tmpFolder/%04d.pdf
#echo "Estratte singole pagine"


# split the input document into subpages

# get page size
a=5
a+=1

pages = %x[pdfinfo -f 1 -l 3 Cap3.pdf | grep "Page\ "]
pages.each do |lol|
#	lol.each_line('x') {|s| puts s}
	width = Integer(lol.partition(/[0-9]+ x [0-9]+/)[1].partition(" x ")[0])
	height = Integer(lol.partition(/[0-9]+ x [0-9]+/)[1].partition(" x ")[2])
	puts "w #{width}"
	puts "h #{height}"
end

# crop and order subpages
#puts %x[gs -sDEVICE=pdfwrite -o outputPdf.pdf -c "[/CropBox [54 54 1314 810] /PAGES pdfmark" -f inputPdf.pdf]

# merge subpages

#crop the document?

#remove temporary files
Dir.rmdir(tmpFolder)
