SELECT * FROM country WHERE country LIKE 'A%a';
SELECT * FROM country WHERE country NOT LIKE '_____' AND country NOT LIKE '____' AND country NOT LIKE  '___' AND country NOT LIKE '__' AND country NOT LIKE '_' AND country  LIKE '%n';
SELECT * FROM film WHERE title NOT ILIKE '____' AND title ILIKE '%t%t%t%t%' OR title ILIKE 't%t%t%t'OR title ILIKE 't%t%t%t%' OR title ILIKE '%t%t%t%t';
SELECT * FROM film WHERE title LIKE 'C%' AND length > 90 AND rental_rate = 2.99;
