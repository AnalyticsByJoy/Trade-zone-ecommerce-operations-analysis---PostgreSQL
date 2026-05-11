--PART B----------------------------------------------------------------------------------------------------------
--BUSINESS QUESTIONS SQL---------------------------------------------------------
--Question 7: Review Ratings and Sales Performance
--Group products based on their average review rating into three categories:
--High Rated: 4.0 and aboveMid Rated: 3.0 – 3.99Low Rated: Below 3.0For each category, calculate the product count, total revenue and average unit price.
WITH product_ratings AS (
SELECT p.product_id, p.product_name, p.unit_price,
AVG(r.rating) AS avg_rating
FROM products p
LEFT JOIN reviews r 
ON p.product_id = r.product_id
GROUP BY p.product_id, p.product_name, p.unit_price
),
categorized AS (
SELECT product_id, product_name, unit_price, avg_rating,
CASE 
WHEN avg_rating >= 4 THEN 'High Rated'
WHEN avg_rating BETWEEN 3 AND 3.99 THEN 'Mid Rated'
ELSE 'Low Rated'
END AS rating_category
FROM product_ratings
),
product_revenue AS (
SELECT oi.product_id,
SUM(oi.line_total) AS total_revenue
FROM order_items oi
JOIN orders o 
ON oi.order_id = o.order_id
WHERE o.order_status = 'Delivered'
GROUP BY oi.product_id
)
SELECT c.rating_category,
COUNT(DISTINCT c.product_id) AS product_count,
SUM(pr.total_revenue) AS total_revenue,
AVG(c.unit_price) AS avg_unit_price
FROM categorized c
LEFT JOIN product_revenue pr 
ON c.product_id = pr.product_id
GROUP BY c.rating_category
ORDER BY total_revenue DESC;