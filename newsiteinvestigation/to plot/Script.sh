#!/bin/sh

#  Script.sh
#  
#
#  Created by Euphrasie Servant on 04/05/2021.
#  
awk 'BEGIN {OFS="\t";FS="\t"}; {print $1,$2,$3,$10,$12}' ../intersected/pv_fullF710sig.bed_prom_intersect.txt  > f710_sites.txt


for file in *sites.txt
do
sed -e 's/.*gene_id=\(.*\);.*/\1/' $file > genetoadd

awk 'BEGIN {OFS="\t";FS="\t"};{getline f1 <"genetoadd" ; print $1,$2,$3,$4,f1}' < $file > ${file}_gene
done


for file in *_gene
do
sed 's/_//' $file | awk 'BEGIN {OFS="\t";FS="\t"}; {print $1"_"$2,$4,$5}' > R_${file}
done 



for file in *bed
do
sed 's/_//' $file | awk 'BEGIN {OFS="\t";FS="\t"}; {print $1"_"$2}' > R_${file}
done

