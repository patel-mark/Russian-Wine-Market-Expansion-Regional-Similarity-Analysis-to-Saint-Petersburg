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
