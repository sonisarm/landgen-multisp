### Genetic structure analysis

This section summarizes the three approaches used to investigate genetic structure across species:

1) **STRUCTURE v2.3.4** (Pritchard et al. 2000): We inferred the most likely number of genetic clusters (K) and assigned individuals to these clusters. STRUCTURE input files were generated with polysat using each species’ ploidy level. Individuals with lower ploidy than the species’ maximum had missing data inserted and were treated as recessive alleles to account for allele-copy ambiguity (Clark & Jasieniuk 2011; Falush et al. 2007). To avoid clonal bias, only one representative per multilocus genotype was kept.
STRUCTURE was run on an HPC cluster using an array job to automate multiple values of K and 30 replicates per K. For each array task, the value of K was provided by SLURM_ARRAY_TASK_ID, and each K run was repeated 30 times in parallel using GNU Parallel:
```
sbatch --array=1-11%3 parallel_structure.slurm
```
Analyses ran for 500,000 MCMC iterations after 100,000 burn-in, testing K = 1–10 with 30 replicates each. The best K was chosen using ΔK (Evanno et al. 2005) in STRUCTURE SELECTOR (Li & Liu 2018), and replicates were summarized with CLUMPAK (Kopelman et al. 2015), see harvester.sh

* *parallel_structure.slurm*: SLURM batch script that launches STRUCTURE analyses for multiple K values using a job array. For each K indicated by SLURM_ARRAY_TASK_ID, it starts 30 independent replicates in parallel using GNU Parallel.

* *structure.sh*: Execution script called by the SLURM job (parallel_structure.slurm). It receives two arguments (K and replicate number), generates a unique output name for each run, and executes STRUCTURE using the input dataset and the parameter files mainparams.txt and extraparams.txt.

* *mainparams.txt*: Main parameter file for STRUCTURE, containing essential model settings such as burn-in length, number of MCMC iterations, ploidy, missing data symbol, and data formatting instructions. This file defines the core configuration for all STRUCTURE runs.

* *extraparams.txt*: Secondary parameter file that specifies additional STRUCTURE options, including admixture behavior, allele frequency models, and advanced settings that complement those in the main parameter file.

* *harvester.sh*: Processing script used to organize and summarize STRUCTURE outputs. It formats the output files for each K value so they can be processed by Structure Harvester, which calculates summary statistics such as likelihoods and prepares input files for determining the most probable K using the Evanno ΔK method.

* Cteydis: Example of STRUCTURE input file containing the multilocus genotype data for all individuals. Its created from a STRand file in R with the following R code:
```
# read STRand. Assign ploidy and usatnt.
Genambig <- read.STRand('STRand.csv', sep = ";", popInSam = FALSE)
all_samples <- Samples(Genambig)
Usatnts(Genambig) <- usatnt
Ploidies(Genambig) <- pl

write.Structure(Genambig, ploidy = pl, file=file.path("..", "..", "Data", "Stru", sp), writepopinfo = TRUE, missingout = -9)
```

2) **TESS3** (Caye et al. 2016): Spatial genetic structure was estimated in R using individuals’ GPS coordinates. The optimal number of clusters was selected based on the lowest cross-validation score.

3) **DAPC** (adegenet; Jombart & Bateman 2008): We performed discriminant analysis of principal components, which does not assume Hardy–Weinberg or linkage equilibrium. Sampling locations were used as prior groups, and the optimal number of PCs retained was chosen with xvalDapc. Discriminant functions were visualized using scatterplots in R.
