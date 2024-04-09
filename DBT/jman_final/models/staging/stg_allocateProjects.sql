WITH projectAllocate_data AS (
    SELECT
        pa.email,
        pa.PID,
        p.name,
        TO_CHAR(TO_DATE(pa.allocation_start, 'YYYY-MM-DD'), 'DD-MM-YYYY') AS allocation_start,
        TO_CHAR(TO_DATE(pa.allocation_end, 'YYYY-MM-DD'), 'DD-MM-YYYY') AS allocation_end,
        DATEDIFF('day', TO_DATE(pa.allocation_start, 'YYYY-MM-DD'), TO_DATE(pa.allocation_end, 'YYYY-MM-DD')) AS allocation_duration
    FROM
        {{ source('JMAN', 'PROJECTASSIGNMENTSDATA2') }} pa
    JOIN
        {{ source('JMAN', 'PROJECTS2') }} p
    ON
        pa.PID = p.PID
)
SELECT * FROM projectAllocate_data
