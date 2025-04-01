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
ORDER BY similarity_score DESC