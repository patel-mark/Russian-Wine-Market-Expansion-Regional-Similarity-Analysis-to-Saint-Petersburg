WITH StPetersburgAvg AS (
    SELECT AVG([wine]) AS avg_wine
    FROM [WineInRussia].[dbo].[russian_alcohol_consumption]
    WHERE [region] = 'Saint Petersburg'
),
RegionAvg AS (
    SELECT 
        [region],
        AVG([wine]) AS avg_wine
    FROM [WineInRussia].[dbo].[russian_alcohol_consumption]
    GROUP BY [region]
)
SELECT 
    r.[region],
    r.avg_wine,
    ABS(r.avg_wine - sp.avg_wine) AS wine_diff
FROM RegionAvg r
CROSS JOIN StPetersburgAvg sp
WHERE r.[region] <> 'Saint Petersburg'
ORDER BY wine_diff ASC;
