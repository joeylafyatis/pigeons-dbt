DROP TABLE IF EXISTS dim_player;
CREATE TABLE dim_player (
    player VARCHAR PRIMARY KEY
    , player_nationality CHARACTER(2) NOT NULL
);
