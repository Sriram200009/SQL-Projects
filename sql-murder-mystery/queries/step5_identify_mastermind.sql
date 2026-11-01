-- Step 5a: read the killer's own interview for the next clue
SELECT *
FROM interview
WHERE person_id = 67318;  -- Jeremy Bowers

-- Step 5b: match the description (red-haired woman, Tesla Model S,
-- attended the SQL Symphony Concert 3 times in Dec 2017)
WITH t1 AS (
  SELECT * 
  FROM drivers_license
  WHERE car_model in ('Model S')
  and 
  car_make in ('Tesla')
  and gender = 'female'
  and hair_color in ('red')
),
t3 AS (
  SELECT * 
  FROM person
),
t2 AS (
SELECT person_id, event_name, COUNT(event_id) AS event_count
FROM facebook_event_checkin
WHERE CAST(date AS TEXT) LIKE '2017%'
  AND event_name = 'SQL Symphony Concert'
GROUP BY person_id, event_name
HAVING COUNT(event_id) = 3)

SELECT *
FROM t1 
join t3 on t1.id = t3.license_id
join t2 on t3.id = t2.person_id;
