# Mock Data

Everything in this folder is **fictional**. It was generated at random by `scripts/make_mock_data.R` and contains no real observations. Do not report results from these files.

| Mock file | Stands in for | Rows | Columns |
|---|---|---|---|
| `mock_Grades.xlsx` | `Grades.xlsx` | 300 | `ID`, `Gender`, `Grade` |

## Matches the data shape report

- Excel file with one sheet
- Row count in the 100-999 range
- Same three column names, in the same order
- No missing values
- `ID` is numeric and unique
- `Gender` is a short category
- `Grade` is numeric, runs from 1 to 6 as confirmed by the researcher, and is flagged `categorical_like`

## Assumptions to check against the real data

The report does not give these details, so they are placeholders:

- **Gender labels:** `Female` and `Male`. The real labels are suppressed in the report.
- **Whole grades only:** the mock data has no half grades such as 4.5.
- **One row per student:** each `ID` appears once. The report does not confirm this for the real data.
- **Grade distribution:** both groups use the same random distribution, so any difference between them is noise.
