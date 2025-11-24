# Curso ChatGPT. 16-19 de Diciembre 2024
# Descripción del proyecto: El código convierte un archivo Excel con datos genéticos en un archivo TXT compatible con el input de SPAGeDi, organizando información de individuos, poblaciones y loci, e incluyendo metadatos detectados automáticamente a partir de los datos.


# Título: Código python para crear formato STRand
# Autor: Sonia Sarmiento
# Fecha: Febrero 2025

# input: xlsx con una columna por alelo, y otras columnas adicionales (posibles: ID, pop, X, Y)
# output: xlsx con formato SPaGeDi


import pandas as pd
import re

def process_excel_to_txt(input_path, output_path):
    """
    Process an Excel file to generate a TXT file with the specified rules.

    Args:
        input_path (str): Path to the input Excel file.
        output_path (str): Path to the output TXT file.
    """
    # Load the Excel file
    excel_data = pd.ExcelFile(input_path)
    data = excel_data.parse(excel_data.sheet_names[0])

    # Identify loci columns
    coord_columns = ['X', 'Y']
    start_loci_idx = data.columns.get_loc('X') + len(coord_columns)
    loci_columns = [col for col in data.columns[start_loci_idx:] if not str(col).startswith("Unnamed")]
    num_loci = len(loci_columns)

    # Helper function to clean and combine allele data
    def combine_alleles(row, start_idx, ploidy):
        alleles = [
            int(re.sub(r'\*', '', str(row.iloc[start_idx + i]))) if pd.notna(row.iloc[start_idx + i]) else 0
            for i in range(ploidy)
        ]
        sorted_alleles = sorted(alleles, key=lambda x: (x == 0, x))  # Move zeros to the end
        return "/".join(map(str, sorted_alleles))

    # Prepare output data
    output_data = []
    ploidy_values = []

    for _, row in data.iterrows():
        individual_data = [
            str(row["ID"]),
            str(row["pop"]),
            f"{row['X']:.4f}",
            f"{row['Y']:.4f}",
        ]
        i = start_loci_idx
        while i < len(data.columns):
            # Determine ploidy by checking consecutive "Unnamed" columns
            ploidy = 1
            while i + ploidy < len(data.columns) and "Unnamed" in str(data.columns[i + ploidy]):
                ploidy += 1
            ploidy_values.append(ploidy)
            individual_data.append(combine_alleles(row, i, ploidy))
            i += ploidy
        output_data.append("\t".join(individual_data))

    # Calculate metadata
    num_individuals = len(data)
    num_populations = data["Pop"].nunique()
    max_ploidy = max(ploidy_values)
    allele_characters = max(
        [len(str(a)) for a in data.iloc[:, start_loci_idx:].stack() if pd.notna(a) and '*' not in str(a)]
    )

    # Create header lines
    header_line_1 = (
        f"{num_individuals}\t{num_populations}\t{len(coord_columns)}\t"
        f"{num_loci}\t{allele_characters}\t{max_ploidy}\n"
    )
    header_line_2 = "\t".join(["10", "20", "40", "60", "80", "100"]) + "\n"
    # Use only relevant columns for the header
    filtered_columns = ["ID", "pop", "X", "Y"] + loci_columns
    header_line_3 = "\t".join(map(str, filtered_columns)) + "\n"

    # Assemble the final output file
    final_output_lines = [header_line_1, header_line_2, header_line_3]
    final_output_lines += [line + "\n" for line in output_data]
    final_output_lines.append("END\n")

    # Write to the output file
    with open(output_path, "w") as file:
        file.writelines(final_output_lines)

# Example usage
# Provide paths to input and output files
input_file_path = "/content/drive/MyDrive/SPAGeDi Input Generator/ViolaVG.xlsx"
output_file_path = "/content/drive/MyDrive/SPAGeDi Input Generator/VG-input.txt"
process_excel_to_txt(input_file_path, output_file_path)

