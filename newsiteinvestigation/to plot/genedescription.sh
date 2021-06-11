#!/bin/sh

#  genedescription.sh
#  match gene description to gene
#
#  Created by Euphrasie Servant on 19/05/2021.
#  

for file in R*
do
cat genetodescription.txt  | while read line
do
    echo $line > temp.txt
    export a=`awk 'BEGIN {FS=" "}; {print $1}' temp.txt`
    export b=`awk 'BEGIN {FS=" "}; {print $2}' temp.txt`
    sed -i '' "s/[[:<:]]$a[[:>:]]/$line/" "$file"
done
done
