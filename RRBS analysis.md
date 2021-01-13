# RRBS analysis
see [Bismark user guide](https://rawgit.com/FelixKrueger/Bismark/master/Docs/Bismark_User_Guide.html#appendix-iii-bismark-methylation-extracto)

Import all the recquired dependencies (samtools, bamstool, cutadapt, fastqc... will be store in the PATH):  
`module load biokit`

set the PATH variables:  
`export PATH=$PATH:/scratch/project_2003846/test_bismark/Bismark-0.22.3/`  
`export PATH=$PATH:/scratch/project_2003846/test_bismark/Bismark-0.22.3/ `   
dont start the path by `users/servante`!


## trimming 
Trimming of raw reads is done to remove low quality segments from reads prior to analysis and the 2 extra bases due to RRBS and the illumina adapters.

`for fastq in data/*.fastq trim_galore --rrbs --illumina -o ./trimmed_data --fastqc `

- `rrbs`: identifies adapters, removes another 2 bp from the 3' end of Read 1, and for paired-end libraries also the first 2 bp of Read 2 (o avoid that the filled-in cytosine position close to the second MspI site in a sequence is used for methylation calls). Sequences trimmed because of poor quality will not be shortened any further.
- `illumina`: trim the first 13bp of the illumina universal adapter.
- `fastqc`: check the quality on the trimmed sequences 

Use the trimmed data for the further steps 

## quality control
Quality control is done again using FastQC. It identifies biases in base composition, read duplication, base quality, read length etc. and. It provides an htlm document in which to inspect the output.

`fastqc for fastq in trimmed_data/*. -o quality_control`

The output director need to be created prior the fastqc! `mkdir quality_control`


## Bismark
C->T conversion is also done for the reference genome prior to alignment. 

### genome prep
C->T and G->A transformations on the reference genome   
`bismark_genome_preparation ./path-to/reference-genome/`

### genome alignment
bismark aligns the reads for both transformed and untransformed reference genomes which were created in the genome preparation step
`bismark -q --un --ambiguous -o ./Bismark_output data/refgen/ trimmed/test_data_trimmed.fq/`

- `q`: when the input are fastq or fq files
- `--un`: Write all reads that could not be aligned to the file _unmapped_reads.fq.gz in the output directory.
- `-- ambiguous`: Write all reads which produce more than one valid alignment with the same number of lowest mismatches or other reads that fail to align uniquely to _ambiguous_reads.fq


# Extract methylated sites 
Extracts the methylation call for every single C analysed. The position of every single C will be written out to a new output file, depending on its context (CpG, CHG or CHH), whereby methylated Cs will be labelled as forward reads (+), non-methylated Cs as reverse reads (-)
```
bismark_methylation_extractor 
				-s 
				--bedGraph 
				--counts 
				--cytosine_report 
				--zero_based 
				--genome_folder ./path-to/reference-genome/
				--output ./path-to/output-directory/
				./path-to/input.bam
```

- `s`: single-end read data
- `--bedGraph`: After finishing the methylation extraction, the methylation output is written into a sorted bedGraph file that reports the position of a given cytosine and its methylation state. By default, only cytosines in CpG context are sorted.
- `--cytosine_report`: produces a genome-wide methylation report for all cytosines in the genome.
- `--zero_based `: Uses 0-based genomic coordinates instead of 1-based coordinates. Default: OFF.


