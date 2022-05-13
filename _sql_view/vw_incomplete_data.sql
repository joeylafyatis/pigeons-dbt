DROP VIEW IF EXISTS vw_incomplete_data;
CREATE VIEW vw_incomplete_data AS 
WITH incomplete_consolidated AS (
    SELECT
        match_date
        , opponent
        , 'stadium' AS missing_field
    FROM fact_matches 
    WHERE stadium IS NULL

    UNION ALL 

    SELECT
        match_date
        , opponent
        , 'attendance' AS missing_field
    FROM fact_matches 
    WHERE attendance IS NULL

    UNION ALL 

    SELECT
        match_date
        , opponent
        , 'referee' AS missing_field
    FROM fact_matches 
    WHERE referee IS NULL
),
incomplete_aggregated AS (
    SELECT 
        match_date 
        , opponent 
        , GROUP_CONCAT(missing_field, '; ') AS missing_fields
    FROM incomplete_consolidated
    GROUP BY 1,2
)
SELECT 
    ia.missing_fields 
    , fm.*
FROM incomplete_aggregated AS ia 
    INNER JOIN fact_matches AS fm 
        ON ia.match_date = fm.match_date 
        AND ia.opponent = fm.opponent
;
