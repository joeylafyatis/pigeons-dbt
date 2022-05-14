DROP TABLE IF EXISTS fact_lineups;
CREATE TABLE fact_lineups (
    match_date INTEGER NOT NULL
    , match_year INTEGER NOT NULL
    , match_month INTEGER NOT NULL
    , match_day INTEGER NOT NULL
    , opponent VARCHAR NOT NULL REFERENCES dim_opponent(opponent)
    , player_name VARCHAR NOT NULL REFERENCES dim_player(player)
    , is_starter BOOLEAN NOT NULL
    , substitution_for VARCHAR REFERENCES dim_player(player)
    , substitution_off_at INTEGER
    , substitution_on_at INTEGER
    , yellow_card_at INTEGER
    , red_card_at INTEGER
);
