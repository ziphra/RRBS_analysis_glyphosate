# locate sites 

## promoters regions 
see [GenomicFeatures R package](https://bioconductor.org/packages/release/bioc/html/GenomicFeatures.html)

To define promoters region, see script.    
Then:

- Correct the sites list bed file
	- i.e remove the " " from the chr names: 
```
for file in `ls`; do sed -i '' 's/"//g' $file; done
```
	- replace sequence_feature with the sequence feature: promoter
```
sed -i '' 's/sequence_feature/promoter/g' prom3kt.gff3
```

	- remove out of bond negative coordinates with 0. 
```
awk '{$4=($4<0)?0:$4}1' OFS='\t' prom3kt.gff3 > 0_prom3kt.gff3
```
	- WARNING: GFF3 files are by definition 1-based! It was not a big deal before intersecting sitestokeep.bed and 1_prom3kt.gff3 because there were no sites matched with promoters with a 0 as a start. 
	 
	- remove the header
```
grep -v '^##' 1_prom3kt.gff3 > tmp_file
mv tmp_file 1_prom3kt.gff3
```
	- retrieve coordinates for CpGs in prom 
```
awk '{ print $1,$2,$3 }' OFS='\t' ./sites/intersected/fF_prom_intersect.txt > ./sites/intersected/fF_prom_coord.bed
```
	- remove extra tab space at the end of lines in the feature table, in order to intersect with  `*_prom_coord.bed`
```
sed -i '' 's/[[:space:]]*$//' GCF_001577835.2_Coturnix_japonica_2.1_feature_table.txt
```
- transform the feature table as a bed file
	- replace the the empty fields (\t x 2) with something: write literally tab space by doing ctrl+V+tab, sed don't understand `\t` and for unknown reason `[[:space:]]` as replacement pattern. 
```
sed -i '' 's/[[:space:]][[:space:]]/        NA     /g' GCF_001577835.2_Coturnix_japonica_2.1_feature_table.txt
```
	- re organized the columns, so the feature table can be bed like. 
```
awk '{ print $7,$8,$9,$10,$1,$2,$3,$4,$5,$6,$11,$12,$13,$14,$15,$16,$17,$18,$19}' FS='\t' OFS='\t' >
```
	- replace the column $1 "genomic accession" with "chrom"

- intersect
```
intersectBed -a fM_prom_coord.bed -b GCF_001577835.2_Coturnix_japonica_2.1_feature_table.bed -wb > fM_prom_ft.txt
```

## GO enrichment analysis 

Retrieves all the genes ID of CpGs in promoter in all sites tested for differential methylation (i.e the 22k sites), the same way we did above.
	
### BiNGO
For installation, see

Seems like the custom annotations file must contain `gene_association` and the ontology file must be `.obo`

#### reference set 
*No need for a ref set, just select* `use the whole annotation as reference`.

Use the sites from `sitestokeep.list` as the reference set: the functional enrichment of the differentially methylated sites will be made against the functional annotations of these sites. Custom reference set files simply contain all gene identifiers you want to include in the reference set, separated by newlines.    
  
- In R:
```write.table(sitestokeep.list, file = "sitestokeep.txt", sep = "\n",row.names = FALSE, col.names = FALSE)```  

- Transforme the list as bed file, like did previously:   
	- `sed -i '' 's/"//g' sitestokeep.txt`
	- `sed 's/"//g' sitestokeep.txt | awk '{sub(/\_/," ",$1)};1' |sed -E -e 's/^.{2}/&_/' | awk '{print $1,$2,$2+1}' OFS="\t" | sort -k1,1 -k2,2n > sitestokeep.bed` 

	- intersect - see warning above. Change back all "1" to "0" 
```
-a sitestokeep.bed -b ./prom/1_prom3kt.gff3 -wb > stk_prom_intersect.txt
``` 
	- retrieve coordinates for sitestokeep CpGs in prom 
```
awk '{ print $1,$2,$3 }' OFS='\t' stk_prom_intersect.txt > stk_prom_coord.bed 
```
	- Retrieves all the genes ID:    
	`sed -e 's/.*gene_id=\(.*\);ID.*/\1/' stk_prom_intersect.txt | sort -u | tr "\n" " " > stk_prom_intersect.txt ` 



#### Custom annotation
Make the GO enrichment analysis against all the sites tested for differential methylation (22k sites)

This feature is particularly useful if you want to :

- **use gene identifiers other than those provided in BiNGO** 
- **use an annotation for an organism which is not included in BiNGO**
- test your set of genes against a custom reference set
- use ontologies other than those provided, e.g. KEGG.

```
(species=Coturnix japonica)(type=Biological Process)(curator=GO)
AAAS = 0000922
AAAS = 0001578
AAAS = 0005515
AAAS = 0005635
AAAS = 0005643
AAAS = 0005654
```

To make the custom annotations files,

- get the GO annotation of the gene_id we get with [g:Profiler converter](https://biit.cs.ut.ee/gprofiler/convert) and download the csv file.     
- In numbers, keep the 2 columns of interest (gene id and GO id), add "=" between them, with `TEXTAFTER` delete `GO:` before each identifiers, and save as .tsv and then change the extension to .txt (to preserve leading 0!).
- manually delete the `GO:` remaining alone, used for `TEXTAFTER`
- `awk '{ print $1,$2,$4 }' FS="\t" refset.tsv > BINGO_annotations.txt` (will save the file as a space separated file)
- `sed -i '' '/= \n/d' BINGO_annotations.txt` to delete gene with no GO annotations
- manually add the header `(species=Coturnix japonica)(type=Biological Process)(curator=GO)`


## Gene Ontology 
see [article](doi: 10.1111/mec.12309)
### g:Profiler

GO provides a largely species-neutral source of information on the molecular function, biological role and cellular location of tens of thousands of gene products.

#### custom .GMT 
Make the GO enrichment analysis against all the sites tested for differential methylation (22k sites) that are in promoters. 

- To use a custom GMT, see **reference set** in BiNGO above. Keep the columns gene id and GO id from the csv from g:Convert in `goids_annotations.txt`. WARNING: the gene `PES1` is replace with `"PES 1"`: manually modify it. 
- Then: `sort -k2,2 goids_annotations.txt  | awk '{if($2!=prev) {printf("%s%s\t\t%s",(NR==1?"":"\n"),$2,$1);prev=$2;next;} else printf(" %s",$1);} END{printf("\n");}'`
- `cat annotations1.GMT | tr " " "\t" > annotations.GMT` will replace the space between genes with \t 

Can also test sites of interest against all CpGs with 10x coverage (440k sites). Retreive gene ID and GO annotations just like it has been done above. 

### g:Profiler, second try 
- Make a second costum file WITH the terms names
```
sort -k2,2 gProfiler_cjaponica.txt| awk '{if($2!=prev) {printf("%s%s\t"$4"\t%s",(NR==1?"":"\n"),$2,$1);prev=$2;next;} else printf("\t%s",$1);} END{printf("\n");}' FS="\t" > goidsannotations_terms.txt      
```
-
