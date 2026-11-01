# Solar Resource & Weather Intelligence â€” NASA POWER API

**[Download the ready-to-open PBIX](https://github.com/mmalik2194/powerbi-api-portfolio/releases/download/v1.0.0/Solar_Weather_Intelligence.pbix)**
## Portfolio purpose
A planning dashboard comparing solar resource and illustrative equal-size photovoltaic systems in Sydney, Melbourne, Brisbane, Perth and Adelaide. It demonstrates public REST ingestion, date intelligence, scenario controls, regional comparisons and data-quality checks.

## Open and refresh
For immediate viewing, open the included **.pbix** file with imported data. The following instructions apply to the editable source project.
Open Solar_Weather_Intelligence.pbip with its Report and SemanticModel sibling folders intact. Refresh if using the source project without a data cache. Default mode uses embedded snapshots downloaded from NASA POWER on 1 November 2026. The public API needs no key.

For direct API refresh, set UseLiveAPI to true in Transform data > Manage Parameters, then Close & Apply. Use Anonymous credentials for https://power.larc.nasa.gov if requested. One fixed-host point request is made per city; the query expands the daily parameter records into rows. It replaces NASA's fill value with null, applies explicit data types and keeps errors visible. Bounds remain 1 January 2020 to 31 December 2025 for reproducibility. UseLiveAPI=false returns the frozen downloaded data.

## Pages
1. **Solar resource & weather planning** â€” city/year controls, what-if capacity and performance ratio, rain threshold, scenario energy, mean solar resource, adverse-day share, monthly energy and city ranking.
2. **Site analysis & time intelligence** â€” rolling 30-day energy, aligned prior-year comparison, network benchmark gap, daily trend and monthly anomaly table.
3. **Data quality & assumptions** â€” completeness, duplicate keys, source controls and the calculation definitions that make the scenario auditable.

## Model and advanced calculations
FactWeather has 10,960 city-day rows. DimDate contains 2,192 consecutive unique dates and is marked as a date table; month/day labels have chronological sort columns. DimCity has five unique site keys. Both dimensions filter the fact in a single direction. Capacity, PerformanceRatio and RainThreshold are disconnected what-if control tables.

Scenario energy (kWh) = sum of daily horizontal irradiation (kWh/mÂ²/day) Ã— installed capacity (kWp per selected city) Ã— performance ratio. Default is 100 kWp at each city and 80% performance ratio. This screening proxy uses equivalent peak-sun hours. It is **not metered generation** and is not an engineering yield estimate: tilt, orientation, shading, temperature-dependent derating, inverter clipping, downtime and electrical losses are not modeled separately.

Date intelligence includes DATEADD prior-year comparisons, TOTALYTD, DATESINPERIOD trailing 30 days and a fixed historical monthly baseline. YoY and YTD return blank unless one year is selected, preventing a misleading multi-year total comparison. A trailing window intentionally reads earlier dates outside the display filter. The 2020â€“2024 month baseline retains the selected city context while removing the display-year filter; it is a short-period reference, not a climate normal.

An illustrative adverse city-day has rainfall >= the selected threshold, maximum temperature >= 35Â°C OR daily mean wind >= 10 m/s. A date satisfying multiple conditions counts once per city. The policy is invented for demonstrating controls; it is not an observed operational outage, engineering limit or safety decision rule.

## Units and data interpretation
Solar: kWh/mÂ²/day. Temperatures: Â°C. Rainfall: mm/day. Wind: daily mean at 10 m, m/s. NASA POWER provides gridded/reanalysis and satellite-derived resource estimates, not on-site instrument readings. Requests use **local solar time**, which differs from civil time and daylight-saving time. No long-term climate trend is inferred from six years.

## Demonstrate your skills
Select one city and 2025, compare to the monthly baseline, then change installed capacity from 100 to 250 kWp. Scenario energy should scale 2.5Ã— while physical solar resource and weather observations stay unchanged. Change performance ratio and the rain threshold, then explain how the disconnected controls affect different measures. Use the data-quality page to reconcile completeness and keys.

Data acknowledgement: NASA Langley Research Center POWER Project. Original JSON, parameter metadata and headers are included in api_snapshots/. Provenance hashes are in the root sources.json.
API documentation: https://power.larc.nasa.gov/docs/services/api/temporal/daily/

See validation_controls.json and VALIDATION.md for numerical and native verification.
