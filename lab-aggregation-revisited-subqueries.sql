-- Select the first name, last name, and email address of all the customers who have rented a movie.
select concat(c.first_name,' ', c.last_name) as full_name, c.email
from sakila.customer c
join sakila.rental r 
using (customer_id)
group by full_name
having count(r.rental_id) >= 1;

-- What is the average payment made by each customer (display the customer id, customer name (concatenated), and the average payment made).
select c.customer_id, concat(c.first_name,' ', c.last_name) as full_name, avg(p.amount)
from sakila.customer c
join sakila.payment p 
using (customer_id)
group by customer_id;

-- Select the name and email address of all the customers who have rented the "Action" movies.
-- Write the query using multiple join statements
select concat(c.first_name,' ', c.last_name) as full_name, c.email
from sakila.customer c
join sakila.rental using (customer_id)
join sakila.inventory using (inventory_id)
join sakila.film using (film_id)
join sakila.film_category using (film_id)
join sakila.category ca using (category_id)
where ca.name = 'Action'
group by full_name, email;

-- Write the query using sub queries with multiple WHERE clause and IN condition
select concat(first_name,' ',last_name) as full_name, email
from sakila.customer where customer_id in (select rental_id from sakila.rental
where rental_id in (select inventory_id from sakila.inventory where inventory_id in
(select film_id from sakila.film_category where category_id in (select category_id 
from sakila.category where name = 'Action'))))
group by full_name, email;

-- Verify if the above two queries produce the same results or not
-- No, they do not produce the same results: using sub queries with multiple WHERE clause and IN condition produces substantially fewer results in comparisson to using multiple joins. 

-- Use the case statement to create a new column classifying existing columns as either or high value transactions based on the amount of payment. If the amount is between 0 and 2, label should be low and if the amount is between 2 and 4, the label should be medium, and if it is more than 4, then it should be high.
select payment_id, customer_id, staff_id, rental_id, amount,
case when amount between 0 and 2 then 'Low' 
when amount between 2 and 4 then 'Medium' 
when amount > 4 then 'High' end as 'transaction_value',
payment_date, last_update
from sakila.payment;

-- Another way of doing it with 3 new columns instead of 1:
select payment_id, customer_id, staff_id, rental_id, amount,
case when amount between 0 and 2 then amount end as 'Low',
case when amount between 2 and 4 then amount end as 'Medium',
case when amount > 4 then amount end as 'High',
payment_date, last_update
from sakila.payment;