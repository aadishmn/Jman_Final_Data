{{
    config(
        tags=['mart']
    )
}}

WITH UserProjects AS (
    SELECT 
        EXTRACT(MONTH FROM TO_DATE(ALLOCATION_START, 'DD-MM-YYYY')) AS StartMonth,
        EXTRACT(MONTH FROM TO_DATE(ALLOCATION_END, 'DD-MM-YYYY')) AS EndMonth,
        EMAIL
    FROM 
        {{ref("stg_allocateProjects")}}
    WHERE 
        TO_DATE(ALLOCATION_START, 'DD-MM-YYYY') BETWEEN TO_DATE('01-01-2020', 'DD-MM-YYYY') AND TO_DATE('31-12-2023', 'DD-MM-YYYY')
        AND TO_DATE(ALLOCATION_END, 'DD-MM-YYYY') BETWEEN TO_DATE('01-01-2020', 'DD-MM-YYYY') AND TO_DATE('31-12-2023', 'DD-MM-YYYY')
)

SELECT 
    StartMonth AS Month,
    COUNT(*) AS TotalAllocations,
    COUNT(DISTINCT EMAIL) AS UsersAssigned,
    ABS(COUNT(*) - COUNT(DISTINCT EMAIL)) AS Difference
FROM 
    UserProjects
GROUP BY 
    StartMonth
ORDER BY 
    Difference DESC
