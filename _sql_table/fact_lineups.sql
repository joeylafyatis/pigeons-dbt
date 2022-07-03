DROP TABLE IF EXISTS fact_lineups;
CREATE TABLE fact_lineups (
    match_date INTEGER NOT NULL
    , match_year INTEGER NOT NULL
    , match_month INTEGER NOT NULL
    , match_day INTEGER NOT NULL
    , opponent VARCHAR NOT NULL REFERENCES dim_opponent(opponent)
    , player VARCHAR NOT NULL REFERENCES dim_player(player)
    , is_starting_xi BOOLEAN NOT NULL
    , PRIMARY KEY (match_date, opponent, player)
);
