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
- [License](#license)

## Introduction

In this project, I analyzed alcohol consumption data from a chain of stores across Russia. A recent wine promotion in Saint Petersburg resulted in exceptional performance. However, due to logistical constraints, running the promotion nationwide isn’t feasible. Therefore, I sought to identify 10 other regions with similar buying habits by focusing on key metrics such as wine consumption growth, alcohol consumption ratios, and composite similarity scores relative to Saint Petersburg.

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
SELECT region,
       ((MAX(wine) - MIN(wine)) / MIN(wine)) * 100 AS growth_rate_percentage
FROM [WineInRussia].[dbo].[russian_alcohol_consumption]
GROUP BY region;
```

### Wine to Other Alcohol Ratios

```sql
SELECT region,
       AVG(wine) / NULLIF(AVG(beer), 0) AS wine_to_beer_ratio,
       AVG(wine) / NULLIF(AVG(vodka), 0) AS wine_to_vodka_ratio
FROM [WineInRussia].[dbo].[russian_alcohol_consumption]
GROUP BY region;
```

### Composite Similarity Score to Saint Petersburg

```sql
WITH SP AS (
    SELECT AVG(wine) AS sp_avg_wine
    FROM [WineInRussia].[dbo].[russian_alcohol_consumption]
    WHERE region = 'Saint Petersburg'
)
SELECT region,
       ABS(AVG(wine) - (SELECT sp_avg_wine FROM SP)) AS similarity_score
FROM [WineInRussia].[dbo].[russian_alcohol_consumption]
GROUP BY region
ORDER BY similarity_score ASC;
```

### Final Query to Identify the 10 Most Similar Regions

```sql
WITH CompositeScores AS (
    SELECT region,
           ABS(AVG(wine) - (SELECT AVG(wine) FROM [WineInRussia].[dbo].[russian_alcohol_consumption] WHERE region = 'Saint Petersburg')) AS composite_score
    FROM [WineInRussia].[dbo].[russian_alcohol_consumption]
    GROUP BY region
)
SELECT TOP 10 *
FROM CompositeScores
WHERE region <> 'Saint Petersburg'
ORDER BY composite_score ASC;
```

## Power BI Analysis and Visualizations

After cleaning and exporting my SQL results, I imported the CSV files into Power BI for further analysis. Here’s a summary of my Power BI workflow:

1. **Data Import**: Loaded the CSV files into Power BI.
2. **Data Cleaning & Transformation**: Handled NULL values and ensured correct data types.
3. **Creating Measures**: Developed DAX measures for dynamic analysis.
4. **Visualizations**:
   - **Bar Charts**: Compared wine consumption across regions.
   - **Line Graphs**: Tracked wine consumption growth trends.
   - **Scatter Plots**: Showed wine vs. other alcohol relationships.
   - **Composite Score Chart**: Highlighted the most similar regions.
5. **Storytelling**: Arranged visuals to explain the data narrative.

## Insights and Recommendations

Based on the combined SQL and Power BI analysis, I discovered the following:

- **Steady Growth**: The selected regions have shown consistent growth in wine consumption.
- **Balanced Ratios**: Wine-to-other alcohol ratios mirror Saint Petersburg's.
- **Composite Similarity**: The composite scores confirm similarity in consumption patterns.

### Recommendation

Launch the wine promotion in the 10 regions identified by my analysis. These regions are most likely to respond positively to the campaign.

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


