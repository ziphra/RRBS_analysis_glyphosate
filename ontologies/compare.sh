#!/bin/sh

#  compare.sh
#  
#
#  Created by Euphrasie Servant on 22/04/2021.
#

compare_gos.py ff12.txt fF7.txt fm12.txt fm7.txt > goatools_comparisons.txt

grep -w "\.X\.\." goatools_comparisons.txt | sed 's/.X..//' > uniqueff7.txt
grep "X\.\.\." goatools_comparisons.txt | sed 's/.X.. //' > uniqueff12.txt
grep "\.\.X\." goatools_comparisons.txt | sed 's/..X. //' > uniquefm12.txt
grep "\.\.\.X" goatools_comparisons.txt | sed 's/.X.. //' > uniquefm7.txt
grep "XXXX" goatools_comparisons.txt | sed 's/XXXX //' > sharedbyall.txt

awk 'BEGIN{FS=" ";OFS=" "} {print $1,"#",$2,$3,$4,$5}'  sharedbyall.txt

go_plot.py --go_file=sharedbyall.txt -o sharedbyall.png
