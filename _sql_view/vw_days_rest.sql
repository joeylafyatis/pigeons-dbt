DROP VIEW IF EXISTS vw_days_rest;
CREATE VIEW vw_days_rest AS 
WITH prep_matches AS (
    SELECT
        match_date
        , match_year 
        , ROW_NUMBER() OVER (ORDER BY match_date ASC) AS row_num
        , JULIANDAY(match_year||'-'||SUBSTR('0'||match_month, -2)||'-'||SUBSTR('0'||match_day, -2)) AS julian_day
    FROM fact_matches
)
SELECT
    p1.match_date
    , CAST((p1.julian_day - p2.julian_day) AS INTEGER) - 1 AS days_rest
FROM prep_matches AS p1
    LEFT JOIN prep_matches AS p2
        ON p1.match_year = p2.match_year 
        AND p1.row_num = (p2.row_num + 1)
WHERE p2.match_year IS NOT NULL
;
