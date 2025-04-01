# Russian-Wine-Market-Expansion-Regional-Similarity-Analysis-to-Saint-Petersburg
Welcome to my project repository for analyzing regional wine consumption trends in Russia. The goal of this project was to identify 10 regions with wine consumption patterns similar to Saint Petersburg, so that a successful wine promotion campaign can be rolled out in these areas. In this README, I document the steps I took—from data extraction and SQL analysis to visualization in Power BI—and how I arrived at my recommendations.

## Introduction
In this project, I analyzed alcohol consumption data from a chain of stores across Russia. A recent wine promotion in Saint Petersburg resulted in exceptional performance. However, due to logistical constraints, running the promotion nationwide isn’t feasible. Therefore, I sought to identify 10 other regions with similar buying habits by focusing on key metrics such as wine consumption growth, alcohol consumption ratios, and composite similarity scores relative to Saint Petersburg.

## Project Objectives
### Analyze Data: Extract insights from raw SQL data to understand wine consumption patterns.

### SQL Queries: Use SQL to generate CSV outputs that summarize key metrics.

### Data Visualization: Import and visualize the cleaned CSV data in Power BI.

### Insightful Storytelling: Create compelling visualizations and narratives that explain the data.

### Recommendation: Identify 10 regions that mirror Saint Petersburg's wine consumption trends for a targeted promotion.

## Data Extraction and Preparation
Before moving to Power BI, I generated several CSV files from the original dataset using Microsoft SQL Server. The following SQL scripts were used:

wine consumption growth rate by region.sql

Analyzed annual growth in wine consumption by region to understand trends over time.

wine to other alcohol ratios for each region.sql

Calculated ratios between wine consumption and other types of alcohol (beer, vodka, champagne, brandy) for each region.

composite similarity score to Saint Petersburg.sql

Developed a composite score based on various metrics to measure how similar each region is to Saint Petersburg.

Final query to identify the 10 most similar regions to Saint Petersburg.csv

Finalized the selection of 10 regions by combining insights from the previous queries.
