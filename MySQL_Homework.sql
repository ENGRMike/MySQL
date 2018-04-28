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

UPDATE actor
set first_name = (case
	WHEN first_name = "HARPO" then "GROUCHO" ELSE "MUCHO GROUCHO"
    END)
WHERE actor_id=172;