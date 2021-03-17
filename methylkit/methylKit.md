# methylKit 
methylKit is an R package for analysis and annotation of DNA methylation information obtained by high-throughput bisulfite sequencing. See [user guide](https://bioconductor.org/packages/release/bioc/vignettes/methylKit/inst/doc/methylKit.html#22_Reading_the_methylation_call_files_and_store_them_as_flat_file_database)

### Data preparation 
- First I need to get all the `zero.cov` files in the `meth` directories (the methylation extraction output directory) with ```for folder in `cat allfolders.txt`; do cp ./${folder}/meth_${folder}/*zero.cov cov_files;done```, and store their names and all associated information (batch number, age, control or glyphosate) in a tab file for later use in methylKit. See the script to do so [here](./cov_tab.sh). I get a tab file (sampleID.csv) with `<file>	<cond>	<age>` and added a last column `<batch>` by hands through Numbers.

The coverage output looks like this:
`<chromosome> <start position> <end position> <methylation percentage> <count methylated> <count unmethylated>`

- File names and samples ID must be different
	- I used the function TEXTBETWEEN in Numbers to get rid of the identical left and right parts of each file names, and saved the file as csv for later use in R. Now the csv file is composed of 5 colums `<file>	<cond>	<age>	<name>	<sex>`.
	- To add the sex of each samples in my csv, using Suvi's excel sheet, see python [script](nameToSex).


Followed the same process after having concatenated the 2 differents lanes of each samples in batch 5. 

### See pipeline Rscript.
`/scratch/project_2003821/RGQMA/methylkit/methyl_kit_pipeline.R`


### Workflow summary

1. **Basic**
	1. Read the methylation call (.cov files obtained through bismark methylation extraction) and make a flat db 

	2. Filtering samples based on read coverage: discard base with low coverage, to get rid of PCR mistakes, but also discard bases with very high coverage that could result from PCR bias. 

2. **Comparative analysis**
	1. Merge all samples for futher analysis: a new object is built containing methylation information for regions/bases that are covered in all samples
	
	2. A look at **correlation between samples** 

	
	3. **Clustering samples** 
	![](../img/meth_clustering_plot_12_7.png)
		
	4. **PCA analysis** on samples (see `PCA_screeplot_12_7.pdf`, 
	`PCA_scatter_plot_12_7.pdf`,`PCA_meth_plot.pdf`). PCA is an unsupervised method used to explore the data variance structure by reducing its dimensions to a few principal components (PC) that explain the greatest variation in the data.
	![](../img/PCA_screeplot_12_7.png)
	![](../img/PCA_scatter_plot_12_7.png)

	5. **Batch effect**: check which one of the principal components are statistically associated with a potential batch effects. Can also be used to see if an other variable has an effect on the methylation.

	
	6. **Finding differentially methylated bases or regions**: it will either use Fisher’s exact or logistic regression to calculate P-values.
	
``` 
methylDiffDB object with 192413 rows
--------------
          chr start  end strand       pvalue       qvalue  meth.diff
1 NC_029516.1  2468 2469      * 9.834917e-03 2.571624e-02  1.9994429
2 NC_029516.1  2474 2475      * 9.390694e-04 3.274655e-03  3.2129751
3 NC_029516.1  2477 2478      * 5.251947e-01 4.856084e-01  0.4167421
4 NC_029516.1  2501 2502      * 2.457894e-05 1.174618e-04  4.1993150
5 NC_029516.1  2538 2539      * 6.087399e-11 6.325995e-10  7.8738058
6 NC_029516.1  5715 5716      * 2.645256e-01 3.176008e-01 -0.4487316
--------------
sample.ids: 1_0_B10_S1_L001 10_B9_B10_S10_L001 100_69B_S20_L001 100_69B_S20_L002 11_22B_S11_L001 12_27B_S12_L001 13_34B_S13_L001 14_38B_S14_L001 15_40B_S15_L001 16_64B_S16_L001 17_67B_S17_L001 18_70B_S18_L001 19_71B_S19_L001 2_0_B2_S2_L001 20_8B_S20_L001 21_0_B5_S22_L002 22_0_B6_S23_L002 23_0_G5_S24_L002 24_0_G6_S25_L002 25_0_M6_S26_L002 26_0_R10_S27_L002 27_0_R2_S28_L002 28_0_R3_S29_L002 29_G4_0_S30_L002 3_0_B3_S3_L001 30_G6_0_S31_L002 31_12B_S32_L002 32_21B_S33_L002 33_31B_S34_L002 34_32B_S35_L002 35_39B_S36_L002 36_48B_S37_L002 37_50B_S38_L002 38_54B_S39_L002 39_59B_S40_L002 4_0_B4_S4_L001 40_73B_S41_L002 41_0_B8_S1_L001 42_0_G1_S2_L001 43_0_M3_S3_L001 44_0_M7_S4_L001 45_0_R4_S5_L001 46_0_R6_S6_L001 47_B5_0_S7_L001 48_B9_0_S8_L001 49_G8_0_S9_L001 5_0_G4_S5_L001 50_R1_R2_S10_L001 51_14B_S11_L001 52_18B_S12_L001 53_26B_S13_L001 54_28B_S14_L001 55_29B_S15_L001 56_47B_S16_L001 57_49B_S17_L001 58_52B_S18_L001 59_62B_S19_L001 6_0_M10_S6_L001 60_74B_S20_L001 61_0_G9_S22_L002 62_0_M4_S23_L002 63_0_M8_S24_L002 64_0_M9_S25_L002 65_0_R7_S26_L002 66_0_R8_S27_L002 67_G1_0_S28_L002 68_G2_0_S29_L002 69_G3_G4_S30_L002 7_0_M2_S7_L001 70_R3_R4_S31_L002 71_10B_S32_L002 72_13B_S33_L002 73_24B_S34_L002 74_30B_S35_L002 75_35B_S36_L002 76_61B_S37_L002 77_63B_S38_L002 78_65B_S39_L002 79_68B_S40_L002 8_0_M5_S8_L001 80_72B_S41_L002 81_B1_0_S1_L001 81_B1_0_S1_L002 82_B2_0_S2_L001 82_B2_0_S2_L002 83_B3_0_S3_L001 83_B3_0_S3_L002 84_B6_0_S4_L001 84_B6_0_S4_L002 85_B7_B8_S5_L001 85_B7_B8_S5_L002 86_G1_G2_S6_L001 86_G1_G2_S6_L002 87_G9_G10_S7_L001 87_G9_G10_S7_L002 88_M1_M2_S8_L001 88_M1_M2_S8_L002 89_M9_M10_S9_L001 89_M9_M10_S9_L002 9_B8_0_S9_L001 90_R9_R10_S10_L001 90_R9_R10_S10_L002 91_33B_S11_L001 91_33B_S11_L002 92_37B_S12_L001 92_37B_S12_L002 93_3B_S13_L001 93_3B_S13_L002 94_41B_S14_L001 94_41B_S14_L002 95_45B_S15_L001 95_45B_S15_L002 96_4B_S16_L001 96_4B_S16_L002 97_51B_S17_L001 97_51B_S17_L002 98_58B_S18_L001 98_58B_S18_L002 99_5B_S19_L001 99_5B_S19_L002 
destranded FALSE 
assembly: Coturnix_japonica_2.1 
context: CpG 
treament: 1 1 0 0 0 0 0 0 0 0 0 0 0 1 0 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 1 0 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 1 0 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 1 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
resolution: base 
dbtype: tabix 
```

```
$diffMeth.per.chr
              chr number.of.hypermethylated percentage.of.hypermethylated number.of.hypomethylated percentage.of.hypomethylated
1     NC_029516.1                        32                   0.164642931                        0                   0.00000000
2     NC_029517.1                         1                   0.006248047                        3                   0.01874414
3     NC_029519.1                         1                   0.007017544                        0                   0.00000000
4     NC_029522.1                         4                   0.051499936                        5                   0.06437492
5     NC_029523.1                         2                   0.026571011                        0                   0.00000000
6     NC_029525.1                         4                   0.056617127                        0                   0.00000000
7     NC_029527.1                         0                   0.000000000                        5                   0.08539710
8     NC_029528.1                        14                   0.256175663                        0                   0.00000000
9     NC_029529.1                         4                   0.075301205                        5                   0.09412651
10    NC_029530.1                         1                   0.021404110                        0                   0.00000000
11    NC_029533.1                         0                   0.000000000                        2                   0.05317735
12    NC_029534.1                         0                   0.000000000                        7                   0.15015015
13    NC_029537.1                         0                   0.000000000                        2                   0.12861736
14    NC_029542.1                         3                   0.067415730                        0                   0.00000000
15 NW_015440339.1                         1                  14.285714286                        0                   0.00000000

$diffMeth.all
  number.of.hypermethylated percentage.of.hypermethylated number.of.hypomethylated percentage.of.hypomethylated
1                        67                    0.03482093                       29                   0.01507175
```
	
3. **Annotating differentially methylated regions/bases based on gene annotation:** the gene annotations can be read from a bed12 file. A GFF3 can be convert to a bed12 with the two scripts gtfToGenePred and genePredToBed from <http://hgdownload.cse.ucsc.edu/admin/exe/linux.x86_64/>. See [notes](<https://hgdownload.soe.ucsc.edu/downloads.html>) about 'permission denied' error


``` 
Summary of target set annotation with genic parts
Rows in target set: 358
-----------------------
percentage of target features overlapping with annotation:
  promoter       exon     intron intergenic 
     40.50      40.50      48.88      12.57 

percentage of target features overlapping with annotation:
(with promoter > exon > intron precedence):
  promoter       exon     intron intergenic 
     40.50      19.27      27.65      12.57 

percentage of annotation boundaries with feature overlap:
promoter     exon   intron 
    0.13     0.01     0.03 

summary of distances to the nearest TSS:
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    0.0   480.2  1225.5  5475.2  3526.5 84672.0 
```

```
  CpGi shores  other 
 83.80  10.61   5.59 
  CpGi shores 
  0.58   0.06 
```

![](../img/annot_gen_plot.png) 
![](../img/annot_islands_plot.png)



See [GenePredToBed](https://genome.ucsc.edu/goldenPath/help/hubQuickStartSearch.html) to convert the .cov to bed