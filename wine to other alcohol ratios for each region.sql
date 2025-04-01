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