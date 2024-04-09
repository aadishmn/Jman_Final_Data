WITH users_data AS (
    SELECT
        first_name,
        last_name,
        email,
        gender,
        TO_CHAR(TO_DATE(DOB, 'YYYY-MM-DD'), 'DD-MM-YYYY') AS dob_dd_mm_yyyy,
        CASE 
            WHEN is_Admin = 'TRUE' THEN 'Admin'
            ELSE 'User'
        END AS user_type,
        role,
        EXTRACT(YEAR FROM CURRENT_DATE()) - EXTRACT(YEAR FROM TO_DATE(DOB, 'YYYY-MM-DD')) AS age
    FROM
        {{ source('JMAN', 'USERSDATA2') }}
)
SELECT * FROM users_data
