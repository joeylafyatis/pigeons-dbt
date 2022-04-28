DROP VIEW IF EXISTS vw_mls_regular_season;
CREATE VIEW vw_mls_regular_season AS 
SELECT
    match_date 
    , SUBSTR(match_date, 1, 4) AS mls_season
    , ROW_NUMBER() OVER(PARTITION BY SUBSTR(match_date, 1, 4) ORDER BY match_date ASC) AS mls_matchday
    , opponent
    , stadium
    , attendance
    , referee
    , is_home_match
    , nycfc_goals
    , opponent_goals
    , result
    , CASE result
        WHEN 'W' THEN 3
        WHEN 'D' THEN 1
        WHEN 'L' THEN 0
        END AS points
    , SUM(
        CASE result
            WHEN 'W' THEN 3
            WHEN 'D' THEN 1
            WHEN 'L' THEN 0
            END
    ) OVER (
        PARTITION BY SUBSTR(match_date, 1, 4)
        ORDER BY match_date ASC
        ROWS UNBOUNDED PRECEDING
    ) AS cumulative_points
FROM fact_matches 
WHERE competition = 'MLS Regular Season'