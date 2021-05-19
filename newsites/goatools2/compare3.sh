#!/bin/sh

#  compare3.sh
#
#
#  Created by Euphrasie Servant on 29/04/2021.
#




#compare_gos.py ./7/ff7.txt ./7/fm7.txt ./12/ff12.txt ./12/fm12.txt > /compare_7.txt
grep "X\.X\." ./compare.txt | sed 's/X.X. //' > ./sharedby7.txt
tr -s " " < ./sharedby7.txt > ./sharedby7bis.txt
sed -i '' 's/,/./' ./sharedby7bis.txt
sed -i '' 's/ /;/' ./sharedby7bis.txt
sed -i '' 's/ /;/' ./sharedby7bis.txt
sed -i '' 's/ /;/' ./sharedby7bis.txt
sed -i '' 's/ /;/' ./sharedby7bis.txt


cat ff7genetogo.txt | while read line
do
    echo $line > temp.txt
    export b=`awk 'BEGIN {FS=" "}; {print $1}' temp.txt`
    export a=`awk 'BEGIN {FS=" "}; {print $2}' temp.txt`
    sed -i '' "/^$a/ s/$/,$b/" "./sharedby7bis.txt"
done
sed -i '' 's/,/;/' ./sharedby7bis.txt
sed -i '' 's/$/;/' ./sharedby7bis.txt

#cat ff12genetogo.txt  | while read line
#do
#    echo $line > temp.txt
#    export b=`awk 'BEGIN {FS=" "}; {print $1}' temp.txt`
#    export a=`awk 'BEGIN {FS=" "}; {print $2}' temp.txt`
#    sed -i '' "/^$a/ s/$/,$b/" "./sharedby7bis.txt"
#done
#sed -i '' 's/$/;/' ./sharedby7bis.txt

cat fm7genetogo.txt  | while read line
do
    echo $line > temp.txt
    export b=`awk 'BEGIN {FS=" "}; {print $1}' temp.txt`
    export a=`awk 'BEGIN {FS=" "}; {print $2}' temp.txt`
    sed -i '' "/^$a/ s/$/,$b/" "./sharedby7bis.txt"
done
sed -i '' 's/$/;/' ./sharedby7bis.txt

#cat fm12genetogo.txt  | while read line
#do
#    echo $line > temp.txt
#    export b=`awk 'BEGIN {FS=" "}; {print $1}' temp.txt`
#    export a=`awk 'BEGIN {FS=" "}; {print $2}' temp.txt`
#    sed -i '' "/^$a/ s/$/,$b/" "./sharedby7bis.txt"
#done
#sed -i '' 's/$/;/' ./sharedby7bis.txt


sed -i '' 's/;,/;/g' ./sharedby7bis.txt
