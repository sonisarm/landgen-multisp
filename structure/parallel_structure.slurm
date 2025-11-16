#!/bin/bash
#SBATCH -J name
#SBATCH -t 5-00:00:00
#SBATCH -n 15
#SBATCH -N 1
#SBATCH --mem 32G
#SBATCH -e assembly_%j.err
#SBATCH -o assembly_%j.out
#SBATCH -p q1

# Parameters above depend on local cluster

# Load modules:
module load structure/2.3.4/gcc/9.3.0-h4nj \
        structureharvester/1.0/gcc/9.3.0-b5ct \
        parallel/20190222/gcc/9.3.0-734l

# seq 10 | parallel: command to run 10 process in parallel
# first variable is for K=SLURM_ARRAY_TASK_ID and second variable is for repetitions (see structure.sh)

seq 30 | parallel ./structure.sh ${SLURM_ARRAY_TASK_ID} {}
