WITH projects_data AS (
    SELECT
        PID,
        client_name,
        name,
        TO_DATE(start_date, 'DD-MM-YYYY') AS start_date,
        TO_DATE(end_date, 'DD-MM-YYYY') AS end_date,
        DATEDIFF('day', TO_DATE(start_date, 'DD-MM-YYYY'), TO_DATE(end_date, 'DD-MM-YYYY')) AS duration
    FROM
        {{ source('JMAN','PROJECTS2') }}
)

SELECT 
    *,
    CASE 
        WHEN duration < 15 THEN 'Small Cap Project'
        WHEN duration >= 15 AND duration <= 60 THEN 'Mid Cap Project'
        ELSE 'Large Cap Project'
    END AS project_category
FROM 
    projects_data 
ORDER BY 
    PID
