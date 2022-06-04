DROP VIEW IF EXISTS vw_stats_by_manager;
CREATE VIEW vw_stats_by_manager AS 
WITH comp_matches AS (
    SELECT
        manager
        , COUNT(1) AS matches_played
        , SUM(CASE WHEN result = 'W' THEN 1 END) AS wins
        , SUM(CASE WHEN result = 'D' THEN 1 END) AS draws
        , SUM(CASE WHEN result = 'L' THEN 1 END) AS losses
    FROM vw_comp_matches
    GROUP BY 1
)
SELECT 
    dm.manager
    , dm.manager_nationality
    , dm.start_date
    , dm.end_date
    , cm.matches_played
    , cm.wins
    , cm.draws
    , cm.losses
    , ROUND(wins / CAST(matches_played AS FLOAT), 2) AS win_percentage
    , ROUND((wins + draws) / CAST(matches_played AS FLOAT), 2) AS unbeaten_percentage
FROM dim_manager AS dm
    INNER JOIN comp_matches AS cm ON dm.manager = cm.manager
;
