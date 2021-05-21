#!/bin/sh

#  Script.sh
#  
#
#  Created by Euphrasie Servant on 04/05/2021.
#  
awk 'BEGIN {OFS="\t";FS="\t"}; {print $1,$2,$3,$10,$12}' /Users/euphrasieservant/Documents/sites7/prom/prom7/intersected/fM_prom_intersect.txt  > fm7_sites.txt


for file in *sites.txt
do
sed -e 's/.*gene_id=\(.*\);.*/\1/' $file > genetoadd

awk 'BEGIN {OFS="\t";FS="\t"};{getline f1 <"genetoadd" ; print $1,$2,$3,$4,f1}' < $file > ${file}_gene
done


for file in *_gene
do
sed 's/_//' $file | awk 'BEGIN {OFS="\t";FS="\t"}; {print $1"_"$2,$4,$5}' > R_${file}
done 





