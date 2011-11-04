#!/usr/bin/env ruby

# this script splits a pdf document with 4 subpages in a page into a single paged document

#example:
#|----|----|
#| 1  | 2  |		|----| |----| |----| |----|
#|    |    |		| 1  | | 2  | | 3  | | 4  |
#|----|----|	->	|    | |    | |    | |    |
#| 3  | 4  |		|----| |----| |----| |----|
#|    |    |
#|----|----|

#we need to use ghostscript directly in order to preserve text:
#we do not want to obtain images instead of plain text

#gather input document
##handle input arguments

# split the input document into subpages

# get page size
pages = %x[pdfinfo -f 1 -l 3 Cap3.pdf | grep "Page\ "]
pages.each do |lol|
	lol.each_line('x') {|s| puts s}
	puts "\n"
end
# crop and order subpages
#puts %x[gs -sDEVICE=pdfwrite -o outputPdf.pdf -c "[/CropBox [54 54 1314 810] /PAGES pdfmark" -f inputPdf.pdf]

# merge subpages

#crop the document?
