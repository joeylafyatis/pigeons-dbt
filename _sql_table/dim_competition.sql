DROP TABLE IF EXISTS dim_competition;
CREATE TABLE dim_competition (
    competition VARCHAR PRIMARY KEY
    , is_competitive_match BOOLEAN NOT NULL
);
