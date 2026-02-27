--Part 1: Basic Queries

-- 1.	Insert data using the attached .sql file. => Done

-- 2.	List the first and last names of all customers who live in Canada.
SELECT first_name , last_name
FROM customers
WHERE country = 'Canada';

--3 Show all orders placed in January 2023.
SELECT * 
FROM orders
WHERE order_date BETWEEN DATE '2023-01-01'
AND DATE '2023-01-31';

--4.	Retrieve the distinct product categories available in the database
SELECT DISTINCT category
FROM products;


--Part 2: Aggregation

--4.	Find the total number of orders placed by each customer.
SELECT c.customer_id,
c.first_name,
c.last_name,
COUNT(o.order_id) AS total_orders
FROM customers c
LEFT JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name , c.last_name
ORDER BY c.customer_id;

--5.Calculate the total revenue per product category.
SELECT p.category,
SUM(oi.quantity*oi.price) AS total_revenue
FROM order_items oi
JOIN products p
ON oi.product_id = p.product_id
GROUP BY p.category
ORDER BY p.category;

--6.	Determine the average order amount for each country.
SELECT c.country,
AVG(o.total_amount) AS avg_order_amount
FROM orders o
JOIN customers c
ON o.customer_id = c.customer_id
GROUP BY c.country
ORDER BY c.country;

--Part 3: Joins

--7.	Show all orders with the customer’s name and the total amount.
SELECT o.order_id,
c.first_name || ' ' || c.last_name AS customer_name,
SUM(oi.quantity * oi.price) AS total_amount
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY o.order_id,c.first_name, c.last_name;

--8.	List each product sold with the quantity and total revenue generated.
SELECT
p.product_name,
SUM(oi.quantity) AS total_quantity_sold,
SUM(oi.quantity * oi.price) AS total_revenue
FROM products p 
JOIN order_items oi
ON p.product_id = oi.product_id
GROUP BY p.product_name
ORDER BY total_revenue DESC;
--9.	Find the top 5 products by revenue.

SELECT* FROM(

SELECT
p.product_name,
SUM(oi.quantity) AS total_quantity_sold,
SUM(oi.quantity * oi.price) AS total_revenue
FROM products p
JOIN order_items oi
ON p.product_id = oi.product_id
GROUP BY p.product_name
ORDER BY total_revenue DESC
)
WHERE ROWNUM <= 5;

--Part 4: Filtering & Sorting

--10.	Show the 10 most recent orders along with customer names.

SELECT *FROM (
SELECT
o.order_id,
c.first_name || ' ' || c.last_name AS customer_name,
o.order_date,
o.total_amount
FROM orders o
JOIN customers c
ON o.customer_id  = c.customer_id
ORDER BY o.order_date DESC
)
WHERE ROWNUM <= 10;


--11.	List customers who have spent the most in total.

SELECT
c.customer_id,
c.first_name || ' ' || c.last_name AS customer_name,
SUM(o.total_amount) AS total_spent
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name , c.last_name
ORDER BY total_spent DESC;

--12 Find all products that have never been sold.
SELECT
p.product_id,
p.product_name,
p.category 
FROM products p 
LEFT JOIN order_items oi
ON p.product_id = oi.product_id
WHERE oi.product_id IS NULL;