### Microsatellite formatting tools

This repository contains small helper scripts to convert raw microsatellite (SSR) data into formats commonly used in population genetic analyses (STRand, SPAGeDi, Genepop, STRUCTURE, Genodive, etc.).

##### Files

###### *`create_formatted_files.Rmd`*
R Markdown workflow using polysat and related packages to:
- Import STRand-formatted microsatellite data into a `Genambig` object.
- Export the same dataset into several downstream formats:
  - Genepop
  - STRUCTURE
  - Genodive
  - SPAGeDi (with and without spatial coordinates)
Intended as a generic template that users can adapt by changing paths, species codes, ploidy and locus information.


###### *`STRand-maker.py`*
Python script to convert raw Excel genotype files into STRand format.
- **Input:** `.xlsx` files with one column per allele plus metadata columns (e.g. `Ind`, `Pop`, `X`, `Y`), listed in a control text file (`STRand-input-files.txt`).
- **Process:**  
  - Groups columns by ploidy.
  - Collapses alleles per locus into a single STRand-style string (e.g. `100/102`), adding `*` when more than two alleles are present.
- **Output:** Per-dataset CSV and Excel files in STRand-compatible format.

###### *`Spagedi-maker.py`*
Python script to convert Excel microsatellite data into a **SPAGeDi**-compatible TXT file.  
- **Input:** `.xlsx` file with columns for individual ID, population, coordinates (`X`, `Y`) and one column per allele.
- **Process:**  
  - Detects loci and ploidy from the structure of the file.
  - Collapses alleles into SPAGeDi-style genotype strings (e.g. `100/102/0`).
  - Automatically builds the SPAGeDi header, including number of individuals, populations, loci, coordinates and allele coding parameters.
- **Output:** Plain-text `.txt` file ready to be used as SPAGeDi input.

##### Requirements

- **R** (for `create_formatted_files.Rmd`) with packages: `polysat`, `adegenet`, `poppr`, `tidyr`, `readxl`, `dplyr`, `radiator`, etc.
- **Python 3** with `pandas` (and `openpyxl` for reading Excel files).
