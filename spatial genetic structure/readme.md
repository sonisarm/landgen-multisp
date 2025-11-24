
## Fine-scale Spatial Genetic Structure (FSGS)

This section quantifies fine-scale spatial genetic structure (FSGS) for each species using the **Sp statistic** (Vekemans & Hardy, 2004). FSGS describes how genetic relatedness between individuals decreases with geographic distance, and is useful to:

- Detect the impact of **limited seed and pollen dispersal**
- Compare spatial genetic patterns **between species, sites, or studies**
- Test whether species with **short-distance seed dispersal** show stronger spatial structure than those with **long-distance dispersal**

Although the Sp statistic is not a standardized index, **higher Sp values indicate stronger fine-scale spatial genetic structuring**.

### Analysis overview

For each species:

1. **Genetic relatedness**
   - Compute pairwise genetic distances using **Bruvo’s distance** (Bruvo et al., 2004) in **Genodive**.
   - Use these distances as a measure of relatedness between all pairs of individuals.

2. **Geographic distances**
   - Convert geographic coordinates to **UTM**.
   - Calculate **Euclidean distances** between all pairs of individuals.

3. **Sp statistic**
   - In **R**, run a **linear regression** of genetic relatedness against the **logarithm of geographic distance**.
   - Extract:
     - `b`: the slope of the regression
     - `F₁`: the mean relatedness of individuals in the **first distance class** (closest neighbors)
   - Compute the **Sp statistic** as:

     \[
     Sp = \frac{-b}{1 - F_1}
     \]

   - Assess the significance of `b` using **999 random permutations**.

The Sp statistic is relatively robust to the choice of sampling scheme and distance classes, making it suitable for **comparisons across species and populations**.

### Comparing dispersal strategies

To test whether **seed dispersal ability** influences spatial genetic structure:

- Group species according to their **seed dispersal strategy** (e.g. short-distance vs. long-distance).
- Compare **Sp values between groups** using a **t-test in R**.

Higher Sp values in short-distance dispersers, relative to long-distance dispersers, would support the hypothesis that **limited seed dispersal generates stronger fine-scale spatial genetic structure**.

### Software and dependencies

- **Genodive** – Bruvo’s distance and pairwise genetic relatedness
- **R** – regressions, Sp calculation, permutations, and t-tests

### References

- Vekemans, X. & Hardy, O.J. (2004). *New insights from fine-scale spatial genetic structure analyses in plant populations.*
- Bruvo, R. et al. (2004). *A simple method for the calculation of microsatellite genotype distances.*
- Miguel-Peñaloza, F. et al. (2023). *Application of Sp statistic to compare FSGS across plant species.*
