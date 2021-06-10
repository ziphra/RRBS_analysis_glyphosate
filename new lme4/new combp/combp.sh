#!/bin/sh

#  combp.sh
#  
#
#  Created by Euphrasie Servant on 23/03/2021.
#  

for file in *;
do
    sed 's/"//g' ${file} | awk '{sub(/\_/," ",$1)};1' |sed -E -e 's/^.{2}/&_/' | awk '{print $1,$2,$2+1, $3}' OFS="\t" > BED_${file}
    sort -k1,1 -k2,2n BED_${file} > sorted_${file}
    gsed -i '1s/^/chrom\tstart\tend\tp-value\n/' sorted_${file}
    
    mkdir ../results_${file}
    comb-p pipeline -c 4 --seed 0.05 --dist 750 -p ${file} sorted_${file}
done


