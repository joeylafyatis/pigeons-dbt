DROP TABLE IF EXISTS dim_stadium;
CREATE TABLE dim_stadium (
    stadium VARCHAR PRIMARY KEY
    , location_city VARCHAR NOT NULL
    , location_state  VARCHAR
    , location_country CHARACTER(2) NOT NULL
);
