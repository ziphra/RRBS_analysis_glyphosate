#!/bin/sh

#  compare3.sh
#
#
#  Created by Euphrasie Servant on 29/04/2021.
#




compare_gos.py ff7genetogo.txt fm7genetogo.txt ff12genetogo.txt fm12genetogo.txt > ./all/compare_all.txt
grep "XXXX" ./all/compare_all.txt | sed 's/XXXX //' > ./all/sharedbyall.txt
tr -s " " < ./all/sharedbyall.txt > ./all/sharedbyallbis.txt
sed -i '' 's/,/./' ./all/sharedbyallbis.txt
sed -i '' 's/ /;/' ./all/sharedbyallbis.txt
sed -i '' 's/ /;/' ./all/sharedbyallbis.txt
sed -i '' 's/ /;/' ./all/sharedbyallbis.txt
sed -i '' 's/ /;/' ./all/sharedbyallbis.txt


cat ff7genetogo.txt | while read line
do
    echo $line > temp.txt
    export b=`awk 'BEGIN {FS=" "}; {print $1}' temp.txt`
    export a=`awk 'BEGIN {FS=" "}; {print $2}' temp.txt`
    sed -i '' "/^$a/ s/$/,$b/" "./all/sharedbyallbis.txt"
done
sed -i '' 's/,/;/' ./all/sharedbyallbis.txt
sed -i '' 's/$/;/' ./all/sharedbyallbis.txt

cat ff12genetogo.txt  | while read line
do
    echo $line > temp.txt
    export b=`awk 'BEGIN {FS=" "}; {print $1}' temp.txt`
    export a=`awk 'BEGIN {FS=" "}; {print $2}' temp.txt`
    sed -i '' "/^$a/ s/$/,$b/" "./all/sharedbyallbis.txt"
done
sed -i '' 's/$/;/' ./all/sharedbyallbis.txt

cat fm7genetogo.txt  | while read line
do
    echo $line > temp.txt
    export b=`awk 'BEGIN {FS=" "}; {print $1}' temp.txt`
    export a=`awk 'BEGIN {FS=" "}; {print $2}' temp.txt`
    sed -i '' "/^$a/ s/$/,$b/" "./all/sharedbyallbis.txt"
done
sed -i '' 's/$/;/' ./all/sharedbyallbis.txt

cat fm12genetogo.txt  | while read line
do
    echo $line > temp.txt
    export b=`awk 'BEGIN {FS=" "}; {print $1}' temp.txt`
    export a=`awk 'BEGIN {FS=" "}; {print $2}' temp.txt`
    sed -i '' "/^$a/ s/$/,$b/" "./all/sharedbyallbis.txt"
done
sed -i '' 's/$/;/' ./all/sharedbyallbis.txt


sed -i '' 's/;,/;/g' ./all/sharedbyallbis.txt
