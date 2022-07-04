DROP TABLE IF EXISTS fact_matches;
CREATE TABLE fact_matches (
    match_date INTEGER NOT NULL
    , match_year INTEGER NOT NULL
    , match_month INTEGER NOT NULL
    , match_day INTEGER NOT NULL
    , competition VARCHAR NOT NULL
    , opponent VARCHAR NOT NULL REFERENCES dim_opponent(opponent)
    , manager VARCHAR REFERENCES dim_manager(manager)
    , stadium VARCHAR REFERENCES dim_stadium(stadium)
    , attendance INTEGER
    , referee VARCHAR
    , is_home_match BOOLEAN NOT NULL
    , nycfc_goals INTEGER NOT NULL
    , nycfc_aggregate INTEGER
    , nycfc_penalties INTEGER
    , opponent_goals INTEGER NOT NULL
    , opponent_aggregate INTEGER
    , opponent_penalties INTEGER
    , result CHARACTER(1) NOT NULL
    , PRIMARY KEY (match_date, opponent)
);
