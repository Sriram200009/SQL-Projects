WITH t1 AS (
  SELECT * 
  FROM get_fit_now_check_in
  WHERE membership_id LIKE '%48Z%'
    AND check_in_date = 20180109
),
t2 AS (
  SELECT id, person_id, name, membership_status
  FROM get_fit_now_member
  WHERE membership_status = 'gold'
),
t3 AS (
  SELECT * 
  FROM person
),
t4 AS (
  SELECT * 
  FROM drivers_license
  WHERE plate_number LIKE '%H42W%'
)
SELECT *
FROM t1
JOIN t2 ON t1.membership_id = t2.id
JOIN t3 ON t2.person_id = t3.id
JOIN t4 ON t3.license_id = t4.id;
