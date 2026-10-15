from pathlib import Path

from bcb import sgs

# Monthly IPCA and IGP-M (month-over-month % changes) from the BCB SGS
price_measures = sgs.get({'IPCA': 433, "IGPM": 189}, start='1995-02-01')
price_measures.index = price_measures.index.to_period('M')

price_measures.to_csv(Path(__file__).parent / "ipca_igpm.csv")

print("Data is downloaded and saved.")
