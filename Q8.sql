--PART B----------------------------------------------------------------------------------------------------------
--BUSINESS QUESTIONS SQL---------------------------------------------------------
--Question 8: Top Seller Bonus Qualification
--Identify the top 10 sellers in 2024 by total revenue who completed at least 10 orders and have an average customer rating of 4.0 or above. Include their total orders, average rating, and total revenue.
SELECT o.seller_id, s.seller_name,
COUNT(DISTINCT o.order_id) AS total_orders,
AVG(r.rating) AS avg_rating,
SUM(o.total_amount) AS total_revenue
FROM orders o
JOIN sellers s 
ON o.seller_id = s.seller_id
LEFT JOIN reviews r 
ON o.order_id = r.order_id
WHERE o.order_status = 'Delivered'
AND EXTRACT(YEAR FROM o.order_date) = 2024
GROUP BY o.seller_id, s.seller_name
HAVING COUNT(DISTINCT o.order_id) >= 10
AND AVG(r.rating) >= 4.0
ORDER BY total_revenue DESC
LIMIT 10;
