DROP TABLE IF EXISTS fact_goals;
CREATE TABLE fact_goals (
    match_date INTEGER NOT NULL
    , match_year INTEGER NOT NULL
    , match_month INTEGER NOT NULL
    , match_day INTEGER NOT NULL
    , opponent VARCHAR NOT NULL REFERENCES dim_opponent(opponent)
    , scored_by VARCHAR NOT NULL REFERENCES dim_player(player)
    , scored_at INTEGER NOT NULL
    , scored_at_extra_time INTEGER
    , assisted_by VARCHAR REFERENCES dim_player(player)
    , is_penalty_kick BOOLEAN NOT NULL
);
