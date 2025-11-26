import sys
from pathlib import Path

import PyPDF2
import pandas as pd

# Valid wind directions (adapt if your tables include others)
VALID_DIRECTIONS = {
    "N", "NNE", "NE", "ENE", "E", "ESE", "SE", "SSE",
    "S", "SSO", "SO", "OSO", "O", "ONO", "NO", "NNO",
    "WNW", "NW", "NNW", "WSW", "SW"
}


def parse_pdf_to_df(pdf_path: Path) -> pd.DataFrame:
    print(f"Processing {pdf_path}...")
    rows = []

    with open(pdf_path, "rb") as f:
        reader = PyPDF2.PdfReader(f)

        # Pages are 0-indexed: user page "4" → index 3
        for page_idx in range(3, len(reader.pages)):
            page = reader.pages[page_idx]
            text = page.extract_text() or ""

            for line in text.splitlines():
                line = line.strip()
                if not line:
                    continue

                parts = line.split()
                # We expect: X Y 6 numeric values + direction = 9 tokens
                if len(parts) != 9:
                    continue

                x_str, y_str = parts[0], parts[1]
                dir_str = parts[-1]

                if dir_str not in VALID_DIRECTIONS:
                    continue
                if not (x_str.isdigit() and y_str.isdigit()):
                    continue

                num_tokens = parts[2:8]

                # Convert decimal commas to dots
                try:
                    nums = [
                        float(tok.replace(".", "").replace(",", "."))
                        if tok.count(",") == 1 and tok.replace(",", "").replace(".", "").isdigit()
                        else float(tok.replace(",", "."))
                        for tok in num_tokens
                    ]
                except Exception:
                    # If parsing fails for this line, skip it
                    continue

                rows.append({
                    "X": int(x_str),
                    "Y": int(y_str),
                    "V_wind_40": nums[0],
                    "Weibk_40": nums[1],
                    "V_wind_60": nums[2],
                    "Weibk_60": nums[3],
                    "V_wind_80": nums[4],
                    "Weibk_80": nums[5],
                    "Dominant_direction": dir_str,
                })

    df = pd.DataFrame(rows)
    print(f"  -> {len(df)} rows extracted")
    return df


def main():
    if len(sys.argv) < 2:
        print("Usage: python extract_wind_one.py <file.pdf>")
        sys.exit(1)

    pdf_path = Path(sys.argv[1])

    if not pdf_path.exists():
        print(f"⚠️ File not found: {pdf_path}")
        sys.exit(1)

    df = parse_pdf_to_df(pdf_path)

    # Output Excel file: same name as the PDF, .xlsx extension
    out_path = pdf_path.with_suffix(".xlsx")
    print(f"Saving {out_path} ...")
    df.to_excel(out_path, index=False)
    print("Done ✅")


if __name__ == "__main__":
    main()
