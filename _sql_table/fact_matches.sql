DROP TABLE IF EXISTS fact_matches;
CREATE TABLE fact_matches (
    match_date INTEGER
    , competition VARCHAR NOT NULL REFERENCES dim_competition(competition)
    , opponent VARCHAR NOT NULL REFERENCES dim_opponent(opponent)
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
    , result CHARACTER(1)
);
