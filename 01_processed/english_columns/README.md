# English-column handoff files

The local preprocessing step creates readable English-column copies of all 16 Parquet files in `../`. Each copy keeps the same filename, row order, values, and data types as its source. Parquet data files are excluded from Git; this repository contains the preprocessing code and column mapping. Existing notebook cells refer to the original column names.

Use `column_mapping.csv` to translate every column name. Common examples:

| Original | Here | Meaning |
|---|---|---|
| `TA_YMD` | `payment_date` | Card payment date |
| `STD_YM` | `year_month` | Year and month, formatted YYYYMM |
| `MCT_SGG_CD` | `merchant_region` | Merchant city/district label |
| `MCT_RY_CD` | `merchant_industry` | Merchant industry |
| `CLN_SGG_CD` | `customer_residence_region` | Cardholder residence region |
| `TS_AT` | `total_payment_amount` | Sum of payment amounts |
| `USE_CNT` | `payment_count` | Sum of payment counts |
| `BLOCK_CD` | `small_area_code` | Source small-area code |
| `REGION_CANDIDATE` | `candidate_region` | Provisional region based on code prefix |
| `FLOW_POP_DAILY_AVG` | `avg_daily_flow_population` | Monthly average daily floating population |

The `candidate_region` assignment remains **provisional**, since the provided files do not contain an official small-area-to-city lookup. Floating population values are monthly averages, not observations for individual payment dates. The age-source October discrepancy is retained in `october_grid_discrepancy_flag`. Card dataset 1 and dataset 2 describe overlapping payments from different views and must not be added together.

The column rename is defined in `src/03_preprocessing.ipynb`. Each local copy was read back and compared with its renamed source.
