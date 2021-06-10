#!/bin/sh

#  Script.sh
#  
#
#  Created by Euphrasie Servant on 18/03/2021.
#




for file in *bed;
do
    sort -k1,1 -k2,2n ${file} | intersectBed -a - -b 1_prom3kt.gff3 -wb -sorted > ${file}_prom_intersect.txt # sort the chr and pos so intersectBed can call a faster algorithm with -sorted.




for file in *bed; do intersectBed -a $file -b 1_prom3kt.gff3 -wb > ${file}_prom_intersect.txt; awk '{ print $1,$2,$3 }' OFS='\t' ${file}_prom_intersect.txt > ${file}_prom_coord.bed;done

intersectBed -a fM_prom_coord.bed -b GCF_001577835.2_Coturnix_japonica_2.1_feature_table.bed -wb > fM_prom_ft.txt


for file in *txt;do sed -e 's/.*gene_id=\(.*\);ID.*/\1/' $file | sort -u | tr "\n" " " > geneid_${file};done
