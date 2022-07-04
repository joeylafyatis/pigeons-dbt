DROP VIEW IF EXISTS vw_stats_by_manager;
CREATE VIEW vw_stats_by_manager AS 
WITH results AS (
    SELECT
        manager
        , COUNT(1) AS matches_played
        , COALESCE(SUM(CASE WHEN result = 'W' THEN 1 END), 0) AS wins
        , COALESCE(SUM(CASE WHEN result = 'D' THEN 1 END), 0) AS draws
        , COALESCE(SUM(CASE WHEN result = 'L' THEN 1 END), 0) AS losses
    FROM fact_matches
    GROUP BY 1
)
SELECT 
    dm.manager
    , dm.manager_nationality
    , dm.start_date
    , dm.end_date
    , r.matches_played
    , r.wins
    , r.draws
    , r.losses
    , ROUND(r.wins / CAST(r.matches_played AS FLOAT), 2) AS win_percentage
    , ROUND((r.wins + r.draws) / CAST(r.matches_played AS FLOAT), 2) AS unbeaten_percentage
FROM dim_manager AS dm
    INNER JOIN results AS r ON dm.manager = r.manager
ORDER BY dm.start_date ASC
;
