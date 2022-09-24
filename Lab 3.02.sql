USE sakila;
-- 1. How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT * from sakila.inventory;
select film_id from sakila.film where title = 'Hunchback Impossible';
select * from sakila.inventory where film_id = '439';

select *, COUNT(film_id) 
FROM sakila.inventory 
WHERE film_id = (select film_id from sakila.film where title = 'Hunchback Impossible');

-- Phillip's Answer for comparison
SELECT
	COUNT(t1.film_id) AS Inventory
    , t2.title
FROM
	inventory as t1
INNER JOIN sakila.film AS t2 ON t1.film_id = t2.film_id
WHERE t2.title = 'Hunchback Impossible'
;



-- 2. List all films whose length is longer than the average of all the films.
select * from sakila.nicer_but_slower_film_list;
select avg(length) from sakila.nicer_but_slower_film_list;

select * from sakila.nicer_but_slower_film_list where length > (select avg(length) from sakila.nicer_but_slower_film_list);

-- 3. Use subqueries to display all actors who appear in the film Alone Trip.
select actors from sakila.film_list where title = 'Alone Trip';

select * from sakila.actor where actor_id IN (3, 12, 13, 82, 100, 160, 167);
select film_id from sakila.film where title = 'Alone Trip';
select * from sakila.film_actor where film_id = 17;

select * from sakila.actor where actor_id IN (select actor_id from sakila.film_actor where film_id = (select film_id from sakila.film where title = 'Alone Trip'));

-- 4. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
select category_id from sakila.category where name = "family";
select film_id from sakila.film_category where category_id = 8;
select * from sakila.film;

select * from sakila.film where film_id in (select film_id 
	from sakila.film_category 
	where category_id = 
	(	select category_id 	
		from sakila.category 		
		where name = "family"));


-- 5. Get name and email from customers from Canada using subqueries. Do the same with joins. Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.

select * from customer_list where country = 'Canada';
select customer_id, first_name, last_name, email from sakila.customer;

select first_name, last_name, email from sakila.customer where customer_id IN (select ID from customer_list where country = 'Canada');

-- 6. Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.

select * from actor_info;
SELECT * from film_actor;

select actor_id, COUNT(distinct actor_id) FROM film_actor;
select * from actor_info WHERE actor_id = 1;



-- 7. Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments
select * from sakila.payment;
select * from sakila.customer;
select * from sakila.film;
select * from sakila.inventory;

select distinct(customer_id) from sakila.payment;
select *,  sum(amount) as test from sakila.payment group by customer_id order by test desc limit 1;
select * from sakila.payment where customer_id = 526 ;
select * from sakila.customer where customer_id = 526 ;

Select inventory.film_id, film.title, customer_id FROM rental
	left join inventory USING (inventory_id)
	left join film USING (film_id)
    where customer_id IN (select customer_id FROM
    (SELECT customer_id, SUM(amount) from payment group by customer_id
												order by sum(amount) desc limit 1) test);

-- 8. Customers who spent more than the average payments.
select avg(amount) from sakila.payment;
select * from sakila.payment where amount > 4.201;

select * from sakila.payment where amount > (select avg(amount) from sakila.payment);

SELECT * FROM sakila.film;
SELECT * FROM sakila.film_actor;
SELECT actor_id , count(film_actor.film_id);
