#!/usr/bin/env ruby
require 'optparse'

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
#use option row and columns to parametrize
# use option order (per row or per columns)

##handle input arguments
options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: example.rb [options]"

  opts.on("-v", "--[no-]verbose", "Run verbosely") do |v|
    options[:verbose] = v
  end
end.parse!

p options
p ARGV
#old way
if ARGV.length == 0 || ["-h", "-H", "--help"].include?(ARGV[0])
	puts usage
	puts
	puts description
	puts
	puts example
	Kernel::exit
end

## @param 1 file pdf to be modified
#gather input document
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

totPages = %x[pdfinfo Cap3.pdf | grep "Pages"]
totPages = totPages[/[0-9]+/]

pages = %x[pdfinfo -f 1 -l 3 Cap3.pdf | grep "Page\ "]
pages.each do |lol|
  numPage = lol[/[0-9]+/]
	width = Integer(lol.partition(/[0-9]+ x [0-9]+/)[1].partition(" x ")[0])
	height = Integer(lol.partition(/[0-9]+ x [0-9]+/)[1].partition(" x ")[2])
	puts "w #{width}"
	puts "h #{height}"
	#%x{gs -sDEVICE=pdfwrite -dNOPAUSE -dBATCH -dFirstPage=#{pageNumber} -dLastPage=#{pageNumber} -sOutputFile="out.pdf" "#{filename}"}
	#puts %x[gs -sDEVICE=pdfwrite -o outputPdf.pdf -c "[/CropBox [54 54 1314 810] /PAGES pdfmark" -f inputPdf.pdf]
	#puts %x[gs -sDEVICE=pdfwrite -o outputPdf.pdf -c "[/CropBox [54 54 1314 810] /PAGES pdfmark" -f inputPdf.pdf]
	#puts %x[gs -sDEVICE=pdfwrite -o outputPdf.pdf -c "[/CropBox [54 54 1314 810] /PAGES pdfmark" -f inputPdf.pdf]
	#puts %x[gs -sDEVICE=pdfwrite -o outputPdf.pdf -c "[/CropBox [54 54 1314 810] /PAGES pdfmark" -f inputPdf.pdf]

end

# merge subpages

#crop the document?

#remove temporary files
Dir.rmdir(tmpFolder)

