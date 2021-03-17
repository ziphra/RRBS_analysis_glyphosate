# DSS
see [userguide](https://bioconductor.org/packages/release/bioc/vignettes/DSS/inst/doc/DSS.html#1_Introduction) 

The DSS program is based on a beta-binomial distribution, whereas meatlKit is based on contingency table tests which ignores individual sequencing depth and between-subject variability. 
DSS can thus models overdispersion and keeps coverage information. It also allows to incorporates covariates. But, it is really computationally intensive.

See /scratch/project_2003821/RGQMA/DSS/7_F/DSS_7F.R for script. 

## input data preparation 
DSS requires data from each BS-seq experiment to be summarized into following information for each CG position: chromosome number, genomic coordinate, total number of reads, and number of reads showing methylation:
`for file in ./*.cov; do awk -v OFS='\t' '{print $1, $2, $5+$6, $5}' $file > /scratch/project_2003821/RGQMA/DSS/DSS_cov/${file}_DSS;done`


## DML/DMR detection from two-group comparison
as in methylkit. 

Because the analysis was very time consuming, I filtered the data with individuals age=7 and sex=F, and compare K and G and more than 10 hours needed for the analysis, on 4 cores. 



```
[1] "BSseq object:"
An object of type 'BSseq' with
  4421820 methylation loci
  26 samples
has not been smoothed
All assays are in-memory

[1] "Mean coverage:"
100_69B_S20_L001 100_69B_S20_L002  12_27B_S12_L001  14_38B_S14_L001 
            15.2             15.3             22.1             26.0 
 18_70B_S18_L001  19_71B_S19_L001  33_31B_S34_L002  34_32B_S35_L002 
            28.6             61.8             19.2             23.2 
 35_39B_S36_L002  39_59B_S40_L002  53_26B_S13_L001  54_28B_S14_L001 
            21.4             24.1             22.1             26.7 
 55_29B_S15_L001  59_62B_S19_L001  74_30B_S35_L002  76_61B_S37_L002 
            20.8             23.0             25.0             19.2 
 79_68B_S40_L002  80_72B_S41_L002  91_33B_S11_L001  91_33B_S11_L002 
            20.6             17.7             11.2             11.3 
 92_37B_S12_L001  92_37B_S12_L002  95_45B_S15_L001  95_45B_S15_L002 
            13.9             14.0             14.0             14.1 
 98_58B_S18_L001  98_58B_S18_L002 
            14.5             14.6 
            
[1] "Mean coverage of methylated:"
100_69B_S20_L001 100_69B_S20_L002  12_27B_S12_L001  14_38B_S14_L001 
             5.3              5.3              8.0              9.3 
 18_70B_S18_L001  19_71B_S19_L001  33_31B_S34_L002  34_32B_S35_L002 
            10.5             20.1              6.4              8.2 
 35_39B_S36_L002  39_59B_S40_L002  53_26B_S13_L001  54_28B_S14_L001 
             8.0              8.9              7.5              9.7 
 55_29B_S15_L001  59_62B_S19_L001  74_30B_S35_L002  76_61B_S37_L002 
             7.6              8.0              7.8              7.3 
 79_68B_S40_L002  80_72B_S41_L002  91_33B_S11_L001  91_33B_S11_L002 
             7.6              6.6              4.5              4.5 
 92_37B_S12_L001  92_37B_S12_L002  95_45B_S15_L001  95_45B_S15_L002 
             4.9              5.0              4.8              4.9 
 98_58B_S18_L001  98_58B_S18_L002 
             5.2              5.3 
[1] "Number of CpG sites in the data:"
[1] 4421820
[1] "Number of CpG sites in the data with 0 coverage:"
[1] 0
[1] "Number of methylated CpGs with 0 coverage:"
[1] 1475538
```

## dmltest result
```
         	        chr 	      pos 	      mu1 	       mu2 	      diff 	    diff.se 	     stat 	      phi1 	      phi2	         pva	l         	  fdr post	prob.overTh	reshold
12350	NC_029516.1 	2855638	0.4943168	0.85335380	-0.3590370	0.022364969	-16.05354	0.03182320	0.03013122	5.399163E-05	8  8.24861	5E-54	           	1
19500	NC_029516.1 	10695262	0.5611784	0.86140894	-0.3002306	0.020763875	-14.45928	0.03182320	0.03013122	2.190921E-04	7  2.09908	9E-43	           	1
104477	NC_029516.1 	47162184	0.6895975	0.36287202	0.3267255	0.017842901	18.31123	0.03182320	0.03013122	6.733182E-07	5  1.64290	8E-70	           	1
151431	NC_029516.1 	67292245	0.5401867	0.35895007	0.1812366	0.008756448	20.69750	0.03182320	0.03013122	3.648091E-09	5  1.49071	7E-90	           	1
220345	NC_029516.1 	101355350	0.7275636	0.40698278	0.3205808	0.024462144	13.10518	0.03201367	0.03013122	3.075265E-03	9  2.09861	9E-35	           	1
223304	NC_029516.1 	103724451	0.5339234	0.18281734	0.3511060	0.027128973	12.94211	0.03182320	0.03013122	2.603934E-03	8  1.73849	7E-34	           	1
231608	NC_029516.1 	108114722	0.6556470	0.82367015	-0.1680231	0.005793057	-29.00422	0.03182320	0.03013122	5.820394E-18	5 1.233786	e-179     	           	1
238247	NC_029516.1 	111979605	0.6341602	0.90315764	-0.2689974	0.018427603	-14.59753	0.03182320	0.03013122	2.912205E-04	8  2.90503	0E+00	           	1
252762	NC_029516.1 	120789940	0.4604553	0.05787356	0.4025817	0.024609602	16.35873	0.03182320	0.03013122	3.769346E-06	0  6.23619	5E-56	           	1  
```

`showOneDMR(dmrs2[1,], BSobj)` plots the methylation percentages as well as the coverage depths at each CpG sites. 
This below, is one differential methylation region. 

![](../img/dmrs2_2.png) 



![](../img/manhattan_dmlt.png)

