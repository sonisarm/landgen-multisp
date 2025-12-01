## Canary Islands Wind Mapping (2016)
Dataset promoted by the Ministry for Ecological Transition and developed by the Technological Institute of the Canary Islands (ITC) and AWS Truepower, SLU. It includes wind speed, power density, and Weibull parameters at 40, 60, 80, and 100 meters, with a 50x50 m spatial resolution, derived from the MASS mesoscale atmospheric model. 

The shapefiles can be obtained from the following link: <https://opendata.sitcan.es/dataset/cartografia-eolica-de-canarias-2016>. These shapefiles contain coordinates, mean wind speeds, power density, Weibull parameters, and wind direction frequencies across 16 sectors (wind rose). These layers are GIS-ready, unlike the PDFs available on the ITC portal (see below). This repository contains the R Markdown script `wind_value_rasterization.Rmd`, which processes wind data for the Canary Islands. Specifically, this performs the following tasks:
- Loads the Canary Islands wind shapefiles
- Extracts *mean wind speed* at 40-m above ground (`SPD40`) and *wind turbulence* (`WEIBK`).
- Rasterizes the data at 100‑m resolution to match the resolution of the CanaryClim dataset.
- Produces raster files ready for subsequent ResistanceGA analyses or other spatial modeling workflows.

## Optional: Extract wind data from raw data files
This directory contains a Python script to extract wind data from PDF files and export the results to Excel ('.xlsx'). 

### Origin of wind layers 
The wind data comes from the official Canary Islands wind-resource viewer: 
To install packages necessary for this python code run as follows in VScode terminal:
1. Go to: <http://recursoeolico.itccanarias.org/>

2. Click *“Detalle de los datos numéricos por islas”* (Numerical data detail by island), which redirects to:  
   <http://recursoeolico.itccanarias.org/island_cells/index.html>

3. Click on the area (cell) of interest to download the corresponding PDF with wind-resource values.

### PDF mapping per island 
The corresponding PDFs containing data from each islands are as follows:
- **La Palma** → `LaPalma 1–9` (Caldera de Taburiente = PDFs **4** and **5**)
- **La Gomera** → `Tenerife La Gomera 2, 3, 6`
- **Tenerife** → `Tenerife La Gomera 5, 6, 9, 10, 11, 12, 13`

### Requirements

This project uses Python with the following libraries:`PyPDF2`, `pandas` and `openpyxl`. Install them from the VS Code terminal (PowerShell) using:

```
& "path_to_python_python.exe" -m pip install PyPDF2 pandas openpyxl
```

To run the python code in a powershell terminal, run as follosws: 

### File overview 
- **`extract_wind_data.py`**: Main Python script. Reads a wind-layer PDF, parses the numerical data (wind speed, Weibull parameters, direction, etc.), and exports the results to an Excel file.

- **Wind-layer PDF(s)** (e.g. `GomeraTenerife5.pdf`): Input files downloaded from the wind-resource viewer. Each PDF contains the numerical wind data for a specific island area or cell.

- **Output Excel file(s)** (e.g. `GomeraTenerife5.xlsx`): Generated automatically by the script. Each Excel file contains the cleaned, tabular version of the data extracted from the corresponding PDF.

- **`Moraga_2010_*` (PDF)**: Scientific publication describing the methodology and background of the wind-resource layers used in this project (Moraga, 2010). This provides the scientific context and validation for the wind-layer data.

### Running the script
To extract wind data from a PDF, run the script from a PowerShell terminal (for example inside VS Code) as follows:
```
& path_to_python\python.exe "path_to_code/extract wind data/extract_wind_data.py" "path_to_file/extract wind data/GomeraTenerife5.pdf"  
```
- The first argument is the path to the *extract_wind_data.py* script.
- The second argument is the path to the input PDF (e.g., GomeraTenerife5.pdf).

The script will create an Excel file (.xlsx) in the same folder as the PDF, with the same name as the PDF but with the .xlsx extension.
