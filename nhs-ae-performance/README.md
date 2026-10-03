# NHS England A&E 4-Hour Performance Analysis (April 2022 – March 2026)

Analysis of **48 months of official NHS England A&E statistics** (221 providers, 9,623 provider-month records, 107.0 million attendances) to track performance against the 4-hour standard, compare regions and trusts, and forecast demand for winter planning.

**Tools:** Python (Pandas, Statsmodels, Matplotlib, Seaborn), SQL (SQLite, CTEs, window functions)

## Key results
- **England 4-hour performance:** 73.9% (2022/23) → 72.6% (2023/24) → 73.9% (2024/25) → **74.9% (2025/26)**. March 2026 reached **77.1%**, just short of the **78% interim target** and far from the 95% constitutional standard.
- **Major (Type 1) A&E departments** perform much worse: around 60–64% within 4 hours.
- **12-hour waits from decision to admit** rose from 410,092 (2022/23) to **570,931 (2025/26)**, +39%.
- **Attendances** grew from 25.35m to 27.97m a year (+10%).
- **Regions (2025/26):** London best (77.2%), North West lowest (72.4%); Midlands 73.0%.
- **University Hospitals of Leicester** improved from **54.7% (2022/23) to 62.8% (2025/26)**, +8.1 points, but remains well below the England average of 74.9%.
- **Demand forecast:** a Holt-Winters seasonal model predicted monthly attendances for the 12 unseen months of 2025/26 with **1.72% MAPE**, beating the seasonal-naive baseline (2.44%).

## Data quality work
- Combined 48 monthly files with inconsistent formats.
- Found and removed **48 hidden 'TOTAL' summary rows** (5 different spellings, one labelled as a normal month) that would have double-counted activity.
- **Reconciled** provider-level figures to NHS England's published totals: difference = 0.
- Removed 6 stray empty columns in one file; cleaned 8,363 region names with trailing spaces.
- Checked for duplicates, missing values, negative values and impossible values (breaches > attendances): none found.

## Files
- `NHS_AE_Performance.ipynb` — full analysis with outputs
- `sql/kpi_queries.sql` — KPI queries (national trend, financial year, region ranking, worst trusts, Leicester vs England)
- `charts/` — performance trend, 12-hour waits, demand forecast

## Data
NHS England, "A&E Attendances and Emergency Admissions" monthly provider-level CSVs, Open Government Licence v3.0: https://www.england.nhs.uk/statistics/statistical-work-areas/ae-waiting-times-and-activity/
Target reference: NHS England 2025/26 priorities and operational planning guidance (78% within 4 hours by March 2026).
