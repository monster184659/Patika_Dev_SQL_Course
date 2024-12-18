1.

SELECT COUNT(*) FROM film
WHERE length > ALL
(
SELECT AVG(length) FROM film
)

2.
SELECT COUNT(*) FROM film
WHERE rental_rate = ANY
(
SELECT MAX(rental_rate) FROM film
)	


3.
select title from film
where rental_rate =(select min(rental_rate)from film) and 
replacement_cost = (select min(replacement_cost) from film);


4.

SELECT customer_id FROM payment WHERE amount = (SELECT MAX(amount) from payment);


