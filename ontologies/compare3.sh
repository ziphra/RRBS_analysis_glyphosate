#!/bin/sh

#  compare3.sh
#
#
#  Created by Euphrasie Servant on 29/04/2021.
#




compare_gos.py ./7/ff7.txt ./7/fm7.txt ./12/ff12.txt ./12/fm12.txt > ./all/compare_all.txt
grep "XXXX" ./all/compare_all.txt | sed 's/XXXX //' > ./all/sharedbyall.txt
tr -s " " < ./all/sharedbyall.txt > ./all/sharedbyallbis.txt
sed -i '' 's/,/./' ./all/sharedbyallbis.txt
sed -i '' 's/ /;/' ./all/sharedbyallbis.txt
sed -i '' 's/ /;/' ./all/sharedbyallbis.txt
sed -i '' 's/ /;/' ./all/sharedbyallbis.txt
sed -i '' 's/ /;/' ./all/sharedbyallbis.txt


cat ./7/ff7.txt | while read line
do
    echo $line > temp.txt
    export b=`awk 'BEGIN {FS=" "}; {print $1}' temp.txt`
    export a=`awk 'BEGIN {FS=" "}; {print $2}' temp.txt`
    sed -i '' "/^$a/ s/$/,$b/" "./all/sharedbyallbis.txt"
done
sed -i '' 's/,/;/' ./all/sharedbyallbis.txt
sed -i '' 's/$/;/' ./all/sharedbyallbis.txt

cat ./12/ff12.txt  | while read line
do
    echo $line > temp.txt
    export b=`awk 'BEGIN {FS=" "}; {print $1}' temp.txt`
    export a=`awk 'BEGIN {FS=" "}; {print $2}' temp.txt`
    sed -i '' "/^$a/ s/$/,$b/" "./all/sharedbyallbis.txt"
done
sed -i '' 's/$/;/' ./all/sharedbyallbis.txt

cat ./7/fm7.txt  | while read line
do
    echo $line > temp.txt
    export b=`awk 'BEGIN {FS=" "}; {print $1}' temp.txt`
    export a=`awk 'BEGIN {FS=" "}; {print $2}' temp.txt`
    sed -i '' "/^$a/ s/$/,$b/" "./all/sharedbyallbis.txt"
done
sed -i '' 's/$/;/' ./all/sharedbyallbis.txt

cat ./12/fm12.txt  | while read line
do
    echo $line > temp.txt
    export b=`awk 'BEGIN {FS=" "}; {print $1}' temp.txt`
    export a=`awk 'BEGIN {FS=" "}; {print $2}' temp.txt`
    sed -i '' "/^$a/ s/$/,$b/" "./all/sharedbyallbis.txt"
done
sed -i '' 's/$/;/' ./all/sharedbyallbis.txt


sed -i '' 's/;,/;/g' ./all/sharedbyallbis.txt
