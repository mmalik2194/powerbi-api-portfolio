# Validation record — 1 November 2026

## Source and structure
Ten public API responses were downloaded: five World Bank responses (country metadata plus four indicators) and five NASA POWER city responses. Their original JSON and SHA-256 hashes are retained. Country/region aggregates were excluded from the World Bank facts. The development model has 5,425 unique country-year rows. The solar model has 10,960 unique city-day rows and a consecutive 2,192-day date dimension. NASA fill values were converted to null; these five downloaded series contained no fill values for the chosen fields.

The authored project/report JSON passed 103 schema checks before native Desktop normalization. Desktop subsequently resaved the development project's metadata using newer schema versions. Those native-generated schema references were not all resolvable through the public schema host in the validation script. Native loading, rendering and query execution provide the final functional evidence below; schema validation alone is not treated as proof of a working report.

## Native Power BI checks completed
Both reports opened in the installed Power BI Desktop, refreshed the embedded API snapshots and rendered their report pages. Both were saved as **standard PBIX files containing data**. The development project was also saved natively as PBIP. Screenshots are actual native Desktop captures.

All **30 development and 26 solar measures** executed without calculation errors in the local Analysis Services engine through Microsoft's ADOMD client. Default-context scalar results, including intentional blanks, are in development_all_measures_native.json and solar_all_measures_native.json. Nulls in those files can be intentional: for example, a base population stock requires one year, and YoY/YTD require one selected year.

### Development controls
- 2024 covered population: 8,117,484,624 (displayed as 8.12 billion).
- Population-weighted life expectancy: 73.460779852329 years.
- Population-weighted GDP per capita PPP: 21,495.07332678265 in constant 2021 international dollars.
- Default life-expectancy coverage: 217/217 economies.
- Australia 2024 life expectancy: 83.0512195121951 years, matching its source row.
- Metric switching to GDP returned the expected weighted GDP result.
- Reference year 2000 returned 67.6180655887266 years; the 2000 indexed trend equalled 100.
- Top 5 selection produced five nonblank country ranks. Duplicate country-year keys equalled zero.
- Native right-click **Drill through > Country deep dive** was tested successfully. The screenshot shows Monaco-specific results and a regional peer comparison. Missing Monaco GDP values correctly remained blank.

### Solar controls
- Total scenario energy at 100 kWp per city and 80% PR: 4,364,772.136 kWh.
- Mean daily solar resource: 4.978070410583942 kWh/m²/day.
- Adverse-day share at the default rule: 807/10,960 = 7.3631386861%.
- Capacity 250/100 ratio: 2.5×. Performance ratio 90/80: 1.125×.
- 2025 YTD equalled the 2025 annual result: 739,298.712 kWh.
- 2025 YoY: approximately +0.5831%. Multi-year YoY returned blank as intended.
- Trailing 30-day scenario energy at the final date: 92,939.736 kWh.
- The December 2020–2024 solar baseline was 7.4550668387 kWh/m²/day.
- Duplicate city-date keys and missing solar values equalled zero.

Independent Python controls are in validation_controls.json. Native scenario outputs are in development_native_checks.json and solar_native_checks.json.

## Remaining limits
Direct API endpoints were tested by the downloader; native Desktop calculation tests used the downloaded snapshot branches. Live M refresh has not been independently exercised in Power BI Service, and service refresh scheduling/credentials remain unconfigured. No online publication, RLS deployment, production performance benchmark or measured business impact has been performed. The solar scenario is not a validated production forecast.

## Added Power Platform source kits
The Power Apps kit includes exact control/formula mappings, a SharePoint list schema and an optional provisioning script. Its source references were checked against those schemas. It has not been executed in a Microsoft tenant and is not an exported .msapp.

The Power Automate project contains a designer build specification and executable dry-run logic, not an importable flow/solution export. All nine local tests pass. Public airport assets are attributed to OurAirports; request data is explicitly synthetic. Native app screenshots, cloud-flow run screenshots, connections and tenant deployment will be handled separately.
