{{
    config(
        tags=['mart']
    )
}}

WITH user_data AS (
    SELECT
        "EMAIL",
        "ROLE"
    FROM
        {{ref("stg_users")}}
),
feedback_data AS (
    SELECT
        "EMAIL",
        "ROLE"
    FROM
        {{ref("stg_feedback")}}
),
all_roles AS (
    SELECT DISTINCT
        "ROLE"
    FROM
        user_data
),
all_users AS (
    SELECT
        r."ROLE",
        u."EMAIL",
        CASE
            WHEN f."EMAIL" IS NULL THEN 1
            ELSE 0
        END AS "MISSING_FEEDBACK"
    FROM
        all_roles r
    LEFT JOIN
        user_data u ON r."ROLE" = u."ROLE"
    LEFT JOIN
        feedback_data f ON u."EMAIL" = f."EMAIL"
),
missing_feedback_count AS (
    SELECT
        "ROLE",
        SUM("MISSING_FEEDBACK") AS "MISSING_COUNT"
    FROM
        all_users
    GROUP BY
        "ROLE"
)
SELECT
    "ROLE",
    COALESCE("MISSING_COUNT", 0) AS "MISSING_COUNT"
FROM
    missing_feedback_count
ORDER BY
    "MISSING_COUNT"
