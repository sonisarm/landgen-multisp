## Polyploid Analysis

This section describes how microsatellite data were analyzed in polyploid plant species, with a focus on correctly handling inheritance mode (autopolyploid vs. allopolyploid) to avoid biased population genetic inferences.

Polyploid analyses are challenging because of:
- Unknown allele dosage
- Genotyping errors
- Uncertain mode of inheritance (tetrasomic vs. disomic)

Although some methods address dosage and genotyping issues (e.g. Bruvo distance; Bruvo et al. 2004), uncertainty in inheritance mode remains a major source of bias when estimating population genetic metrics such as heterozygosity and F-statistics (Meirmans et al. 2018).

### Goals

1. Determine whether each polyploid species behaves more like an **autopolyploid** (tetrasomic inheritance) or an **allopolyploid** (disomic inheritance).
2. Use this information to build **appropriate datasets** for downstream population genetic and structure analyses.


### Step 1 – Inheritance mode assessment using FIS in Genodive

We first assessed whether the polyploid species follow mainly disomic or tetrasomic inheritance patterns by examining the **inbreeding coefficient (FIS)** across loci. Under strict disomic inheritance (as expected in allotetraploids), loci often show fixed heterozygosity, leading to negative FIS values, while deviations from this pattern are indicative of tetrasomic inheritance (Meirmans & Van Tienderen, 2012).

**Implementation:**
FIS was calculated at the “locus × population” level in GenoDive v3.06 (Meirmans, 2020), which also tests for Hardy–Weinberg equilibrium (HWE). To reduce confounding effects of population structure: 1) a Lynch distance matrix was computed, 2) neighbor-joining trees were generated to visualize genetic clustering. These analyses were performed in section 6 of the R code *polyploid_analysis.Rmd*.


### Step 2 – Isolocus assignment with *polysat* in R
To further clarify inheritance mode and identify isoloci (loci corresponding to different subgenomes in allopolyploids), we used the *polysat* package in sections 8 and 9 of R code *polyploid_analysis.Rmd*:
1. **Initial allele clustering**
   - The function *`alleleCorrelations`* computes pairwise correlations among alleles using Fisher’s exact test.
   - Alleles are clustered into provisional isoloci via:
     - K-means clustering, followed by  
     - UPGMA (hierarchical clustering).

2. **Refinement with `testAlGroups`**
   - The *`testAlGroups`* function evaluates these allele clusters against individual genotypes.
   - Isolocus assignments are refined within a tolerance threshold of 0.01, improving consistency with observed genotype patterns.


### Step 3 – Building “full” and “partial” datasets

Based on the isolocus and FIS analyses, we generated two datasets for each species with clear isolocus structure:

1. Full dataset, which includes all loci, regardless of inferred inheritance mode.

2. Partial dataset, which excludes loci showing disomic inheritance and retains loci consistent with tetrasomic or mixed autopolyploid-like inheritance.

Rationale: many population genetic structure methods assume a single inheritance model. Mixing loci that follow different segregation rules (disomic vs. tetrasomic) can bias estimates of allele frequencies, heterozygosity, and F-statistics (Meirmans et al. 2018). The partial dataset minimizes this issue.


### Key references

- Bruvo, R. et al. (2004). Method for calculating microsatellite genotype distances in polyploids.
- Meirmans, P.G. & Van Tienderen, P.H. (2012). Inheritance models and their effects on polyploid population genetic analyses.
- Meirmans, P.G. et al. (2018). Review of polyploid analysis issues in population genetics.
