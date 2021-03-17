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

- to run: `sbatch bismark_test1.sh`

- to check the jobs done or running: `sacct --format=jobid,partition,ncpus,ntasks,state,reqmem,systemcpu,maxrss,elapsed`

- to check the memory efficiency: `seff [jobID]`

## Start a RStudio session on the server 
<https://docs.csc.fi/apps/r-env-singularity/>

1. start an interactive job on puhti: ` sinteractive --account 2003821 --mem 8000 --tmp 100` - opens an interactive session 
2. `module load r-env-singularity`
3. `start-rstudio-server`
4. in my local terminal copy paste the connexion infos to SSH tunnel with remote
5. copy paste in a browser `http://localhost:8787/`
6. sign in 

### How to save the value of my objects for future use 
#### Save 1 object
- `save(object, file = "object.RData"`
- At the beginning of a new session: `load("object.RData")`

#### Save the totality of the object created during the session 
- `save.image(file = "all_objects.RData")`
- At the beginning of a new session: `load("all_objects.RData")`

Or save workspace image...


## Run multiqc in a venv 
### Create a python3 venv
- `python3 -m venv /path/` - create a venv in desire path 
- `source /scratch/project_2003821/RGQMA/my_venv/bin/activate`

### install multiqc 
- `pip3 install multiqc`

### Resolve the UTF8 problem
- `export LC_ALL=en_US.utf8`
- `export LANG=en_US.utf8`


## Interactive job in puhti 
`sinteractive --account project_2003821 --time 48:00:00 --mem 30000 --tmp 400 -c 4`





