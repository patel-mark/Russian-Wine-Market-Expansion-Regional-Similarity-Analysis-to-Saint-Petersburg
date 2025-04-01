# Russian Wine Market Expansion: Regional Similarity Analysis to Saint Petersburg

Welcome to my project repository for analyzing regional wine consumption trends in Russia. The goal of this project was to identify 10 regions with wine consumption patterns similar to Saint Petersburg so that a successful wine promotion campaign could be rolled out in these areas. In this README, I document the steps I took—from data extraction and SQL analysis to visualization in Power BI—and how I arrived at my recommendations.

## Table of Contents

- [Introduction](#introduction)
- [Project Objectives](#project-objectives)
- [Data Extraction and Preparation](#data-extraction-and-preparation)
- [SQL Analysis](#sql-analysis)
  - [Wine Consumption Growth Rate by Region](#wine-consumption-growth-rate-by-region)
  - [Wine to Other Alcohol Ratios](#wine-to-other-alcohol-ratios)
  - [Composite Similarity Score to Saint Petersburg](#composite-similarity-score-to-saint-petersburg)
  - [Final Query to Identify the 10 Most Similar Regions](#final-query-to-identify-the-10-most-similar-regions)
- [Power BI Analysis and Visualizations](#power-bi-analysis-and-visualizations)
- [Insights and Recommendations](#insights-and-recommendations)
- [Conclusion](#conclusion)
- [How to Run the Project](#how-to-run-the-project)

## Introduction

A recent wine promotion in Saint Petersburg resulted in exceptional performance. However, due to logistical constraints, running the promotion nationwide isn’t feasible. Therefore, I sought to identify 10 other regions with similar buying habits by focusing on key metrics such as wine consumption growth, alcohol consumption ratios, and composite similarity scores relative to Saint Petersburg.

## Project Objectives

- **Analyze Data**: Extract insights from raw SQL data to understand wine consumption patterns.
- **SQL Queries**: Use SQL to generate CSV outputs that summarize key metrics.
- **Data Visualization**: Import and visualize the cleaned CSV data in Power BI.
- **Insightful Storytelling**: Create compelling visualizations and narratives that explain the data.
- **Recommendation**: Identify 10 regions that mirror Saint Petersburg's wine consumption trends for a targeted promotion.

## Data Extraction and Preparation

Before moving to Power BI, I generated several CSV files from the original dataset using Microsoft SQL Server. The following SQL scripts were used:

1. **wine consumption growth rate by region.sql**
2. **wine to other alcohol ratios for each region.sql**
3. **composite similarity score to Saint Petersburg.sql**
4. **Final query to identify the 10 most similar regions to Saint Petersburg.csv**

These queries cleaned the data and extracted key insights, ensuring proper formatting for Power BI.

## SQL Analysis

### Wine Consumption Growth Rate by Region

```sql
-- Calculate wine consumption growth rate by region
WITH YearlyData AS (
    SELECT 
        [region],
        [year],
        [wine],
        LAG([wine]) OVER (PARTITION BY [region] ORDER BY [year]) AS prev_year_wine
    FROM [WineInRussia].[dbo].[russian_alcohol_consumption]
)
SELECT 
    [region],
    AVG(([wine] - prev_year_wine) / NULLIF(prev_year_wine, 0)) AS avg_growth_rate
FROM YearlyData
WHERE prev_year_wine IS NOT NULL
GROUP BY [region]
ORDER BY avg_growth_rate DESC
```

### Wine to Other Alcohol Ratios

```sql
-- Calculate wine to other alcohol ratios for each region
SELECT 
    [region],
    AVG([wine]) AS avg_wine,
    AVG([wine]) / NULLIF(AVG([beer]), 0) AS wine_to_beer_ratio,
    AVG([wine]) / NULLIF(AVG([vodka]), 0) AS wine_to_vodka_ratio,
    AVG([wine]) / NULLIF(AVG([champagne]), 0) AS wine_to_champagne_ratio,
    AVG([wine]) / NULLIF(AVG([brandy]), 0) AS wine_to_brandy_ratio
FROM [WineInRussia].[dbo].[russian_alcohol_consumption]
GROUP BY [region]
ORDER BY [region]
```

### Composite Similarity Score to Saint Petersburg

```sql
-- Create a composite similarity score to Saint Petersburg
WITH StPetersburgData AS (
    SELECT 
        AVG([wine]) AS avg_wine,
        AVG([beer]) AS avg_beer,
        AVG([vodka]) AS avg_vodka,
        AVG([champagne]) AS avg_champagne,
        AVG([brandy]) AS avg_brandy,
        AVG([wine]) / NULLIF(AVG([beer]), 0) AS wine_to_beer_ratio,
        AVG([wine]) / NULLIF(AVG([vodka]), 0) AS wine_to_vodka_ratio,
        AVG([wine]) / NULLIF(AVG([champagne]), 0) AS wine_to_champagne_ratio,
        AVG([wine]) / NULLIF(AVG([brandy]), 0) AS wine_to_brandy_ratio
    FROM [WineInRussia].[dbo].[russian_alcohol_consumption]
    WHERE [region] = 'Saint Petersburg'
),
RegionData AS (
    SELECT 
        [region],
        AVG([wine]) AS avg_wine,
        AVG([beer]) AS avg_beer,
        AVG([vodka]) AS avg_vodka,
        AVG([champagne]) AS avg_champagne,
        AVG([brandy]) AS avg_brandy,
        AVG([wine]) / NULLIF(AVG([beer]), 0) AS wine_to_beer_ratio,
        AVG([wine]) / NULLIF(AVG([vodka]), 0) AS wine_to_vodka_ratio,
        AVG([wine]) / NULLIF(AVG([champagne]), 0) AS wine_to_champagne_ratio,
        AVG([wine]) / NULLIF(AVG([brandy]), 0) AS wine_to_brandy_ratio
    FROM [WineInRussia].[dbo].[russian_alcohol_consumption]
    GROUP BY [region]
)
SELECT 
    rd.[region],
    rd.avg_wine,
    rd.avg_beer,
    rd.avg_vodka,
    rd.avg_champagne,
    rd.avg_brandy,
    -- Calculate a similarity score (lower is more similar)
    SQRT(
        POWER((rd.avg_wine - sp.avg_wine) / NULLIF(sp.avg_wine, 0), 2) * 5 + -- Higher weight for wine
        POWER((rd.avg_beer - sp.avg_beer) / NULLIF(sp.avg_beer, 0), 2) + 
        POWER((rd.avg_vodka - sp.avg_vodka) / NULLIF(sp.avg_vodka, 0), 2) + 
        POWER((rd.avg_champagne - sp.avg_champagne) / NULLIF(sp.avg_champagne, 0), 2) + 
        POWER((rd.avg_brandy - sp.avg_brandy) / NULLIF(sp.avg_brandy, 0), 2) +
        POWER((rd.wine_to_beer_ratio - sp.wine_to_beer_ratio) / NULLIF(sp.wine_to_beer_ratio, 0), 2) +
        POWER((rd.wine_to_vodka_ratio - sp.wine_to_vodka_ratio) / NULLIF(sp.wine_to_vodka_ratio, 0), 2) +
        POWER((rd.wine_to_champagne_ratio - sp.wine_to_champagne_ratio) / NULLIF(sp.wine_to_champagne_ratio, 0), 2) +
        POWER((rd.wine_to_brandy_ratio - sp.wine_to_brandy_ratio) / NULLIF(sp.wine_to_brandy_ratio, 0), 2)
    ) AS similarity_score
FROM RegionData rd
CROSS JOIN StPetersburgData sp
WHERE rd.[region] <> 'Saint Petersburg'
ORDER BY similarity_score ASC
```

### Final Query to Identify the 10 Most Similar Regions

```sql
-- Final query to identify the 10 most similar regions to Saint Petersburg
WITH StPetersburgData AS (
    SELECT 
        AVG([wine]) AS avg_wine,
        AVG([beer]) AS avg_beer,
        AVG([vodka]) AS avg_vodka,
        AVG([champagne]) AS avg_champagne,
        AVG([brandy]) AS avg_brandy,
        STDEV([wine]) AS stdev_wine,
        MAX([wine]) - MIN([wine]) AS range_wine,
        AVG([wine]) / NULLIF(AVG([beer]) + AVG([vodka]) + AVG([champagne]) + AVG([brandy]), 0) AS wine_preference_ratio
    FROM [WineInRussia].[dbo].[russian_alcohol_consumption]
    WHERE [region] = 'Saint Petersburg'
),
RegionData AS (
    SELECT 
        [region],
        AVG([wine]) AS avg_wine,
        AVG([beer]) AS avg_beer,
        AVG([vodka]) AS avg_vodka,
        AVG([champagne]) AS avg_champagne,
        AVG([brandy]) AS avg_brandy,
        STDEV([wine]) AS stdev_wine,
        MAX([wine]) - MIN([wine]) AS range_wine,
        AVG([wine]) / NULLIF(AVG([beer]) + AVG([vodka]) + AVG([champagne]) + AVG([brandy]), 0) AS wine_preference_ratio
    FROM [WineInRussia].[dbo].[russian_alcohol_consumption]
    GROUP BY [region]
)
SELECT TOP 10
    rd.[region],
    rd.avg_wine,
    rd.avg_beer,
    rd.avg_vodka,
    rd.avg_champagne,
    rd.avg_brandy,
    rd.wine_preference_ratio,
    -- Comprehensive similarity score (lower is more similar)
    SQRT(
        POWER((rd.avg_wine - sp.avg_wine) / NULLIF(sp.avg_wine, 0), 2) * 3 + -- Higher weight for wine
        POWER((rd.stdev_wine - sp.stdev_wine) / NULLIF(sp.stdev_wine, 0), 2) + -- Similar variability
        POWER((rd.range_wine - sp.range_wine) / NULLIF(sp.range_wine, 0), 2) + -- Similar range
        POWER((rd.wine_preference_ratio - sp.wine_preference_ratio) / NULLIF(sp.wine_preference_ratio, 0), 2) * 2 + -- Wine preference compared to other alcohol
        POWER((rd.avg_beer - sp.avg_beer) / NULLIF(sp.avg_beer, 0), 2) * 0.5 + 
        POWER((rd.avg_vodka - sp.avg_vodka) / NULLIF(sp.avg_vodka, 0), 2) * 0.5 + 
        POWER((rd.avg_champagne - sp.avg_champagne) / NULLIF(sp.avg_champagne, 0), 2) * 0.8 + -- Slightly higher weight for champagne (often paired with wine)
        POWER((rd.avg_brandy - sp.avg_brandy) / NULLIF(sp.avg_brandy, 0), 2) * 0.8  -- Slightly higher weight for brandy (similar demographic)
    ) AS similarity_score
FROM RegionData rd
CROSS JOIN StPetersburgData sp
WHERE rd.[region] <> 'Saint Petersburg'
ORDER BY similarity_score ASC
```

## Power BI Analysis and Visualizations

After cleaning and exporting my SQL results, I imported the CSV files into Power BI for further analysis. Here’s a summary of my Power BI workflow:

1. **Data Import**: Loaded the CSV files into Power BI.
2. **Data Cleaning & Transformation**: Handled NULL values and ensured correct data types.
3. **Creating Measures**: Developed DAX measures for dynamic analysis.
4. **Visualizations**:
   - **Bar Charts**: Compared wine consumption across regions.
   - **Line Graphs**: Tracked wine consumption growth trends.
5. **Storytelling**: Arranged visuals to explain the data narrative.

## Insights and Recommendations

Based on the combined SQL and Power BI analysis, I discovered the following:

- **Steady Growth**: The selected regions have shown consistent growth in wine consumption.
     Republic of North Ossetia-Alania
- **Balanced Ratios**: Wine-to-other alcohol ratios mirror Saint Petersburg's.
- **Composite Similarity**: The composite scores confirm similarity in consumption patterns.

### Recommendation

Launch the wine promotion in the 10 regions identified by my analysis. 
 Republic of Ingushetia
 Republic of Dagestan
 Republic of Karelia
 Sevastopol
 Pskov Oblast
 Mari El Republic
 Novgorod Oblast
 Republic of Kalmykia
 Republic of North Ossetia-Alania
 Republic of Bashkortostan
These regions are most likely to respond positively to the campaign.

## Conclusion

This project successfully combined SQL and Power BI to analyze regional wine consumption in Russia. By:

- Cleaning and transforming the data,
- Running targeted SQL queries,
- Visualizing insights in Power BI,

I was able to recommend 10 regions for the wine promotion rollout based on data-driven evidence.

## How to Run the Project

1. **SQL Scripts**: Run the provided SQL scripts to extract data.
2. **Import Data**: Load the CSV files into Power BI.
3. **Visualize Data**: Use DAX measures and Power BI visuals for analysis.
4. **Review Insights**: Explore findings in Power BI.
5. **Publish Report**: Share the Power BI report for further review.


I hope you find this project documentation helpful! Feel free to reach out if you have any questions or suggestions.


