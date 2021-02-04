# Bismark 
 

## functions 
see [Bismark user guide](https://rawgit.com/FelixKrueger/Bismark/master/Docs/Bismark_User_Guide.html#appendix-iii-bismark-methylation-extracto) 

Import all the recquired dependencies (samtools, bamstool, cutadapt, fastqc... will be store in the PATH):  
`module load biokit`

set the PATH variables:  
`export PATH=$PATH:/scratch/project_2003846/test_bismark/Bismark-0.22.3/`  
`export PATH=$PATH:/scratch/project_2003846/test_bismark/Bismark-0.22.3/ `   
dont start the path by `users/servante`!

### quality control - fastQC
Quality control is done using FastQC, before the trimming to check the raw data. It identifies biases in base composition, read duplication, base quality, read length etc. and. 

`fastqc -o ./data/output_quality_raw/ ./data/test_data.fastq`

The output directory need to be created prior the fastqc! `mkdir quality_control_raw` 

It provides an htlm document in which to inspect the output, which contains: 

- **Basic stats**
- **Per base sequence quality**: ften, the quality of - especially very long - reads deteriorates towards later cycles.
- **Quality per tile**: Encoded in these is the flowcell tile from which each read came. The graph allows you to look at the quality scores from each tile across all of your bases to see if there was a loss in quality associated with only one part of the flowcell.
- **Per sequence quality scores**
- **Base composition plots**: allows to detect if the bisulfite conversion has worked. Typical BS- Seq experiments in mammals tend to have an average cytosine content of ~1-2% throughout the entire sequence length.
- **GC content**: adapter contamination can shift the GC profile to 40-60%, when it usually ranges between 20~30% in mammals, but this can usually be fixed by adapter trimming the sequence file.
- **Duplication levels and over-represented sequences**: [How PCR duplicates arise in next-generation sequencing](https://www.cureffi.org/2012/12/11/how-pcr-duplicates-arise-in-next-generation-sequencing/)


### trimming - TrimGalore
Trimming of raw reads is done to remove low quality segments (Phred score of 20 or lower) from reads prior to analysis and the 2 extra bases due to RRBS and the illumina adapters.

`for fastq in data/*.fastq trim_galore --rrbs --illumina -o ./trimmed_data --fastqc `

- `rrbs`: identifies adapters, removes another 2 bp from the 3' end of Read 1, and for paired-end libraries also the first 2 bp of Read 2 (o avoid that the filled-in cytosine position close to the second MspI site in a sequence is used for methylation calls). Sequences trimmed because of poor quality will not be shortened any further.
- `illumina`: trim the first 13bp of the illumina universal adapter.
- `fastqc`: check the quality on the trimmed sequences just as previously with the raw data

Use the trimmed data for the further steps. 


### Bismark

#### genome prep
The genome of interest needs to be bisulfite converted in-silico and indexed.
C->T and G->A transformations on the reference genome:   
`bismark_genome_preparation ./path-to/reference-genome/`  
The bisulfite genome index needs to be generated only once and can be used for all subsequent bisulfite alignments with Bismark.


#### genome alignment
bismark aligns the reads for both transformed and untransformed reference genomes which were created in the genome preparation step
`bismark -q --un --ambiguous -o ./Bismark_output data/refgen/ trimmed/test_data_trimmed.fq/`

- `q`: when the input are fastq or fq files
- `--un`: Write all reads that could not be aligned to the file _unmapped_reads.fq.gz in the output directory.
- `-- ambiguous`: Write all reads which produce more than one valid alignment with the same number of lowest mismatches or other reads that fail to align uniquely to _ambiguous_reads.fq

This will produce 2 files: 1 report, and 1 `test_dataset_bismark_bt2.bam`

#### Extract methylated sites 
Extracts the methylation call for every single C analysed. The position of every single C will be written out to a new output file, depending on its context (CpG, CHG or CHH), whereby methylated Cs will be labelled as forward reads (+), non-methylated Cs as reverse reads (-)

```unix
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





-----------------------------------






## Test on Suvi's data 

### RRBS analysis loop 
- `data` = a folder containing rrbs fastq files such as: "200022\_81\_B1_0\_S1\_L002\_R1\_001.fastq" 
- `ls data > samples_raw` will put all the files name contained in data in a .txt file `samples_raw`.
- `sed 's/......$//' samples_raw > samples` will delete the 6 last caracters of each line (".fastq"), and redirect the output into a txt file `samples`.
- loop syntax:
 
see script.

```bash
for sample in `cat sample.txt`
do 
	[commands]
done
```
#### Get files ready  

- copied the ctrl files to `eu_test/data`: `cp {200022_FFGC_ctrl_p1_S21_L001_R1_001,200022_FFGC_ctrl_p2_S42_L002_R1_001,200022_FFGC_ctrl_p3_S21_L001_R1_001,200022_FFGC_ctrl_p4_S42_L002_R1_001,200022_FFGC_ctrl_p5_S21_L001_R1_001,200022_FFGC_ctrl_p5_S21_L002_R1_001}.fastq.gz eu_test/data`
- unzip all .gz files in folder: `gzip -d *.gz`
- drag and drop the shell script to filezilla
- download japanese quail ref genome with `wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/001/577/835/GCF_001577835.2_Coturnix_japonica_2.1/GCF_001577835.2_Coturnix_japonica_2.1_genomic.fna.gz`
- unzip with `gzip -d` 
- Change .fna to .fa

Re run the `genome_preparation` for others analysis is not necesseray once it has been done: `cp -r refgen path/to/newdir`


#### Memory and time allocated for 2 samples

`seff` for 2 samples, with no `genome_preparation`: 4.30 GB used. Ran for 04:09 hours. The 2 samples size were 5,5Gb + 5,5Gb = 11Gb. 

```
[servante@puhti-login2 ~]$ seff 4596077
perl: warning: Setting locale failed.
perl: warning: Please check that your locale settings:
	LANGUAGE = (unset),
	LC_ALL = (unset),
	LC_CTYPE = "UTF-8",
	LANG = "en_US.UTF-8"
    are supported and installed on your system.
perl: warning: Falling back to the standard locale ("C").
Job ID: 4596077
Cluster: puhti
User/Group: servante/servante
State: FAILED (exit code 29)
Nodes: 1
Cores per node: 5
CPU Utilized: 07:38:43
CPU Efficiency: 44.88% of 17:02:10 core-walltime
Job Wall-clock time: 03:24:26
Memory Utilized: 3.09 GB
Memory Efficiency: 12.35% of 25.00 GB
Job consumed 25.55 CSC billing units based on following used resources
Billed project: project_2003821
CPU BU: 17.04
Mem BU: 8.52
```
```
[servante@puhti-login1 ~]$ seff 4599256
perl: warning: Setting locale failed.
perl: warning: Please check that your locale settings:
	LANGUAGE = (unset),
	LC_ALL = (unset),
	LC_CTYPE = "UTF-8",
	LANG = "en_US.UTF-8"
    are supported and installed on your system.
perl: warning: Falling back to the standard locale ("C").
Job ID: 4599256
Cluster: puhti
User/Group: servante/servante
State: COMPLETED (exit code 0)
Nodes: 1
Cores per node: 5
CPU Utilized: 01:18:10
CPU Efficiency: 35.10% of 03:42:40 core-walltime
Job Wall-clock time: 00:44:32
Memory Utilized: 1.19 GB
Memory Efficiency: 5.95% of 20.00 GB
Job consumed 5.20 CSC billing units based on following used resources
Billed project: project_2003821
CPU BU: 3.71
Mem BU: 1.48 
```




#### Do the analysis on the subset data without specifying the samples we are working on

- Each subset directory follow the same organisation: 

```
- 1_12_G
	- data_1_12_G
- 1_7_G
	- data_1_7_G
- ...
- refgen

```
- This script allows to store the last component of the working directory path into the variable `x`. See [full script](./RRBS_analysis_RGQMA1.sh).

```
export a=`pwd`
export b=`basename $a`
export x=_$b
```

- `${x}` will then give back the last working directory path component: `echo data_${x}` print `data_1_12_G` when in the `1_12_G` directory. 

- Before running the script on all of the subsets, unzip all by `find . -name "*fastq.gz" -exec gzip -d {} \;`

- the `foldertorun.sh` script allows to run a sbatch job in all of the folders contained in `foldertorun.txt`, so all of the batches can be sent runnning all at once, without worrying about the working directory. 

#### Time used to run bismark on the data 
I used 3GB per core, but 1 is largely sufficient.

```
  JobID  Partition      NCPUS   NTasks      State     ReqMem  SystemCPU     MaxRSS    Elapsed 
------------ ---------- ---------- -------- ---------- ---------- ---------- ---------- ---------- 
4648497           small          5           COMPLETED        3Gc   02:46:17              16:03:28 
4648497.bat+                     5        1  COMPLETED        3Gc   02:46:17   3237914K   16:03:28 
4648497.ext+                     5        1  COMPLETED        3Gc   00:00:00       113K   16:03:28 
4648498           small          5           COMPLETED        3Gc   03:41:10              21:13:55 
4648498.bat+                     5        1  COMPLETED        3Gc   03:41:10   3237783K   21:13:55 
4648498.ext+                     5        1  COMPLETED        3Gc   00:00:00       120K   21:13:55 
4648499           small          5           COMPLETED        3Gc   04:33:41            1-00:37:09 
4648499.bat+                     5        1  COMPLETED        3Gc   04:33:41   3237750K 1-00:37:09 
4648499.ext+                     5        1  COMPLETED        3Gc   00:00:00       107K 1-00:37:09 
4648500           small          5           COMPLETED        3Gc   03:50:16              21:52:16 
4648500.bat+                     5        1  COMPLETED        3Gc   03:50:16   3238091K   21:52:16 
4648500.ext+                     5        1  COMPLETED        3Gc   00:00:00       116K   21:52:16 
4648501           small          5           COMPLETED        3Gc   03:39:59              19:48:08 
4648501.bat+                     5        1  COMPLETED        3Gc   03:39:59   3237750K   19:48:08 
4648501.ext+                     5        1  COMPLETED        3Gc   00:00:00       103K   19:48:08 
4648502           small          5           COMPLETED        3Gc   03:34:28              21:02:19 
4648502.bat+                     5        1  COMPLETED        3Gc   03:34:28   3237854K   21:02:19 
4648502.ext+                     5        1  COMPLETED        3Gc   00:00:00       112K   21:02:19 
4648503           small          5           COMPLETED        3Gc   03:22:10              22:31:28 
4648503.bat+                     5        1  COMPLETED        3Gc   03:22:10   3237908K   22:31:28 
4648503.ext+                     5        1  COMPLETED        3Gc   00:00:00       117K   22:31:28 
4648504           small          5           COMPLETED        3Gc   03:46:56              21:59:14 
4648504.bat+                     5        1  COMPLETED        3Gc   03:46:56   3237688K   21:59:14 
4648504.ext+                     5        1  COMPLETED        3Gc   00:00:00       110K   21:59:14 
4648505           small          5           COMPLETED        3Gc   03:02:40              18:17:48 
4648505.bat+                     5        1  COMPLETED        3Gc   03:02:40   3237802K   18:17:48 
4648505.ext+                     5        1  COMPLETED        3Gc   00:00:00       115K   18:17:48 
4648506           small          5           COMPLETED        3Gc   04:03:24              23:18:08 
4648506.bat+                     5        1  COMPLETED        3Gc   04:03:24   3237823K   23:18:08 
4648506.ext+                     5        1  COMPLETED        3Gc   00:00:00       118K   23:18:08 
4648507           small          5           COMPLETED        3Gc   03:46:20              22:58:43 
4648507.bat+                     5        1  COMPLETED        3Gc   03:46:20   3238019K   22:58:43 
4648507.ext+                     5        1  COMPLETED        3Gc   00:00:00       110K   22:58:43 
4648508           small          5           COMPLETED        3Gc   03:28:25              21:36:26 
4648508.bat+                     5        1  COMPLETED        3Gc   03:28:25   3237651K   21:36:26 
4648508.ext+                     5        1  COMPLETED        3Gc   00:00:00       110K   21:36:26 
4648509           small          5           COMPLETED        3Gc   02:51:52              19:37:44 
4648509.bat+                     5        1  COMPLETED        3Gc   02:51:52   3237642K   19:37:44 
4648509.ext+                     5        1  COMPLETED        3Gc   00:00:00       116K   19:37:44 
4648510           small          5           COMPLETED        3Gc   03:12:45              21:23:50 
4648510.bat+                     5        1  COMPLETED        3Gc   03:12:45   3237518K   21:23:50 
4648510.ext+                     5        1  COMPLETED        3Gc   00:00:00        94K   21:23:50 
4648511           small          5           COMPLETED        3Gc   03:37:41              22:36:38 
4648511.bat+                     5        1  COMPLETED        3Gc   03:37:41   3237838K   22:36:38 
4648511.ext+                     5        1  COMPLETED        3Gc   00:00:00       108K   22:36:38 
```


### The Bismark HTML Processing Report

### multiqc 
Gives a nice [html report](./multiqc_report.html) of bismark outputs

- activate the venv where multiqc is installed: `source /scratch/project_2003821/RGQMA/my_venv/bin/activate`
- Resolve the UTF8 problem by `export LC_ALL=en_US.utf8` & `export LANG=en_US.utf8` 

Everything seems normal, accordind to the [multiqc html report](./multiqc_report.html). A high duplication level is normal. 







