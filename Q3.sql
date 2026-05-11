--PART B----------------------------------------------------------------------------------------------------------
--BUSINESS QUESTIONS SQL---------------------------------------------------------
--QUESTION 3:Question 3: Seller Fulfilment Efficiency
--Calculate the average time in hours between order placement and delivery for each seller. Return the top 20 sellers with the fastest average fulfilment times among sellers who have completed at least 20 orders. Include their total completed orders and average customer rating.
WITH seller_orders AS (
SELECT o.seller_id,(o.delivery_date - o.order_date) * 24 AS delivery_hours
FROM orders o
WHERE o.order_status = 'Delivered'
),
seller_ratings AS (
SELECT o.seller_id,
AVG(r.rating) AS avg_rating
FROM orders o
JOIN reviews r 
ON o.order_id = r.order_id
GROUP BY o.seller_id
)
SELECT s.seller_id,
COUNT(*) AS total_orders,
ROUND(AVG(so.delivery_hours), 2) AS avg_fulfilment_hours,
ROUND(sr.avg_rating, 2) AS avg_rating
FROM seller_orders so
JOIN sellers s 
ON so.seller_id = s.seller_id
LEFT JOIN seller_ratings sr
ON s.seller_id = sr.seller_id
GROUP BY s.seller_id, sr.avg_rating
HAVING COUNT(*) >= 20
ORDER BY avg_fulfilment_hours ASC
LIMIT 20;