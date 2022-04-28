DROP TABLE IF EXISTS dim_opponent;
CREATE TABLE dim_opponent (
    opponent VARCHAR PRIMARY KEY
    , opponent_nationality CHARACTER(2) NOT NULL
);
