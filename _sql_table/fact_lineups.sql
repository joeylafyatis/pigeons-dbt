DROP TABLE IF EXISTS fact_lineups;
CREATE TABLE fact_lineups (
    match_date INTEGER NOT NULL
    , match_year INTEGER NOT NULL
    , match_month INTEGER NOT NULL
    , match_day INTEGER NOT NULL
    , opponent VARCHAR NOT NULL REFERENCES dim_opponent(opponent)
    , player VARCHAR NOT NULL REFERENCES dim_player(player)
    , player_num INTEGER NOT NULL
    , is_starting_xi BOOLEAN NOT NULL
    , sub_for VARCHAR REFERENCES dim_player(player)
    , sub_off_at INTEGER
    , sub_off_at_extra_time INTEGER
    , sub_on_at INTEGER
    , sub_on_at_extra_time INTEGER
    , first_yellow_at INTEGER
    , first_yellow_at_extra_time INTEGER
    , second_yellow_at INTEGER
    , second_yellow_at_extra_time INTEGER
    , red_card_at INTEGER
    , red_card_at_extra_time INTEGER
    , PRIMARY KEY (match_date, opponent, player)
);
