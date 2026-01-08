## Code for publication "*Do alpine island endemics share drivers of connectivity? A multi-species landscape genetic analysis from the Canary Islands*"

This repository accompanies a multi-species landscape genetics study of eight high-mountain endemic plants from Teide and Caldera de Taburiente National Parks (Canary Islands). The study aims to: (*i*) characterise environmental niches and habitat suitability, (*ii*) compare fine-scale spatial genetic structure between short- and long-distance seed dispersers, (*iii*) evaluate how topography, wind and climate shape genetic differentiation, and (*iv*) identify landscape connectivity corridors relevant for territorial planning. 

Methodologically, the workflow integrates environmental PCA, species distribution modelling (BIOMOD2), polyploid-appropriate microsatellite analyses, population genetic structure inference (STRUCTURE, TESS3, DAPC), fine-scale spatial genetic structure metrics (Sp statistic), and optimised resistance surface modelling (ResistanceGA) to relate genetic patterns to topo-climatic gradients and to forecast habitat suitability and connectivity.

A workflow diagram (below) summarises the analytical pipeline. Highlighted steps indicate components implemented in this repository; code is organised into folders that correspond to major analytical modules.
<img src="Supp_framework.png" alt="framework" width="1000">



### Repository structure and analytical modules

The repository is organised into modular directories that mirror the main analytical components of the study. Each folder contains the scripts, helper functions, and (where applicable) lightweight documentation required to reproduce that module.

#### Core analytical modules (aligned with manuscript objectives)

- **`polyploid analysis/`**  
  Polyploid-specific processing, analyses, and documentation supporting downstream population genetic inference (e.g., filtering rules, polyploid-aware summaries, and rationale for any partial dataset usage).

- **`spatial genetic structure/`**  
  Fine-scale spatial genetic structure analyses to quantify spatial patterning in genetic variation (e.g., workflows supporting Sp statistic estimation and related spatial diagnostics), including associated figures and summary outputs.

- **`structure/`**  
  Population genetic structure and clustering workflows (e.g., STRUCTURE and supporting pipelines for preparing inputs, running analyses, and post-processing/visualising results). Where relevant, includes templates for run settings and summarisation scripts.

- **`SDMs/`**  
  Species distribution modelling workflows (BIOMOD2), including occurrence/predictor preparation, model calibration and evaluation, and export of habitat suitability predictions used for interpretation and downstream connectivity modelling.

- **`environmental PCA/`**  
  Environmental ordination pipeline that extracts environmental predictors at individual or population coordinates and transforms them into orthogonal axes (PCA). Outputs are used for visualisation, niche comparison, and (where relevant) as reduced-dimension predictors for subsequent modelling.

- **`resistance surface modeling/`**  
  Landscape resistance modelling workflows (e.g., ResistanceGA) linking genetic differentiation to hypotheses derived from topography, wind, and climate. Includes scripts to build resistance surfaces, optimise parameters, compare candidate models, and export resistance/connectivity products.

#### Supporting utilities and data preparation

- **`file preparation/`**  
  Pre-processing utilities to standardise and validate project inputs (e.g., formatting tables, harmonising spatial reference systems, aligning rasters, enforcing consistent naming conventions, and generating analysis-ready datasets).

- **`extract wind data/`**  
  Tools to extract, process, and rasterise wind predictors for the study region from publicly available sources. Outputs are aligned to the project spatial template (extent, resolution, CRS) for direct use in environmental PCA, SDMs, and resistance modelling.

