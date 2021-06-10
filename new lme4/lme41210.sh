#!/bin/bash -l
#SBATCH --job-name=r_lme41210
#SBATCH --account=project_2003846
#SBATCH --partition=small
#SBATCH --time=16:00:00
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --mem-per-cpu=50000
#SBATCH --mail-type=BEGIN

# Load r-env-singularity
module load r-env-singularity

# Clean up .Renviron file in home directory
if test -f ~/.Renviron; then
    sed -i '/TMPDIR/d' ~/.Renviron
fi

# Specify a temp folder path
echo "TMPDIR=/scratch/<project>" >> ~/.Renviron

# Run the R script
srun singularity_wrapper exec Rscript lme41210.R
