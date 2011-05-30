#!/bin/bash
#
#Author: Romain Goffe
#Date: 30/05/2011
#Description: build personal html biblio

output=goffe.html

if [ $# -gt 0 ]
then
    output=$@
fi

for file in *.bib;
do
#generate
    bibtex2html -dl --no-header --both --style plain --named-field poster "poster" --named-field slides "slides" --named-field pdf "pdf" $file
    
    html=`basename $file bib`html

#chop head
    sed -i "1,12 d" $html
    
#insert title
    if [ "$file" == "thesis.bib" ]
    then
	title="PhD thesis"
    elif [ "$file" == "confs.bib" ]
    then
	title="International conferences"
    elif [ "$file" == "journals.bib" ]
    then
	title="International journals"
    fi
    sed -i "1 i <h2>$title</h2>" $html

#chop tail
#lines=`wc -l goffe.html | awk '{print goffe.html}' `
    lines=`wc -l $html | sed s/$html//  `
    start=`expr $lines - 3`
    end=`expr $lines + 1`
    sed -i "$start,$end d" $html

#close file
    echo "</dl>" >> $html
done

#append in global html file
cat thesis.html > $output
cat confs.html >> $output
cat journals.html >> $output


#append relative path to weblinks
sed -i "s/href=\"/href=\"data\/documents\//g" $output

#send to website
scp  *_abstracts.html *_bib.html teamonfi@team-on-fire.com:www/goffe/data/documents
scp $output teamonfi@team-on-fire.com:www/goffe/data/statiques/001.publications.php