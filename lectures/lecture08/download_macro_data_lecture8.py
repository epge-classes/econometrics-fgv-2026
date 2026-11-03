"""
Download the macroeconomic series for Lecture 8 from the Brazilian Central Bank API.

Series downloaded (SGS codes):
    - ipca:    IPCA inflation, monthly % change (433)
    - usd_brl: USD/BRL exchange rate, monthly average of the PTAX sell rate (3698)
    - currency: currency held by the public, end-of-period balance, BRL thousands (27789)

The 2025 version downloaded the same code 27789 but called it M2. M2 is code 27810:
about BRL 7 trillion in 2025, against about BRL 0.3 trillion of currency.

Usage:
    python download_macro_data_lecture8.py

Output:
    brazil_macro_data.csv, next to this script. Index: Date. One column per series.

Dependencies: pandas, requests.
"""

from datetime import datetime
from pathlib import Path

import pandas as pd
import requests

dir_to_save = Path(__file__).resolve().parent


def download_bcb_series(series_code, start_date='01/01/2000', end_date=None):
    """Download one time series from the Brazilian Central Bank API"""
    if end_date is None:
        end_date = datetime.now().strftime('%d/%m/%Y')

    url = f'https://api.bcb.gov.br/dados/serie/bcdata.sgs.{series_code}/dados'
    params = {'formato': 'json', 'dataInicial': start_date, 'dataFinal': end_date}

    response = requests.get(url, params=params, headers={'User-Agent': 'Mozilla/5.0'}, timeout=60)
    response.raise_for_status()

    df = pd.DataFrame(response.json())
    df['data'] = pd.to_datetime(df['data'], format='%d/%m/%Y')
    df['valor'] = pd.to_numeric(df['valor'], errors='coerce')
    return df.set_index('data')['valor'].sort_index()


series = {'ipca': 433, 'usd_brl': 3698, 'currency': 27789}

df = pd.DataFrame({name: download_bcb_series(code) for name, code in series.items()})
df = df[df['ipca'].notna()]
df.index.name = 'Date'
df.to_csv(dir_to_save / 'brazil_macro_data.csv')

print(f"Saved {len(df)} observations, {df.index.min():%Y-%m} to {df.index.max():%Y-%m}")
