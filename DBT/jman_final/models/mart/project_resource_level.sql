WITH ProjectHours AS (
    SELECT
        tp.PID,
        SUM(ts.TOTAL_WEEK_HOURS) AS total_actual_hours
    FROM
        {{ref("stg_timesheet")}} ts
    JOIN
        {{ref("stg_allocateProjects")}} tp ON ts.PID = tp.PID
    GROUP BY
        tp.PID
),
ProjectDurations AS (
    SELECT
        PID,
        DATEDIFF('DAY', START_DATE, END_DATE) + 1 AS expected_duration_days
    FROM
        {{ref("stg_projects")}}
),
ProjectResourceStatus AS (
    SELECT
        ph.PID,
        ph.total_actual_hours,
        pd.expected_duration_days,
        CASE
            WHEN ph.total_actual_hours > pd.expected_duration_days * 40 * 8 THEN 'Over-Resourced'
            WHEN ph.total_actual_hours < pd.expected_duration_days * 40 * 8 THEN 'Under-Resourced'
            ELSE 'Optimally Resourced'
        END AS resource_status
    FROM
        ProjectHours ph
    JOIN
        ProjectDurations pd ON ph.PID = pd.PID
)
SELECT
    p.NAME AS Project_Name,
    p.CLIENT_NAME AS Client_Name,
    p.START_DATE AS Start_Date,
    p.END_DATE AS End_Date,
    prs.total_actual_hours AS Total_Actual_Hours,
    prs.expected_duration_days * 40 * 8 AS Expected_Total_Hours,
    prs.resource_status AS Resource_Status
FROM
    {{ref("stg_projects")}} p
JOIN
    ProjectResourceStatus prs ON p.PID = prs.PID
ORDER BY
    p.NAME
