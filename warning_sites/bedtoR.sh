#!/bin/sh

#  bedtoR.sh
#  
#
#  Created by Euphrasie Servant on 13/05/2021.
#  

for file in *bed;
do
    sed -i '' 's/_//' $file
    cut -f1,2 $file > temp
    cat temp > $file
    rm temp
    tr "\t" "_" < $file > temp
    cat temp > $file
done
