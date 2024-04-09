WITH RECURSIVE calendar_months AS (
    SELECT DATE_TRUNC('month', DATE_ADD(CURRENT_DATE(), INTERVAL -1 YEAR)) AS month_start
    UNION ALL
    SELECT DATE_ADD(month_start, INTERVAL 1 MONTH) AS month_start
    FROM calendar_months
    WHERE month_start < CURRENT_DATE()
),
project_allocation AS (
    SELECT
        "EMAIL",
        TO_DATE(ALLOCATION_START, 'DD-MM-YYYY') AS ALLOCATION_START_DATE,
        TO_DATE(ALLOCATION_END, 'DD-MM-YYYY') AS ALLOCATION_END_DATE
    FROM
        stg_allocateProjects
),
allocated_dates AS (
    SELECT DISTINCT
        "EMAIL",
        DATE_TRUNC('month', ALLOCATION_START_DATE) AS month_start,
        DATE_TRUNC('month', ALLOCATION_END_DATE) AS month_end
    FROM
        project_allocation
),
unallocated_months AS (
    SELECT
        m.month_start,
        COUNT(DISTINCT a."EMAIL") AS unallocated_count
    FROM
        calendar_months m
    LEFT JOIN
        allocated_dates a
    ON
        m.month_start BETWEEN a.month_start AND a.month_end
    WHERE
        a."EMAIL" IS NULL
    GROUP BY
        m.month_start
)
SELECT
    TO_CHAR(month_start, 'YYYY-MM') AS month,
    unallocated_count
FROM
    unallocated_months
ORDER BY
    month_start;
