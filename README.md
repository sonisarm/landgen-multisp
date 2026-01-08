## Code for publication "Multi-species landscape genetics to inform territorial planning"

The repository accompanies a multi-species landscape genetics study of eight high-mountain endemic plants from Teide and Caldera de Taburiente National Parks in the Canary Islands. The paper aims to (*i*) characterise environmental niches and habitat suitability, (*ii*) compare fine-scale spatial genetic structure between short- and long-distance seed dispersers, (*iii*) assess how topography, wind and climate shape genetic differentiation, and (*iv*) identify connectivity corridors. Methodologically, it combines  environmental PCA to explore their environment, species distribution modelling (BIOMOD2), polyploid-adequate microsatellite analyses, population genetic structure (STRUCTURE, TESS3, DAPC), fine-scale spatial genetic structure (Sp statistic), and optimised resistance surface modelling (ResistanceGA) to link genetic patterns with topo-climatic gradients and forecast habitat suitability and connectivity.

The following diagram provides an overview of the workflow for the analysis performed. The highlighted steps correspond to those for which code is included in this GitHub repository, and the analysis code is organized within the respective folders.

<img src="Supp_framework.png" alt="framework" width="1000">


Explanation of folder / framwrok sections realted to main analyses:

- **SDMs**: species distribution modeling workflows and code. 
- **environmental PCA**: pipeline used to represent environmental predictors at the location of the individuals or populations coordinates into orthogonal axes for visualization.
- **polyploid analysis**: analyses and documentation specific to polyploid considerations in the dataset and downstream population genetic inference.
- **resistance surface modeling**: landscape resistance modeling code
- **spatial genetic structure**: code to asses spatial patterns.
- **structure**: population clustering code and workflows

Additionally to these analyses, there are other analyses that include a directory in this repository which are:
- **file preparation**: pre-processing utilities to standarize and validate project inputs. 
- **extract wind data**: tools to extract and rasterize wind variables for the study region publicly available.
