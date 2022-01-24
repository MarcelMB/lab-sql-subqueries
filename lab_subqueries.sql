USE sakila;

-- 1. How many copies of the film Hunchback Impossible exist in the inventory system?

SELECT count(inventory_id) AS copies_of_Hunchback FROM inventory
WHERE film_ID= ( 
SELECT film_id FROM film
WHERE title= 'Hunchback Impossible'
);

-- 2. List all films whose length is longer than the average of all the films.

SELECT film_id, title, length FROM film
WHERE length > (
SELECT avg(length) FROM film
);

-- 3. Use subqueries to display all actors who appear in the film Alone Trip.

SELECT actor_id, film_id FROM film_actor
WHERE film_id= (
SELECT film_id from film
WHERE title='alone trip'
);

-- 4. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.

SELECT film_id, category_id FROM film_category
WHERE category_id = (
SELECT category_id FROM category
WHERE name='family'
);

-- 5. Get name and email from customers from Canada using subqueries. Do the same with joins. Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.

-- using a join
SELECT first_name, last_name, email FROM customer
JOIN address a
USING(address_ID)
JOIN city ci
USING(city_id) 
JOIN country co
USING(country_id)
WHERE country='canada';

-- using subqueries
 
SELECT first_name, last_name, email FROM customer
WHERE address_id IN(
					SELECT address_id FROM address
					WHERE city_id IN (
									SELECT city_id FROM city
									WHERE country_id = (
														SELECT country_id FROM country
														WHERE country='canada'
														)));

-- 6. Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. 
-- First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.


SELECT title, film_id FROM film 
WHERE film_id IN (

SELECT film_id FROM film_actor
WHERE actor_id = (

SELECT actor_ID  FROM (
SELECT count(film_id) AS number_of_films ,actor_id 
FROM film_actor
GROUP BY actor_id
ORDER BY number_of_films DESC
LIMIT 1) sub1
));


-- 7. Films rented by most profitable customer. 
-- You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments


SELECT title, film_id FROM film
WHERE film_id IN (

SELECT  DISTINCT film_id FROM inventory
WHERE inventory_id IN (

SELECT inventory_ID FROM rental
WHERE customer_id = (

SELECT customer_id  FROM (
SELECT sum(amount) AS income, customer_id FROM payment
GROUP BY customer_id
ORDER BY income DESC
LIMIT 1
) sub1
)));

-- 8. Customers who spent more than the average payments.

-- compare average for each customer to average of general payments


SELECT customer_id FROM (
SELECT customer_id, AVG(amount) AS average FROM payment
GROUP BY customer_id
HAVING average > (SELECT avg(amount) FROM payment)
) sub1
;









