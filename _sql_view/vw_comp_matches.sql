DROP VIEW IF EXISTS vw_comp_matches;
CREATE VIEW vw_comp_matches AS 
SELECT
    fm.match_date 
    , fm.competition
    , fm.opponent
    , fm.stadium
    , fm.attendance
    , fm.referee
    , fm.is_home_match
    , fm.nycfc_goals
    , fm.nycfc_aggregate
    , fm.nycfc_penalties
    , fm.opponent_goals
    , fm.opponent_aggregate
    , fm.opponent_penalties
    , fm.result
FROM fact_matches AS fm 
    INNER JOIN dim_competition AS dc ON fm.competition = dc.competition
WHERE dc.is_competitive_match
;
