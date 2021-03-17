# Storing data to Allas from Puhti (and delete them from Puhti)
See [doc](https://docs.csc.fi/data/Allas/)

## Open connection to Allas in Puhti terminal
```
module load allas
allas-conf project_2003821
```
Provide log in details, once logged in the connection will stay open for 8 hours and you can put data to upload.
Do not close the connection before upload is complete (a report of the upload will be printed to the terminal once it is done).

## uploading the data

`a-put --nc -b quail_glyphoRRBS README.txt` 
   
- `-b` is for naming the "bucket" = folder.
- `--nc` skips the compression and uploads the file to Allas as it is

To check that the bucket works correctly: 
`a-list quail_glyphoRRBS`

### load the files 

when in `original_fastq` directory: `a-put --nc -b quail_glyphoRRBS original_fastq`

### uploading RGQMA1 data 
Upload the content of all batch folders, and store them in 3 differents buckets : one for the trimmed read, one for the bismark output files, and one for the methylation extraction files. 

```
for folder in `cat /scratch/project_2003821/RGQMA/RGQMA1/allfolders.txt`
do
    a-put --nc -b bismark_output ./${folder}/bismark_output_${folder}/*
    a-put --nc -b bismark_meth_call_output ./${folder}/meth_${folder}/*
    a-put --nc -b trimmed_samples ./${folder}/trimmed*/*
done
```
Because it takes time, and the connection may stop, I ran this script one batch at a time.

## Hard copy 
Keep a hard copy of: 

- fastq files 
- alignment files (.bam)
- txt files report that I can keep on my personal computer

## Delete buckets or file 
`swift delete buckets`  
`swift delete buckets files`  
`swift delete all`

## List the data buckets and objects in Allas: 
a-list 

## local copy of reports 
see copy_report.sh 

## delete from scratch (dangerous zone)
```
for folder in `cat allfolders.txt`; do rm -rf ./${folder}/; done
```

