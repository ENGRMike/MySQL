USE sakila;

-- 1a Display the first and last names of all actors from the table "actor"
SELECT first_name, last_name from actor;

-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the collumn 'Actor Name'
SELECT CONCAT_WS(' ', first_name, last_name) AS Actor_Name 
FROM actor;

-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
SELECT * FROM actor WHERE first_name LIKE "JOE";

-- 2b. Find all actors whose last name contain the letters `GEN`:
SELECT * FROM actor WHERE last_name LIKE "%GEN%";

-- 2c. Find all actors whose last names contain the letters `LI`. This time, order the rows by last name and first name, in that order:
SELECT * FROM actor WHERE last_name LIKE "%LI%"
ORDER BY last_name, first_name ASC;

-- 2d. Using `IN`, display the `country_id` and `country` columns of the following countries: Afghanistan, Bangladesh, and China:
SELECT * FROM country 
WHERE country IN ("Afghanistan", "Bangladesh", "China");

-- 3a. Add a `middle_name` column to the table `actor`. Position it between `first_name` and `last_name`. Hint: you will need to specify the data type.
ALTER TABLE actor
ADD middle_name VARCHAR(64) AFTER first_name;
SELECT * FROM actor;

-- 3b. You realize that some of these actors have tremendously long last names. Change the data type of the `middle_name` column to `blobs`.
ALTER TABLE actor
MODIFY COLUMN middle_name BLOB;

-- 3c. Now delete the `middle_name` column.
ALTER TABLE actor
DROP COLUMN middle_name;

-- 4a. List the last names of actors, as well as how many actors have that last name.
SELECT last_name, COUNT(*) name_count FROM actor GROUP BY last_name;

-- 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
SELECT last_name, COUNT(*) name_count FROM actor GROUP BY last_name
HAVING COUNT(*)>1;

-- 4c. Oh, no! The actor `HARPO WILLIAMS` was accidentally entered in the `actor` table as `GROUCHO WILLIAMS`, the name of Harpo's second cousin's husband's yoga teacher. Write a query to fix the record.
UPDATE actor
SET first_name = 'HARPO'
WHERE first_name = 'GROUCHO' and last_name = 'WILLIAMS';

-- 4d. Perhaps we were too hasty in changing `GROUCHO` to `HARPO`. It turns out that `GROUCHO` was the correct name after all! In a single query, if the first name of the actor is currently `HARPO`, change it to `GROUCHO`. Otherwise, change the first name to `MUCHO GROUCHO`, as that is exactly what the actor will be with the grievous error. BE CAREFUL NOT TO CHANGE THE FIRST NAME OF EVERY ACTOR TO `MUCHO GROUCHO`, HOWEVER! (Hint: update the record using a unique identifier.)
UPDATE actor
set first_name = (case
	WHEN first_name = "HARPO" then "GROUCHO" ELSE "MUCHO GROUCHO"
    END)
WHERE actor_id=172;

-- 5a. You cannot locate the schema of the `address` table. Which query would you use to re-create it? 
SELECT * FROM information_schema.COLUMNS
WHERE TABLE_NAME ='address';

-- 6a. Use `JOIN` to display the first and last names, as well as the address, of each staff member. Use the tables `staff` and `address`:
SELECT * FROM staff s
JOIN address a ON s.address_id = a.address_id;

-- 6b. Use `JOIN` to display the total amount rung up by each staff member in August of 2005. Use tables `staff` and `payment`. 
SELECT s.first_name, s.last_name, SUM(p.amount) August_05_Totals FROM staff s
JOIN payment p ON s.staff_id = p.staff_id
WHERE p.payment_date LIKE "2005-08%"
GROUP BY p.staff_id;

-- 6c. List each film and the number of actors who are listed for that film. Use tables `film_actor` and `film`. Use inner join.
SELECT f.title, COUNT(actor_id) AS 'Actor Count'
FROM film_actor fa
JOIN film f ON fa.film_id = f.film_id
GROUP BY title asc;

-- 6d. How many copies of the film `Hunchback Impossible` exist in the inventory system?
SELECT COUNT(i.film_id) AS 'Inventory Count'
FROM inventory i
JOIN film f ON f.film_id = i.film_id
WHERE f.title LIKE "Hunchback Impossible";

-- 6e. Using the tables `payment` and `customer` and the `JOIN` command, list the total paid by each customer. List the customers alphabetically by last name:
SELECT first_name, last_name, SUM(amount) AS 'Total Payment'
FROM customer c
JOIN payment p on c.customer_id = p.customer_id
GROUP BY last_name, first_name
ORDER BY last_name asc;

-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters `K` and `Q` have also soared in popularity. Use subqueries to display the titles of movies starting with the letters `K` and `Q` whose language is English. 
SELECT title FROM film
WHERE language_id IN(
	SELECT language_id
    FROM language
    WHERE name = "English"
)
AND (title LIKE "K%" OR title LIKE "Q%")
ORDER BY title ASC;

-- 7b. Use subqueries to display all actors who appear in the film `Alone Trip`.
SELECT CONCAT(first_name, ' ', last_name) AS 'ACTORS' FROM actor
WHERE actor_id IN(
	SELECT actor_id
    FROM film_actor
    WHERE film_id IN(
		SELECT film_id
        FROM film
        WHERE title = "Alone Trip"
        )
);
    
 -- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
SELECT c.first_name, c.last_name, c.email, ci.city, co.country FROM customer c
join address a ON c.address_id = a.address_id
join city ci ON ci.city_id = a.city_id
join country co on co.country_id = ci.country_id
WHERE co.country = "Canada";

-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
SELECT title, rating, description FROM film
WHERE rating IN ('G', 'PG') AND Film_id IN(
	SELECT film_id
	FROM film_category
	WHERE category_id IN(
		SELECT category_id
		FROM category
		WHERE name = "Family")
        );
        
-- 7e. Display the most frequently rented movies in descending order.
SELECT title, COUNT(*) rentals FROM film f
JOIN inventory i on f.film_id = i.film_id
JOIN rental r on i.inventory_id = r.inventory_id
GROUP BY r.inventory_id
ORDER BY rentals desc;

-- 7f. Write a query to display how much business, in dollars, each store brought in.
SELECT s.store_id, a.address, ci.city, co.country, sum(p.amount)
FROM store s, staff st, payment p, address a, country co, city ci
WHERE s.store_id = st.store_id AND ci.city_id = a.city_id AND ci.country_id = co.country_id AND s.address_id = a.address_id AND st.staff_id = p.staff_id
GROUP BY st.store_id, a.address, ci.city, co.country;

-- 7g. Write a query to display for each store its store ID, city, and country.
SELECT s.store_id, a.address, ci.city, co.country
FROM store s, staff st, address a, country co, city ci
WHERE s.store_id = st.store_id AND ci.city_id = a.city_id AND ci.country_id = co.country_id AND s.address_id = a.address_id
GROUP BY st.store_id, a.address, ci.city, co.country;

-- 7h. List the top five genres in gross revenue in descending order
SELECT c.name, SUM(p.amount) AS 'gross revenue'
FROM film f, category c, film_category fc, inventory i, payment p, rental r
WHERE c.category_id = fc.category_id AND fc.category_id = f.film_id AND f.film_id = i.film_id AND i.inventory_id = r.inventory_id AND r.rental_id = p.rental_id
GROUP BY name
ORDER BY sum(p.amount) Desc LIMIT 5;

-- 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
CREATE VIEW top_five_genres AS
SELECT c.name, SUM(p.amount) AS 'gross revenue'
FROM film f, category c, film_category fc, inventory i, payment p, rental r
WHERE c.category_id = fc.category_id AND fc.category_id = f.film_id AND f.film_id = i.film_id AND i.inventory_id = r.inventory_id AND r.rental_id = p.rental_id
GROUP BY name
ORDER BY sum(p.amount) Desc LIMIT 5;

-- 8b. How would you display the view that you created in 8a?
SELECT * FROM top_five_genres;

-- 8c. You find that you no longer need the view `top_five_genres`. Write a query to delete it.
DROP VIEW top_five_genres;
