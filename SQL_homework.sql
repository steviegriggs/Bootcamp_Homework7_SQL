use sakila;

-- Question 1

-- Part A: Display the first and last names of all actors from the table actor.
SELECT
	first_name,
    last_name
FROM 
	sakila.actor;

-- Part B: Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.

SELECT 
	CONCAT(first_name,' ', last_name) 
AS 
	'Actor Name' 
FROM 
	sakila.actor;


-- Question 2
-- Part A: You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." 
-- 			What is one query would you use to obtain this information?


SELECT
	actor_id,
    first_name,
    last_name
FROM
	actor
WHERE
	first_name = 'Joe';
    
-- Part B: Find all actors whose last name contain the letters GEN:

SELECT 
	*
FROM 
	actor
WHERE
	last_name like '%GEN%';


-- Part C: Find all actors whose last names contain the letters LI. 
-- 			This time, order the rows by last name and first name, in that order:

SELECT 
	*
FROM 
	actor
WHERE
	last_name like '%LI%'
ORDER BY
	last_name ASC,
    first_name ASC;
    
-- Part D: Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
SELECT  country_id, country 
FROM country 
WHERE country 
IN ('Afghanistan', 'Bangladesh', 'China');



-- Question 3:

-- Part A: You want to keep a description of each actor. 
-- 		You don't think you will be performing queries on a description, 
-- 		so create a column in the table actor named description and use the data type BLOB
ALTER TABLE actor
ADD Description BLOB;

SELECT * FROM actor LIMIT 1;

-- Part B: Very quickly you realize that entering descriptions for each actor is too much effort. Delete the description column.

ALTER TABLE actor
DROP COLUMN Description;

SELECT * FROM actor LIMIT 1;


-- Question 4

-- Part A: List the last names of actors, as well as how many actors have that last name.
SELECT 
	last_name, COUNT(last_name)
AS
	'Number of Actors with Last Name'
FROM 
	actor
GROUP BY
	last_name;    

-- Part B: List last names of actors and the number of actors who have that last name, 
-- 			but only for names that are shared by at least two actors

SELECT 
	last_name, COUNT(last_name)
AS
	'Number of Actors with Last Name'
FROM 
	actor
GROUP BY
	last_name
HAVING
	COUNT(last_name) >= 2;


-- Part C: The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. 
-- 			Write a query to fix the record.



UPDATE 
	actor
SET 
	first_name = 'HARPO'
WHERE
	first_name = 'GROUCHO' AND last_name = 'Williams';



-- Part D: Perhaps we were too hasty in changing GROUCHO to HARPO. 
-- 			It turns out that GROUCHO was the correct name after all! 
-- 			In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO.

UPDATE 
	actor
SET 
	first_name = 'GROUCHO'
WHERE
	 first_name = 'HARPO';


-- Question 5

-- Part A: You cannot locate the schema of the address table. Which query would you use to re-create it?

SHOW CREATE TABLE sakila.address;
DESCRIBE sakila.address;



-- Question 6

-- Part A: Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:

SELECT 
	s.first_name, 
    s.last_name,
    a.address 
FROM 
	staff s
JOIN 
	address a
ON 
	(s.address_id = a.address_id);

-- Part B: Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.

SELECT 
	s.first_name, 
    s.last_name,
    SUM(p.amount)
AS
	'Sales in August 2005'
FROM 
	staff s
JOIN 
	payment p
ON 
	(s.staff_id = p.staff_id)
WHERE 
	YEAR(p.payment_date) = 2005 AND MONTH(p.payment_date) = 8
GROUP BY
	s.staff_id;


-- Part C: List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
describe film;

SELECT 
	f.title, 
    COUNT(fa.actor_id)
AS
	'Number of Actors'
FROM 
	film f
JOIN 
	film_actor fa
ON 
	(f.film_id = fa.film_id)
GROUP BY
	f.film_id;

-- Part D: How many copies of the film Hunchback Impossible exist in the inventory system?


SELECT 
	f.title, 
    COUNT(i.inventory_id)
AS
	'Number of Copies in Inventory'
FROM 
	film f
JOIN 
	inventory i
ON 
	(f.film_id = i.film_id)
WHERE
	f.title = 'Hunchback Impossible';


-- Part E: Using the tables payment and customer and the JOIN command, list the total paid by each customer. 
-- 			List the customers alphabetically by last name:


SELECT 
	c.last_name, 
    c.first_name,
    SUM(p.amount)
AS
	'Total Paid'
FROM 
	customer c
JOIN 
	payment p
ON 
	(c.customer_id = p.customer_id)
GROUP BY
	p.customer_id
ORDER BY
	last_name ASC;
    




-- Question 7

-- Part A: The music of Queen and Kris Kristofferson have seen an unlikely resurgence. 
-- 			As an unintended consequence, films starting with the letters K and Q have also soared in popularity. 
-- 			Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.

SELECT 
	title, 
    (SELECT 
		name
	FROM 	
		language l
	WHERE 
		(f.language_id = l.language_id) AND (l.name = 'english'))
AS 
	'Language'
FROM 
	film f
WHERE 
	f.title like 'K%' OR f.title like 'Q%';


-- Part B: Use subqueries to display all actors who appear in the film Alone Trip.


SELECT
	a.first_name,
    a.last_name
FROM
	actor a
WHERE
	a.actor_id IN (SELECT
					fa.actor_id
				FROM
					film_actor fa
				WHERE
					fa.film_id = (SELECT
									f.film_id
								FROM
									film f
								WHERE
									f.title = 'Alone Trip'));




-- Part C: You want to run an email marketing campaign in Canada, 
-- 			for which you will need the names and email addresses of all Canadian customers. 
--  		Use joins to retrieve this information.


SELECT
	c.first_name,
    c.last_name,
    c.email
FROM
	customer c 
JOIN
	address a
ON
	c.address_id = a.address_id
JOIN
	city c2
ON
	a.city_id = c2.city_id
JOIN
	country c3
ON
	c2.country_id = c3.country_id
WHERE
	c3.country = 'Canada'; 




-- Part D: Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
-- 			Identify all movies categorized as family films.


-- Using Joins
SELECT 
	f.title
AS
	'Family Films'
FROM 
	film f
JOIN
	film_category fc
ON
	f.film_id = fc.film_id
JOIN
	category c
ON
	fc.category_id = c.category_id
WHERE
	c.name = 'family';
    
-- using subqueries
SELECT
	title
AS
	'Family Films'
FROM
	film f
WHERE
	f.film_id IN (SELECT
					fc.film_id
				FROM
					film_category fc
				WHERE
					fc.category_id = (SELECT
										c.category_id
									FROM 
										category c
									WHERE
										c.name = 'family'));
	



-- Part E: Display the most frequently rented movies in descending order.

SELECT 
	f.title, 
    COUNT(r.rental_id)
AS
	'Number of Times Rented'
FROM 
	rental r
JOIN 
	inventory i
ON 
	(r.inventory_id = i.inventory_id)
JOIN
	film f
ON
	(i.film_id = f.film_id)
GROUP BY
	f.film_id
ORDER BY
	COUNT(r.rental_id) DESC;
    


-- Part F: Write a query to display how much business, in dollars, each store brought in.

SELECT
	s.store_id,
    SUM(p.amount)
AS
	'Total Sales (in dollars)'
FROM
	store s
JOIN
	staff s1
ON
	s.store_id = s1.store_id
JOIN
	payment p
ON
	s1.staff_id = p.staff_id
GROUP BY
	s.store_id;




-- Part G: Write a query to display for each store its store ID, city, and country.


SELECT
	s.store_id,
    c.city,
    c1.country
FROM 
	store s
JOIN
	address a
ON 
	s.address_id = a.address_id
JOIN
	city c
ON 
	a.city_id = c.city_id
JOIN
	country c1
ON
	c.country_id = c1.country_id;
    



-- Part H: List the top five genres in gross revenue in descending order. 


SELECT
	c.name,
    SUM(p.amount)
AS
	'Gross Revenue'
FROM
	category c
JOIN
	film_category fa
ON 
	c.category_id = fa.category_id
JOIN
	inventory i
ON
	fa.film_id = i.film_id
JOIN
	rental r
ON
	i.inventory_id = r.inventory_id
JOIN
	payment p
ON
	r.rental_id = p.rental_id
GROUP BY
	c.name
ORDER BY
	SUM(p.amount) DESC
LIMIT
	5;




-- Question 8

-- Part A: In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. 
-- 			Use the solution from the problem above to create a view. 
-- 			If you haven't solved 7h, you can substitute another query to create a view.

create view Sales_by_Genre as
SELECT
	c.name,
    SUM(p.amount)
AS
	'Gross Revenue'
FROM
	category c
JOIN
	film_category fa
ON 
	c.category_id = fa.category_id
JOIN
	inventory i
ON
	fa.film_id = i.film_id
JOIN
	rental r
ON
	i.inventory_id = r.inventory_id
JOIN
	payment p
ON
	r.rental_id = p.rental_id
GROUP BY
	c.name
ORDER BY
	SUM(p.amount) DESC
LIMIT
	5;





-- Part B: How would you display the view that you created in 8a?
SELECT
	*
FROM
	Sales_by_Genre;

-- Part C: You find that you no longer need the view top_five_genres. Write a query to delete it.
DROP VIEW Sales_by_Genre;
	
