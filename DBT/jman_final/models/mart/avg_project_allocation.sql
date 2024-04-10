{{
    config(
        tags=['mart']
    )
}}

WITH UserProjects AS (
    SELECT DISTINCT EMAIL, PID
    FROM {{ref("stg_allocateProjects")}}
),
ProjectsPerUser AS (
    SELECT 
        EMAIL,
        COUNT(PID) AS NumProjects
    FROM 
        UserProjects
    GROUP BY 
        EMAIL
),
TotalUsers AS (
    SELECT 
        COUNT(DISTINCT EMAIL) AS TotalUsers
    FROM 
        UserProjects
),
TotalProjects AS (
    SELECT 
        COUNT(*) AS TotalProjects
    FROM 
        {{ref("stg_projects")}}
)
SELECT 
    TotalProjects / TotalUsers AS Avg_allocation
FROM 
    TotalUsers, TotalProjects
