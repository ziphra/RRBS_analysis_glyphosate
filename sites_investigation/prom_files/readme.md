The folder is organized as follow: 

- **prom**: a folder containing everything affiliated with differentially methylated sites in promoter regions 
	- **prom3kt.gff3**: contains promoters regions defined in R with GenomicFeatures package as:
`prom3k <- promoters(gff, upstream=3000, downstream=0, columns=c("tx_name", "gene_id"))`  
`prom3kt <- trim(prom3k, use.names=TRUE)`
	- **1_prom3kt.gff3**: negative coordinates replaced with 1 
	- **\*.bed**: meth sites as bed file

	- **intersected**: a flder contaning intersectBed results 
		- **\*_prom\_intersect.txt**: *.bed (meth sites) and 1_prom3kt.gff3 intersection 
		- **\*\_prom_coord.txt**: columns $1 $2 and $3 (chr/start/end) of \*_prom\_intersect.txt
		- **prom_ft.txt**:  \*\_prom_coord.txt and feature table intersection 
		- **GCF\_001577835.2\_Coturnix\_japonica_2.1\_feature\_table.txt**
		- **GCF\_001577835.2\_Coturnix\_japonica_2.1\_feature\_table.bed** feature table converted in .bed 

	