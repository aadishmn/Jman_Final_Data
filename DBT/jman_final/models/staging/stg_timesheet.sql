WITH timesheet_data AS (
    SELECT
        pa.email,
        pa.PID,
        pa.start_period AS week_start,
        pa.end_period AS week_end,
        TO_DATE(p.start_date, 'DD-MM-YYYY') AS project_start_date,
        TO_DATE(p.end_date, 'DD-MM-YYYY') AS project_end_date,
        pa.activity,
        pa.comments,
        pa.mon,
        pa.tue,
        pa.wed,
        pa.thur,
        pa.fri,
        pa.sat,
        pa.sun,
        pa.flag,
        pa.mon + pa.tue + pa.wed + pa.thur + pa.fri + pa.sat + pa.sun AS total_week_hours
    FROM
        {{ source('JMAN', 'TIMESHEETSDATA3') }} pa
    JOIN
        {{ source('JMAN', 'PROJECTS2') }} p
    ON
        pa.PID = p.PID
)
SELECT 
    email,
    PID,
    week_start,
    week_end,
    project_start_date,
    project_end_date,
    activity,
    comments,
    mon,
    tue,
    wed,
    thur,
    fri,
    sat,
    sun,
    flag,
    total_week_hours,
    (total_week_hours - 40) AS hours_over_or_under
FROM timesheet_data
