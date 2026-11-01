# Development Intelligence â€” World Bank API

**[Download the ready-to-open PBIX](https://github.com/mmalik2194/powerbi-api-portfolio/releases/download/v1.0.0/Development_Intelligence.pbix)**
## Portfolio purpose
An advanced descriptive report for comparing living standards across 217 economies using World Development Indicators. It demonstrates REST ingestion, reusable semantic measures, filter-context design, weighted aggregation, peer benchmarking and country drillthrough.

## Open and refresh
For immediate viewing, open the included **.pbix** file with imported data. The following instructions apply to the editable source project.
Open Development_Intelligence.pbip with its Report and SemanticModel directories beside it. Select Refresh if you open the source project without a local cache. The default data comes from embedded snapshots fetched directly from the public World Bank API on 1 November 2026. No API key is required.

For direct API refresh, Transform data > Manage Parameters > set UseLiveAPI to true, then Close & Apply. Use Anonymous credentials for https://api.worldbank.org if asked. The live queries use a fixed host, RelativePath and Query options, read the API's page metadata and combine all pages. Date bounds are deliberately fixed at 2000â€“2024. A failed API call is surfaced rather than silently replaced by an old snapshot. Missing indicator values remain blank. Set UseLiveAPI back to false to use the reproducible embedded data.

The original responses and hashes are retained in api_snapshots/ and the root sources.json. PowerQuery/ contains the exact M scripts. measures.dax is a readable measure catalogue; the actual definitions are already in the semantic model.

## Report pages
1. **Development intelligence** â€” reference-year and region controls, disconnected metric switch, Top N control, weighted snapshot KPIs, metric-aware country ranking and regional trends.
2. **Country deep dive** â€” direct country selection or right-click drillthrough from a country on the ranking. Includes year-on-year change, regional peer gap, GDP per capita CAGR and an indexed history (2000 = 100).
3. **Data quality & methodology** â€” reporting-country coverage, missing-metric counts, duplicate-key check and country-level audit.

## Model
FactDevelopment contains 5,425 country-year rows (217 Ã— 25 years). DimCountry and DimYear have unique keys and single-direction one-to-many relationships. AsOfYear, MetricSelector and RankControl are deliberately disconnected; their selected values drive DAX without removing the trend's year context. Metadata classes such as region and income group are the current API classifications, not reconstructed historical classifications.

Measure display folders separate Controls, Base measures, Snapshot, Comparisons, Ranking, Trends, Data quality and Narrative. Snapshot calculations remove the connected year context and apply the chosen reference year. Base stock/rate measures require a single connected year to prevent accidental summation across years. Indexed trends use the corresponding 2000 metric as their denominator and return blank if the baseline is unavailable.

## Important analytical definitions
- Population is summed across covered countries in one year, never across years.
- Life expectancy and GDP per capita PPP are population-weighted across rows where both the indicator and a positive population are available. GDP is constant **2021 international dollars**.
- Unemployment is the **unweighted mean of country rates**, not a global labor-force unemployment rate. The source indicator is the modeled ILO estimate.
- The ranking puts higher life/GDP values first and lower unemployment first. Dense ranks may include extra countries when values tie at the Top N cutoff.
- Peer benchmark uses the selected country's region, or all countries when a region is not uniquely determined. The benchmark removes the selected country filter.
- CAGR and aggregate year-to-year changes can reflect changes in reporting coverage as well as actual changes. Use a country drillthrough and the quality page before interpreting changes. These comparisons establish no causality.

## Demonstrate your skills
Switch from Life expectancy to GDP PPP per capita, change the Top N and reference year, filter a region, then right-click a country and drill through. Explain CALCULATE, REMOVEFILTERS, ALLSELECTED, RANKX, SWITCH, DIVIDE and missing-data denominators. Use the quality page to show why an accurate dashboard needs coverage diagnostics.

## Source indicators
- SP.POP.TOTL â€” population, total
- SP.DYN.LE00.IN â€” life expectancy at birth, total (years)
- NY.GDP.PCAP.PP.KD â€” GDP per capita, PPP (constant 2021 international $)
- SL.UEM.TOTL.ZS â€” unemployment, total (% of total labor force), modeled ILO estimate

API documentation: https://datahelpdesk.worldbank.org/knowledgebase/articles/898581-api-basic-call-structures
Data terms: https://www.worldbank.org/en/about/legal/terms-of-use-for-datasets

Root validation_controls.json records independent numerical controls. See VALIDATION.md for the completed native Desktop checks.
