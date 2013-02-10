#!/usr/bin/env ruby
require 'optparse'

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
# see http://ruby.about.com/od/advancedruby/a/optionparser.htm
options = {}
OptionParser.new { |opts|
	opts.banner = "Usage: example.rb [options] filename [filenames]"
  options[:rows] = 2
	opts.on("-r rows", "--rows", "Number of rows to split") do |r|
		options[:rows] = r
	end

  options[:cols] = 2
	opts.on("-c columns", "--columns", "Number of columns to split") do |c|
		options[:cols] = c
	end

  options[:rowOffset] = 0
	opts.on("-R", "--rowOffset", "---") do |ro|
		options[:rowOffset] = ro
	end

  options[:colsOffset] = 0
	opts.on("-C", "--colsOffset", "---") do |co|
		options[:colsOffset] = co
	end

  options[:invOrder] = false
	opts.on("-o", "--invertOrder", "Instead of default left to right, top to bottom use top to bottom, left to right ") do
		options[:invOrder] = true
	end

 options[:debug] = false
	opts.on("-d", "--debug", "prints more informations") do
		options[:debug] = true
	end

  opts.on( '-h', '--help', 'Display this screen' ) do
       puts opts
       exit
     end

}.parse!
ARGV.each {|filename|

if File.exists?(filename)
  newFilename = "adapted_" + filename
  puts "Elaboro file #{filename}. Verrà salvato come #{newFilename}"
  borderSize=5

  #nella cartella temporanea verranno messe le singole pagine da elaborare ad una ad una
  tmpFolder="/tmp/" + filename + rand(10000).to_s
  Dir.mkdir(tmpFolder)
  puts "Creata tmp folder: " + tmpFolder

  totPages = %x[pdfinfo Cap3.pdf | grep "Pages"]
  totPages = totPages[/[0-9]+/]

  pages = %x[pdfinfo -f 1 -l #{totPages} Cap3.pdf | grep "Page\ "]
  pages.each do |lol|
          numPage = lol[/[0-9]+/]
	  width = Integer(lol.partition(/[0-9]+ x [0-9]+/)[1].partition(" x ")[0])
	  height = Integer(lol.partition(/[0-9]+ x [0-9]+/)[1].partition(" x ")[2])
	  puts "w #{width}"
	  puts "h #{height}"
  #http://stackoverflow.com/questions/8158295/what-dimensions-do-the-coordinates-in-pdf-cropbox-refer-to
	  %x{gs #{if options[:debug]==false then "-q -sstdout=%sstderr" end} -sDEVICE=pdfwrite -dNOPAUSE -dBATCH -dFirstPage=#{numPage} -dLastPage=#{numPage} -sOutputFile=#{tmpFolder+"/"}page#{numPage}.pdf #{filename} #{if options[:debug]==false then "2>/dev/null" end}}

	  %x{gs #{if options[:debug]==false then "-q -sstdout=%sstderr" end} -sDEVICE=pdfwrite -o #{tmpFolder+"/"}out#{numPage}.1.pdf -c "[/CropBox [0 #{height} #{width/2} #{height/2}] /PAGES pdfmark" -f #{tmpFolder+"/"}page#{numPage}.pdf #{if options[:debug]==false then "2>/dev/null" end}}
	  %x{gs #{if options[:debug]==false then "-q -sstdout=%sstderr" end} -sDEVICE=pdfwrite -o #{tmpFolder+"/"}out#{numPage}.2.pdf -c "[/CropBox [#{width/2} #{height} #{width} #{height/2}] /PAGES pdfmark" -f #{tmpFolder+"/"}page#{numPage}.pdf #{if options[:debug]==false then "2>/dev/null" end}}
	  %x{gs #{if options[:debug]==false then "-q -sstdout=%sstderr" end} -sDEVICE=pdfwrite -o #{tmpFolder+"/"}out#{numPage}.3.pdf -c "[/CropBox [0 #{height/2} #{width/2} 0] /PAGES pdfmark" -f #{tmpFolder+"/"}page#{numPage}.pdf #{if options[:debug]==false then "2>/dev/null" end}}
	  %x{gs #{if options[:debug]==false then "-q -sstdout=%sstderr" end} -sDEVICE=pdfwrite -o #{tmpFolder+"/"}out#{numPage}.4.pdf -c "[/CropBox [#{width/2} #{height/2} #{width} 0] /PAGES pdfmark" -f #{tmpFolder+"/"}page#{numPage}.pdf #{if options[:debug]==false then "2>/dev/null" end}}
          %x{gs #{if options[:debug]==false then "-q -sstdout=%sstderr" end} -dNOPAUSE -sDEVICE=pdfwrite -sOUTPUTFILE=#{tmpFolder+"/"}page#{numPage}.pdf -dBATCH #{tmpFolder+"/"}out#{numPage}.1.pdf #{tmpFolder+"/"}out#{numPage}.2.pdf #{tmpFolder+"/"}out#{numPage}.3.pdf #{tmpFolder+"/"}out#{numPage}.4.pdf #{if options[:debug]==false then "2>/dev/null" end}}

        File.delete("#{tmpFolder+"/"}out#{numPage}.1.pdf")
        File.delete("#{tmpFolder+"/"}out#{numPage}.2.pdf")
        File.delete("#{tmpFolder+"/"}out#{numPage}.3.pdf")
        File.delete("#{tmpFolder+"/"}out#{numPage}.4.pdf")
  end

  # merge subpages
subpages=""
(1..Integer(totPages)).each {|g| subpages=subpages+" "+tmpFolder+"/page"+g.to_s+".pdf"}
 %x{gs #{if options[:debug]==false then "-q -sstdout=%sstderr" end} -dNOPAUSE -sDEVICE=pdfwrite -sOUTPUTFILE=#{newFilename} -dBATCH #{subpages} #{if options[:debug]==false then "2>/dev/null" end}}


  #crop the document?

  #remove temporary files
#  Dir.rmdir(tmpFolder)
else
	puts "Il file non esiste"
end
}

