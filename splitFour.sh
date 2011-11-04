#!/usr/bin/usr

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
# crop and order subpages
gs -sDEVICE=pdfwrite -o outputPdf.pdf -c "[/CropBox [54 54 1314 810] /PAGES pdfmark" -f inputPdf.pdf

# merge subpages

#crop the document?

