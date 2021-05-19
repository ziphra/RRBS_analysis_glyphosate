#!/bin/sh

#  compare2.sh
#
#
#  Created by Euphrasie Servant on 29/04/2021.
#


export s=m


compare_gos.py ./f${s}7genetogo.txt ./f${s}12genetogo.txt > ./compare_$s.txt
grep "XX" ./compare_$s.txt | sed 's/XX //' > ./sharedby$s.txt
tr -s " " < ./sharedby$s.txt > ./sharedby${s}bis.txt
sed -i '' 's/,/./' ./sharedby${s}bis.txt
sed -i '' 's/ /;/' ./sharedby${s}bis.txt
sed -i '' 's/ /;/' ./sharedby${s}bis.txt
sed -i '' 's/ /;/' ./sharedby${s}bis.txt
sed -i '' 's/ /;/' ./sharedby${s}bis.txt


cat ./f${s}7genetogo.txt | while read line
do
    echo $line > temp.txt
    export b=`awk 'BEGIN {FS=" "}; {print $1}' temp.txt`
    export a=`awk 'BEGIN {FS=" "}; {print $2}' temp.txt`
    sed -i '' "/^$a/ s/$/,$b/" "./sharedby${s}bis.txt"
done
sed -i '' 's/,/;/' ./sharedby${s}bis.txt
sed -i '' 's/$/;/' ./sharedby${s}bis.txt

cat ./f${s}12genetogo.txt | while read line
do
    echo $line > temp.txt
    export b=`awk 'BEGIN {FS=" "}; {print $1}' temp.txt`
    export a=`awk 'BEGIN {FS=" "}; {print $2}' temp.txt`
    sed -i '' "/^$a/ s/$/,$b/" "./sharedby${s}bis.txt"
done
sed -i '' 's/;,/;/' ./sharedby${s}bis.txt
