# computing notes 
## My CSC
 
`ssh servante@puhti.csc.fi`  
to check the disk area: `csc-workspaces`

<https://docs.csc.fi/support/tutorials/puhti_quick/#connecting-to-puhti>

It allows me to connect to the super calculator.

To access a project:
log on [mycsc](https://user-auth.csc.fi/idp/profile/oidc/authorize?execution=e1s1)

## Filezilla 

To make a link to the project's path (in the current directory:
`ln -s /path/to/folder/or/file/ name_for_the_link`

Reload Filezilla to make appear the output right after a run.

## NoMachine 

### install bismark and trimgalore
- copied bismark and trimgalore from my computer to filezilla in the project directory `cd /scratch/project_2003846`
- to load bowtie2, samtools, cutadapt, and fastqc `module load biokit`
- Add bismark and trimgalore to the path (at the beginning of every session) `export PATH=$PATH:/users/servante/scratch/project_2003846/TrimGalore-0.6.6`. 

## batch job script for Puhti
A script containing the resources to be reserved to run it.

Exemple of a batch job script to run the bismark test data set 

```
#!/bin/bash
#SBATCH --job-name=bismark_test1
#SBATCH --account=project_2003846 
#SBATCH --output= /users/servante/scratch/project_2003846/bismark_testoutput_bismark_test1.txt
#SBATCH --error= /users/servante/scratch/project_2003846/bismark_testerrors_bismark_test1.txt
#SBATCH --time=00:15:00 
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=2G
#SBATCH --partition=test  
```
see <https://docs.csc.fi/computing/running/creating-job-scripts-puhti/>










