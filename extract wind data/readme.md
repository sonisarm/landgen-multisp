
## Extract wind data from a PDF 
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


### Running the script
To extract wind data from a PDF, run the script from a PowerShell terminal (for example inside VS Code) as follows:
```
& path_to_python\python.exe "path_to_code/extract wind data/extract_wind_data.py" "path_to_file/extract wind data/GomeraTenerife5.pdf"  
```
- The first argument is the path to the *extract_wind_data.py* script.
- The second argument is the path to the input PDF (e.g., GomeraTenerife5.pdf).

The script will create an Excel file (.xlsx) in the same folder as the PDF, with the same name as the PDF but with the .xlsx extension.
