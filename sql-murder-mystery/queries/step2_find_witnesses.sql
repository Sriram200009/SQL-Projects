SELECT * 
FROM person
WHERE address_street_name = 'Northwestern Dr'
ORDER BY address_number DESC
LIMIT 1;

SELECT * 
FROM person
WHERE name LIKE '%Annabel%'
  AND address_street_name = 'Franklin Ave'
ORDER BY address_number DESC
LIMIT 1;
