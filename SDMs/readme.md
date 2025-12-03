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
2. Load environmental rasters and species coordinates (including additional points from Biota/GBIF when needed).
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


#### Obtaining additional occurrence data (Biota & GBIF)
For some species, occurrence coordinates may be insufficient (e.g., *Bethencourtia palmensis*). In these cases, additional occurrence data can be obtained from Biota and GBIF.

**Biota**

Biota is the biodiversity database of the Canary Islands, providing detailed information on species distributions, habitats, and conservation status. It allows researchers and the public to access occurrence data, maps, and other ecological information for scientific and management purposes. The resolution of this data is 500-m. Data from Biota can be downloaded using the following approach:
* Visit the Biota portal: <https://www.biodiversidadcanarias.es/biota/>
* Navigate to Data / Análisis territorial.
* Click the three horizontal lines on the top left. Under Capas activas, add a new analysis layer (nueva capa de análisis).
* Give your layer a name. In the next step, search for the species you are interested in.
* In the Distribution tab (pestaña Distribución), select precision 1.
* Save your layer. Then, in the Operaciones section, export the occurrence points in shapefile or TXT format.


**GBIF** 

Global Biodiversity Information Facility (GBIF) is an international open-access platform that provides species occurrence data from museums, research institutions, and citizen science projects worldwide. It allows researchers to explore and download biodiversity data for scientific analyses and conservation planning.
* Visit the GBIF portal: <https://www.gbif.org/es/>
* Search for the species you are interested in
* Explore the occurrence points on the map and download the data for further use in your analyses

