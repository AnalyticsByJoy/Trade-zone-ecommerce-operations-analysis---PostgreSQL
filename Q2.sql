--PART B----------------------------------------------------------------------------------------------------------
--BUSINESS QUESTIONS SQL---------------------------------------------------------
--QUESTION 2: Product Performance
--Identify the top 10 products by total revenue in 2024.Include product name, category, total revenue and total number of orders. 
--Sort by revenue descending
SELECT p.product_name, p.category,
SUM(oi.line_total) AS total_revenue,
COUNT(DISTINCT oi.order_id) AS total_number_of_orders
FROM order_items oi 
JOIN orders o
ON oi.order_id = o.order_id
JOIN products p
ON oi.product_id = p.product_id
WHERE o.order_date BETWEEN '2024-01-01' AND '2024-12-31'
GROUP BY p.product_name, p.category
ORDER BY total_revenue DESC
LIMIT 10;

--NOticed some products had NULL values in total revenue 
--so i used COALESCE 
SELECT p.product_name, p.category,
COALESCE(SUM(oi.line_total), 0) AS total_revenue,
COUNT(DISTINCT oi.order_id) AS total_number_of_orders
FROM order_items oi 
JOIN orders o
ON oi.order_id = o.order_id
JOIN products p
ON oi.product_id = p.product_id
WHERE o.order_date BETWEEN '2024-01-01' AND '2024-12-31'
GROUP BY p.product_name, p.category
ORDER BY total_revenue DESC
LIMIT 10;
--products with missing or zero revenue were excluded from top 10 results due to ranking by total revenue.
