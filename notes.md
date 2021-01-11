# Notes 

## CpG sites
A stran of DNA where a C is followed by a G in the 5' -> 3' direction (5'—C—phosphate—G—3' ). CpG sites occurs with high frequency in genomic regions called CpG islands. 
C can be methylated by a DNA methyltransferase. In mammal, 70 to 80% of them are methylated. These methylation can change a gene's expression.  
CpG sites occurs less than supposed to. It is because it has a high mutation rate.The spontaneous deamination of a methylated C results in a T and the mismatch resulting G=T is often resolved as A=T. => CpG deficiency due to methylated cytosine mutagenic properties. 

**CpG islands**  
They are regions with high frequency of CpG. 
Should be at least 200pb, with a GC content of at least 50% and an observed to expected CpG greater than 60%. 

CpG islands are characterized by CpG dinucleotide content of at least 60% of that which would be statistically expected (~4–6%), whereas the rest of the genome has much lower CpG frequency (~1%).

CpG islands occuring in promoters are usually not methylated if the gene is expressed, unlike in the coding regions. The presence of multiple methylated CpG sites in CpG islands of promoters causes stable silencing of genes. Methylation in promoter regions is often found to be negatively correlated with gene expression, becoming less accessible for transcription factors or RNA-polymerases

CpG islands typically occur at or near the TSS of genes.

## Bisulfite sequencing
### Whole genome bisulfite sequencing WRBS
*For highest genomic coverage*  
Whole genome bisulfite sequencing (WGBS), is a next-generation sequencing technology used to determine the DNA methylation status of single cytosines by treating the DNA with sodium bisulfite before sequencing. Sodium bisulfite is a chemical compound that converts unmethylated cytosines into uracil. The C that haven't converted in U are methylated. After sequencing, the unmethylated C appear as T.

### RRBS and mRRBS
*For higher accuracy*  
[DNA methylation analysis by multiplexed reduced representation bisulfite sequencing](https://www.youtube.com/watch?v=eXrIfzS0BRA&feature=emb_logo)  

- Restriction enzyme: msp1 cut DNA at C^CGG
- Repairing of the end
- A tailing: an additional A nucleotide is added to each 3' end fragment
- Addition of adapters for NGS with the complementaring T (+ barcode for multiplexing)
- Conversion of *unmethylated cytosine* into U. Methylated C are unaffected
- PCR (U to T ??)

With ~5% of the genome, we get ~80% of CpG islands information (in the human genome).


