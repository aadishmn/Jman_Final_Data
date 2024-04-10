SELECT
    u.FIRST_NAME,
    u.LAST_NAME,
    u.EMAIL,
    u.GENDER,
    u.DOB_DD_MM_YYYY,
    u.USER_TYPE,
    u.ROLE,
    u.AGE,
    p.CLIENT_NAME,
    p.NAME AS PROJECT_NAME,
    p.START_DATE AS PROJECT_START_DATE,
    p.END_DATE AS PROJECT_END_DATE,
    p.DURATION AS PROJECT_DURATION,
    p.PROJECT_CATEGORY,
    ap.ALLOCATION_START,
    ap.ALLOCATION_END,
    ap.ALLOCATION_DURATION,
    t.WEEK_START,
    t.WEEK_END,
    t.ACTIVITY,
    t.COMMENTS,
    t.MON,
    t.TUE,
    t.WED,
    t.THUR,
    t.FRI,
    t.SAT,
    t.SUN,
    t.FLAG,
    t.TOTAL_WEEK_HOURS,
    t.HOURS_OVER_OR_UNDER,
    f.START_PERIOD AS FEEDBACK_START_PERIOD,
    f.END_PERIOD AS FEEDBACK_END_PERIOD,
    f.Q1,
    f.Q2,
    f.Q3,
    f.Q4,
    f.Q5,
    f.Q6,
    f.COMMENTS AS FEEDBACK_COMMENTS
FROM
    {{ref("stg_users")}} u
JOIN
    {{ref("stg_allocateProjects")}} ap ON u.EMAIL = ap.EMAIL
JOIN
    {{ref("stg_projects")}} p ON ap.PID = p.PID
LEFT JOIN
    {{ref("stg_timesheet")}} t ON p.PID = t.PID
LEFT JOIN
    {{ref("stg_feedback")}} f ON u.EMAIL = f.EMAIL
ORDER BY
    u.EMAIL, p.PID, t.WEEK_START, f.START_PERIOD
