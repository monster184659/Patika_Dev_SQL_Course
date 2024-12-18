SELECT DISTINCT replacement_cost FROM film;
SELECT COUNT(DISTINCT replacement_cost) FROM film;
SELECT COUNT( title = 'T%' AND rating = 'G' ) FROM film;
SELECT COUNT (country = '_____') FROM country;
SELECT COUNT( city = '%R' OR city = '%r') FROM city;
