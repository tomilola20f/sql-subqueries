use sakila;

#How many copies of the film Hunchback Impossible exist in the inventory system?
select * from inventory;
select * from film;

select count(inventory_id) copies 
from inventory
where film_id in (select film_id from (select film_id from film 
where title like 'HUNCHBACK IMPOSSIBLE') sub1);
# there are 6 copies of the film HUNCHBACK IMPOSSIBLE.

#List all films whose length is longer than the average of all the films.
select * from film;

select film_id,title,length from film 
where length > (select avg(length) from film);

#Use subqueries to display all actors who appear in the film Alone Trip.
select * from actor;
select * from film_actor;
select * from film; 

select first_name, last_name from actor
where actor_id in (select actor_id from film_actor
where film_id in (select film_id from film 
where title like 'Alone Trip'));
# there are 8 actors in the film 'Alone Trip'

#Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films
select * from category;
select * from film_category;
select * from film;

select title from film where film_id in(select film_id from film_category 
where category_id = (select category_id from category 
where name = 'Family'));

#Get name and email from customers from Canada using subqueries. Do the same with joins. Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.
select * from country;
select * from city;

select concat(first_name,'',last_name)name, email from customer where address_id in (select address_id from address
where city_id in (select city_id from city 
where country_id =(select country_id from country 
where country = 'Canada'))); #for subqueries 

#using join
select concat (c.first_name,'',c.last_name)name,c.email from customer c
join address a on c.address_id = a.address_id 
join city ct on a.city_id = ct.city_id 
join country co on ct.country_id = co.country_id where co.country = 'Canada';

#Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.
select * from actor;


select title from film where film_id in (select film_id from film_actor 
where actor_id = (select actor_id from (select count(actor_id) film_appearances, actor_id 
from film_actor
group by actor_id order by 1 desc limit 1) temp));

#Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments

select title from film where film_id in ( select film_id from inventory where inventory_id in (select inventory_id
from rental where customer_id = (select customer_id from (select customer_id, sum(amount) from payment
group by customer_id
order by 2 desc limit 1) temp_2)));

#Get the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client.

select customer_id as client_id, sum(amount) as total_amount_spent from payment
group by client_id
having total_amount_spent > (select avg(total)
from (select customer_id, sum(amount)total from payment 
group by customer_id) temp_3); 