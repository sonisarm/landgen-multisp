## Resistance surface modeling

This directory contains an end-to-end workflow to (1) prepare environmental rasters, (2) fit **single-variable** resistance surface models with **ResistanceGA** using **circuit-theory (commute) distances**, and (3) **compare** candidate single-variable models via bootstrapping.

The typical execution order is:

1. **Prepare rasters** (standardize extent/resolution/CRS; export ASCII `.asc`)
2. **Run single-variable resistance optimization** (one raster at a time; produces `*_one.rda` + bootstrap results)
3. **Run model comparison** (collects all single-variable outputs; produces `AIC.rda`)

#### Running workflow (recommended order)

##### Step 1) Raster preparation
- **`raster_preparation.Rmd`**: prepares environmental layers so they are suitable for resistance modeling (same projection, cell size, extent; consistent `NA` handling; exports to ASCII grids for downstream use). Expected output: One ASCII grid per variable, e.g. `bio1.asc`, `bio2.asc`, `wspeed.asc`, etc.
Run the raster preparation script to ensure all rasters are:
- in the same CRS
- have the same extent
- have the same resolution
- have consistent `NA` / mask treatment
Then export each variable as an ASCII grid (`.asc`) used by the modeling scripts.

##### 2) Single-variable resistance surface modeling (one raster per run)
- **`resistance_single_variable.R`**: fits a **single** resistance layer per run. The layer name is passed as a command-line argument (`var <- args[1]`). For a thorough explanation of this code, please see below.
What it does:
- Loads one raster layer
- Loads genetic distances (matrix) and coordinates; filters to matching sample IDs
- Converts genetic similarity to genetic distance (`gd <- 1 - gd`) **if needed**
- Optimizes a resistance transformation with **ResistanceGA** and saves results to `<var>_one.rda` 
- Bootstraps model support and saves `BOOTS.<var>_one.rda` 

Expected outputs:
- `<var>_one.rda`  
  The optimized model object (named `Slope_one` in the script), including the optimized parameters and the effective-distance matrices.
- `BOOTS.<var>_one.rda`  
  Bootstrap results for that single-variable model.

Run the same modeling script multiple times, each time passing a different `var` (e.g., `bio1`, `bio2`, `wspeed`, …). The script expects the raster to exist as `<var>.asc`.
On HPC, this is typically executed through **`runsingle.slurm`**, which should:
- request resources (CPUs/memory/time)
- call `Rscript resistance_single_variable.R <var>

##### 3) Compare models (after all single-variable runs finish)
- **`comparison.R`**  
  Loads multiple `*_one.rda` single-variable results, concatenates their effective-distance matrices and parameter tables, and runs `Resist.boot()` across models to compare support (AIC-based bootstrap). 

**What it does**
- Loads several optimized model objects (`bio1_one.rda`, `bio2_one.rda`, …, `wspeed_one.rda`, `wturb_one.rda`) and stores them.   
- Reads coordinate + genetic data; aligns IDs; creates the genetic distance matrix used for comparison   
- Builds:
  - `mat.list`: a named list of effective-distance matrices (one per model)
  - `k`: the per-model parameter table 
- Runs `Resist.boot(...)` to produce `AIC.boot` and saves it as `AIC.rda`  

**Expected outputs**
- `AIC.rda`  
  Model-comparison bootstrap results (relative support across candidate single-variable resistance surfaces).


---
#### Explanation of resistance surface modeling code
### A) `GA.prep(...)` – set up the genetic algorithm (GA)
In `resistance_single_variable.R`, the GA configuration is created as:

- `GA.inputs <- GA.prep(method="AIC", ASCII.dir=..., Results.dir=..., select.trans=list("A"))` fileciteturn9file0  
- `GA.inputs$parallel <- 20` fileciteturn9file0  

**Purpose**
- Defines how ResistanceGA will **transform** raster values into candidate resistance values.
- Chooses the model-selection criterion (`method="AIC"`) used during optimization.
- Controls the transformation family (`select.trans=list("A")`).
- Sets the number of cores for parallel evaluation (`parallel`).

**Output**
- A configuration object (`GA.inputs`) that tells `SS_optim()` what to optimize and how.



### B) `gdist.prep(...)` – prepare effective-distance calculations + response vector
The script then prepares the inputs needed for distance modeling:

- `gdist.inputs <- gdist.prep(n.Pops=..., samples=pts, response=lower(gd), method="commuteDistance")` fileciteturn9file0  

**Purpose**
- Defines the sampling locations (`samples=pts`)
- Defines the response variable as the **vector of pairwise genetic distances** (`lower(gd)`)
- Selects **commute distance** (circuit theory) as the landscape distance measure (`method="commuteDistance"`)

**Output**
- A `gdist.inputs` object used by `SS_optim()` to compute effective distances on each candidate resistance surface.

---

### C) `SS_optim(...)` – optimize resistance transformation parameters
Next, the GA is executed:

- `Slope_one <- SS_optim(gdist.inputs=gdist.inputs, GA.inputs=GA.inputs)` fileciteturn9file0  

**Purpose**
- Iteratively:
  1. transforms the raster into a candidate resistance surface
  2. computes pairwise **commute distances** between points on that surface
  3. fits a model to the pairwise genetic distances
  4. scores the model (AIC)
  5. searches parameter space to minimize AIC (best fit with complexity penalty)

**Output**
- `Slope_one`, which contains (among other objects):
  - effective-distance matrices (`Slope_one$cd`) fileciteturn9file0  
  - optimized parameter table (`Slope_one$k`) fileciteturn9file0  

The script saves it as `<var>_one.rda`. fileciteturn9file0

---

### D) `Resist.boot(...)` – bootstrap stability / support
Finally, the model is bootstrapped:

- `BOOTS.Slope_one <- Resist.boot(..., dist.mat=Slope_one$cd, n.parameters=k[,2], sample.prop=0.75, iters=10000, obs=n, genetic.mat=response)` fileciteturn9file0  

**Purpose**
- Re-samples the data repeatedly (here: 10,000 iterations; 75% subsampling) to assess:
  - stability of the relationship between resistance distances and genetic distances
  - uncertainty / robustness of the fitted model

**Output**
- A bootstrap object saved as `BOOTS.<var>_one.rda`. fileciteturn9file0  

The comparison script repeats a similar bootstrap procedure across multiple models and saves `AIC.rda`. fileciteturn9file3

---

## Inputs you must provide (per dataset/species)

The scripts assume:
- A coordinates file (columns include `ID`, `X`, `Y`) fileciteturn9file0  
- A genetic distance / similarity matrix readable into R (square matrix with rownames matching `ID`) fileciteturn9file0  
- One or more raster layers exported as ASCII grids (`<var>.asc`) fileciteturn9file0  

---

## Outputs and how to interpret them

### Per-variable outputs
- `<var>_one.rda`: optimized single-variable model object (`Slope_one`) fileciteturn9file0  
- `BOOTS.<var>_one.rda`: bootstrap results for that model fileciteturn9file0  

### Across-model output
- `AIC.rda`: bootstrap-based model comparison across variables (relative support). fileciteturn9file3

---

## Common pitfalls / troubleshooting

1. **CRS mismatch / points on `NA` cells**
   - If coordinates and rasters are not in the same CRS, extractions and distance calculations can fail (often producing `NA` distances).
2. **ID alignment**
   - Always ensure `ID` in coordinates matches the rownames of the genetic matrix; the scripts filter to the intersection of IDs. fileciteturn9file0  
3. **`n.Pops` calculation**
   - The script uses `n.Pops=length(pts)`; depending on object type, this may not equal number of points. fileciteturn9file0  
   - A safer pattern is `n.Pops = nrow(coordinates(pts))` after creating `SpatialPoints`.
4. **“0 (non-NA) cases” inside the GA**
   - Usually means that at some evaluation step there are no valid pairwise observations (often due to misalignment or NA distances).

---

## Suggested directory convention (example)

```
.
├── raster_preparation.Rmd
├── resistance_single_variable.R
├── comparison.R
├── runsingle.slurm
├── runcomparison.slurm
├── rasters/
│   ├── bio1.asc
│   ├── bio2.asc
│   └── ...
├── inputs/
│   ├── coords.csv
│   └── gd.csv
└── outputs/
    ├── bio1_one.rda
    ├── BOOTS.bio1_one.rda
    └── AIC.rda
```

Adjust paths in the scripts (`workdir`, raster paths, and input filenames) to match your HPC filesystem layout. fileciteturn9file0

