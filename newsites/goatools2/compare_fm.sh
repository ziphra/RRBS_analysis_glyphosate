#!/bin/sh

#  compare2.sh
#
#
#  Created by Euphrasie Servant on 29/04/2021.
#

export F=7
compare_gos.py ./ff${F}genetogo.txt ./fm${F}genetogo.txt > ./compare_${F}.txt
grep "XX" ./compare_${F}.txt | sed 's/XX //' > ./sharedby${F}.txt
tr -s " " < ./sharedby${F}.txt > ./sharedby${F}bis.txt
sed -i '' 's/,/./' ./sharedby${F}bis.txt
sed -i '' 's/ /;/' ./sharedby${F}bis.txt
sed -i '' 's/ /;/' ./sharedby${F}bis.txt
sed -i '' 's/ /;/' ./sharedby${F}bis.txt
sed -i '' 's/ /;/' ./sharedby${F}bis.txt


cat ./ff${F}genetogo.txt | while read line
do
    echo $line > temp.txt
    export b=`awk 'BEGIN {FS=" "}; {print $1}' temp.txt`
    export a=`awk 'BEGIN {FS=" "}; {print $2}' temp.txt`
    sed -i '' "/^$a/ s/$/,$b/" "./sharedby${F}bis.txt"
done
sed -i '' 's/,/;/' ./sharedby${F}bis.txt
sed -i '' 's/$/;/' ./sharedby${F}bis.txt

cat ./fm${F}genetogo.txt | while read line
do
    echo $line > temp.txt
    export b=`awk 'BEGIN {FS=" "}; {print $1}' temp.txt`
    export a=`awk 'BEGIN {FS=" "}; {print $2}' temp.txt`
    sed -i '' "/^$a/ s/$/,$b/" "./sharedby${F}bis.txt"
done
sed -i '' 's/;,/;/' ./sharedby${F}bis.txt
