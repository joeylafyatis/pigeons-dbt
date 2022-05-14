DROP TABLE IF EXISTS dim_manager;
CREATE TABLE dim_manager (
    manager VARCHAR PRIMARY KEY
    , manager_nationality CHARACTER(2) NOT NULL
    , start_date INTEGER NOT NULL
    , end_date INTEGER
);
