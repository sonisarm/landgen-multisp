#### Species Distribution Models (SDM)

This repository contains scripts for modeling species distributions under current and future climate scenarios using **R** and **BIOMOD2**.

**Features**
* Prepare environmental rasters (climate, topography, snow)
* Load and clean species occurrence data (Excel + shapefiles)
* Extract environmental values, perform PCA & correlation analysis
* Generate background points and format data for **BIOMOD2**
* Run multiple SDM algorithms (GBM, RF, GLM) and ensemble forecasts
* Project species distributions under current and future climate scenarios
* Save raster outputs and PDF maps for visualization

**Requirements**
* R >= 4.0
* Key packages: `biomod2`, `terra`, `sf`, `raster`, `dplyr`, `ggplot2`, `randomForest`, `gbm`, `caret`, `pROC`

**Usage**
1. Set species and scenario parameters in the script or R Markdown, for example:
```r
species <- "bpalm"
gcm     <- "MRI-ESM2-0"
ssp     <- "ssp585"
```
2. Load environmental rasters and species coordinates.
3. Extract environmental variables at species locations.
4. Generate background points and format BIOMOD2 datasets.
5. Run models, evaluate, and create ensemble forecasts.
6. Project models for current and future scenarios.
7. Save outputs as raster files and PDF maps.

**Outputs**
* `env_species.tif` – Selected environmental variables
* `presence_species.csv` – Presence points
* `species_Current.tif` / `species_ssp585.tif` – Predicted suitability maps
* Evaluation tables and PDF maps
