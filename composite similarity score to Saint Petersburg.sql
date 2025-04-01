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