#!/bin/bash
#SBATCH -J harv
#SBATCH -t 5-00:00:00
#SBATCH -n 5
#SBATCH -N 1
#SBATCH --mem 32G
#SBATCH -e assembly_%j.err
#SBATCH -o assembly_%j.out
#SBATCH -p q1

# NOTA: Lanzar el arreglo de la siguiente manera:
# sbatch --array=1-10%5 parallel_structure.slurm

# Cargar los módulos requeridos para q1:
module load structure/2.3.4/gcc/9.3.0-h4nj \
        structureharvester/1.0/gcc/9.3.0-b5ct \
        parallel/20190222/gcc/9.3.0-734l

structureHarvester.py --dir ./cteydis --out ./cteydis/clump --clumpp --evanno