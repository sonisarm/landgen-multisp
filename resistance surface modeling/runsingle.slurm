#!/bin/bash
#SBATCH -J resistance
#SBATCH -t 5-00:00:00
#SBATCH -n 20
#SBATCH -N 1
#SBATCH --mem 100000
#SBATCH -e assembly_%j.err
#SBATCH -o assembly_%j.out
#SBATCH -p q2
#SBATCH --export=ALL

# WARNING: The environment must be loaded in the working session, not in the SLURM script.
#conda activate r-ssarmiento

Rscript resistance_single_variable.R $1

# $1 is the variable/surface (eg. bio1)
