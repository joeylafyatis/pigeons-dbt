DROP VIEW IF EXISTS vw_cumulative_ppg_by_mls_matchday;
CREATE VIEW vw_cumulative_ppg_by_mls_matchday AS 
SELECT 
    match_year AS mls_season
    , mls_matchday
    , cumulative_ppg
    , MAX(match_year) OVER () = match_year AS is_current_mls_season
FROM vw_mls_season
ORDER BY 1,2
;
