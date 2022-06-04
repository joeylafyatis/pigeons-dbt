DROP VIEW IF EXISTS vw_stats_by_mls_season;
CREATE VIEW vw_stats_by_mls_season AS 
WITH mls_by_season AS (
    SELECT 
        match_year AS mls_season
        , COUNT(1) AS matches_played
        , SUM(CASE WHEN result = 'W' THEN 1 END) AS wins
        , SUM(CASE WHEN result = 'D' THEN 1 END) AS draws
        , SUM(CASE WHEN result = 'L' THEN 1 END) AS losses
        , SUM(points) AS points
        , SUM(nycfc_goals) AS goals_for
        , SUM(opponent_goals) AS goals_against
        , SUM(CASE WHEN opponent_goals = 0 THEN 1 END) AS clean_sheats
        , SUM(CASE WHEN nycfc_goals = 0 THEN 1 END) AS clean_sheats_against
        -- HOME
        , COUNT(CASE WHEN is_home_match THEN 1 END) AS matches_played_home
        , SUM(CASE WHEN is_home_match AND result = 'W' THEN 1 END) AS wins_home
        , SUM(CASE WHEN is_home_match AND result = 'D' THEN 1 END) AS draws_home
        , SUM(CASE WHEN is_home_match AND result = 'L' THEN 1 END) AS losses_home
        , SUM(CASE WHEN is_home_match THEN points END) AS points_home
        , SUM(CASE WHEN is_home_match THEN nycfc_goals END) AS goals_for_home
        , SUM(CASE WHEN is_home_match THEN opponent_goals END) AS goals_against_home
        , SUM(CASE WHEN is_home_match AND opponent_goals = 0 THEN 1 END) AS clean_sheats_home
        , SUM(CASE WHEN is_home_match AND nycfc_goals = 0 THEN 1 END) AS clean_sheats_against_home
        -- AWAY
        , COUNT(CASE WHEN NOT is_home_match THEN 1 END) AS matches_played_away
        , SUM(CASE WHEN NOT is_home_match AND result = 'W' THEN 1 END) AS wins_away
        , SUM(CASE WHEN NOT is_home_match AND result = 'D' THEN 1 END) AS draws_away
        , SUM(CASE WHEN NOT is_home_match AND result = 'L' THEN 1 END) AS losses_away
        , SUM(CASE WHEN NOT is_home_match THEN points END) AS points_away
        , SUM(CASE WHEN NOT is_home_match THEN nycfc_goals END) AS goals_for_away
        , SUM(CASE WHEN NOT is_home_match THEN opponent_goals END) AS goals_against_away
        , SUM(CASE WHEN NOT is_home_match AND opponent_goals = 0 THEN 1 END) AS clean_sheats_away
        , SUM(CASE WHEN NOT is_home_match AND nycfc_goals = 0 THEN 1 END) AS clean_sheats_against_away
    FROM vw_mls_season
    GROUP BY 1
)
SELECT         
    mls_season
    , matches_played
    , wins
    , draws
    , losses
    , points
    , ROUND(points / CAST(matches_played AS FLOAT), 2) AS points_per_game
    , ROUND(wins / CAST(matches_played AS FLOAT), 2) AS win_percentage
    , ROUND((wins + draws) / CAST(matches_played AS FLOAT), 2) AS unbeaten_percentage
    , goals_for
    , goals_against
    , goals_for - goals_against AS goal_diff
    , ROUND(goals_for / CAST(matches_played AS FLOAT), 2) AS goals_for_per_game
    , ROUND(goals_against / CAST(matches_played AS FLOAT), 2) AS goals_against_per_game
    , ROUND((goals_for - goals_against) / CAST(matches_played AS FLOAT), 2) AS goal_diff_per_game
    , clean_sheats
    , clean_sheats_against
    -- HOME
    , matches_played_home
    , wins_home
    , IFNULL(draws_home, 0) AS draws_home
    , losses_home
    , points_home
    , ROUND(points_home / CAST(matches_played_home AS FLOAT), 2) AS points_per_game_home
    , ROUND(wins_home / CAST(matches_played_home AS FLOAT), 2) AS win_percentage_home
    , ROUND((wins_home + draws_home) / CAST(matches_played_home AS FLOAT), 2) AS unbeaten_percentage_home
    , goals_for_home
    , goals_against_home
    , goals_for_home - goals_against_home AS goal_diff_home
    , ROUND(goals_for_home / CAST(matches_played_home AS FLOAT), 2) AS goals_for_per_game_home
    , ROUND(goals_against_home / CAST(matches_played_home AS FLOAT), 2) AS goals_against_per_game_home
    , ROUND((goals_for_home - goals_against_home) / CAST(matches_played_home AS FLOAT), 2) AS goal_diff_per_game_home
    , clean_sheats_home
    , clean_sheats_against_home
    -- AWAY
    , matches_played_away
    , wins_away
    , draws_away
    , losses_away
    , points_away
    , ROUND(points_away / CAST(matches_played_away AS FLOAT), 2) AS points_per_game_away
    , ROUND(wins_away / CAST(matches_played_away AS FLOAT), 2) AS win_percentage_away
    , ROUND((wins_away + draws_away) / CAST(matches_played_away AS FLOAT), 2) AS unbeaten_percentage_away
    , goals_for_away
    , goals_against_away
    , goals_for_away - goals_against_away AS goal_diff_away
    , ROUND(goals_for_away / CAST(matches_played_away AS FLOAT), 2) AS goals_for_per_game_away
    , ROUND(goals_against_away / CAST(matches_played_away AS FLOAT), 2) AS goals_against_per_game_away
    , ROUND((goals_for_away - goals_against_away) / CAST(matches_played_away AS FLOAT), 2) AS goal_diff_per_game_away
    , clean_sheats_away
    , clean_sheats_against_away
FROM mls_by_season
;
