
-- 1a
SELECT first_name, last_name
FROM actor;

-- 1b
SELECT CONCAT (first_name," ",last_name) AS ACTOR_NAME
FROM actor;

 -- 2a 
SELECT actor_id, first_name, last_name
FROM actor
WHERE first_name = "JOE";
-- 2b
SELECT first_name, last_name
FROM actor
WHERE last_name LIKE '%GEN%';
-- 2c
SELECT last_name, first_name
FROM actor
WHERE last_name LIKE '%LI%';

-- 2d
SELECT country, country_id
FROM country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');
-- 3a
ALTER TABLE actor
ADD COLUMN description BLOB;
-- 3b
ALTER TABLE actor
DROP COLUMN description;
-- 4a
SELECT last_name, count(*)
FROM actor
GROUP BY last_name;
-- 4b
SELECT last_name, count(*)
FROM actor
GROUP BY last_name
HAVING count(*) >= 2;
-- 4c
UPDATE actor 
SET first_name = 'HARPO' 
WHERE first_name='GROUCHO'
AND last_name= 'WILLIAMS';
-- 4d
UPDATE actor 
SET first_name='GROUCHO' 
WHERE first_name='HARPO';
-- 5a
SHOW CREATE TABLE ADDRESS; 
-- 6a fix
SELECT first_name, last_name, address FROM staff
JOIN address ON staff.address_id=addres.address_id;
-- 6b
SELECT first_name, last_name, SUM(amount) AS 'Total Amount'
FROM staff
INNER JOIN payment
ON staff.staff_id= payment.staff_id
AND payment_date
LIKE '2005-08%'
GROUP BY staff.staff_id ;
-- 6c
SELECT title, COUNT(actor_id) AS 'ACTOR COUNT'
FROM film
JOIN film_actor ON film.film_id
WHERE film.film_id=film_actor.film_id
GROUP by title;
-- 6d
SELECT COUNT(inventory.film_id)
FROM inventory,film
WHERE film.title='Hunchback Impossible'
AND film.film_id=inventory.film_id;
-- 6e fix
SELECT first_name, last_name, SUM(amount) AS 'TOTAL AMOUNT'
FROM customer
JOIN payment ON customer.customer_id=payment.customer_id
WHERE customer.customer_id = payment.customer_id
GROUP by last_name
ORDER by last_name;

-- 7a

SELECT title
FROM film
WHERE title
LIKE 'K%' OR title LIKE 'Q%'
AND title IN
    (
    SELECT title
    FROM film
    WHERE language_id IN
        (
        SELECT language_id
        FROM language
        WHERE NAME ='English'
        )
    ); 
    
  -- 7b
  SELECT first_name, last_name
  FROM actor
  WHERE actor_id IN
	(
    SELECT film_actor.actor_id
    FROM film, film_actor
    WHERE film.title = 'ALONE TRIP' 
    AND film.film_id=film_actor.film_id);
    
    
-- 7c
   SELECT first_name, last_name, email 
   FROM customer, customer_list
   WHERE customer_list.country='CANADA'
   AND customer_list.ID=customer.customer_ID;
-- 7d
SELECT title AS 'family films'
FROM film
WHERE film_id in
(SELECT film.film_id
FROM film, film_category, category
WHERE category.name='Family'
AND film_category.category_id=category.category_id
AND film_category.film_id=film.film_id);



-- 7e
SELECT title, COUNT(rental.inventory_id) AS 'Rentals'
FROM rental, film, inventory
WHERE rental.inventory_id=inventory.inventory_id
AND film.film_id=inventory.film_id
GROUP By rental.inventory_id
ORDER By COUNT(rental.inventory_id) DESC;
-- 7f
SELECT store_id, SUM(payment.amount)
FROM payment, rental, staff
WHERE payment.rental_id=rental.rental_id
AND rental.staff_id=staff.staff_id
GROUP BY staff.store_id;
-- 7g
SELECT store.store_id,city.city,country.country 
FROM store,address,city,country 
WHERE store.address_id = address.address_id 
AND address.city_id = city.city_id 
AND city.country_id = country.country_id 
GROUP BY store.store_id;
-- 7h
SELECT category.name AS 'Genres',SUM(payment.amount) AS 'Revenue' 
FROM category,film_category,inventory,payment,rental 
WHERE category.category_id = film_category.category_id 
AND film_category.film_id = inventory.film_id 
AND inventory.inventory_id = rental.inventory_id 
AND rental.rental_id = payment.rental_id 
GROUP BY category.name 
ORDER BY  Revenue DESC limit 5;

-- 8a
CREATE VIEW HOMEWORK AS
SELECT category.name AS 'Genres',SUM(payment.amount) AS 'Revenue' 
FROM category,film_category,inventory,payment,rental 
WHERE category.category_id = film_category.category_id 
AND film_category.film_id = inventory.film_id 
AND inventory.inventory_id = rental.inventory_id 
AND rental.rental_id = payment.rental_id 
GROUP BY category.name 
ORDER BY  Revenue DESC limit 5;

SELECT * FROM HOMEWORK;

DROP VIEW homework;


