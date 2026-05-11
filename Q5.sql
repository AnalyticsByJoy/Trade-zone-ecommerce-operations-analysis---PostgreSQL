--PART B----------------------------------------------------------------------------------------------------------
--BUSINESS QUESTIONS SQL---------------------------------------------------------
--Question 5: Customer Spend Segmentation
--Segment customers based on their total spend in 2024 into three groups:
--High Spenders: ≥ ₦100,000 Medium Spenders: ₦50,000 – ₦99,999Low Spenders: < ₦50,000For each group, calculate the customer count, average spend per customer and total revenue contribution.
WITH customer_spend AS (
SELECT customer_id,
SUM(total_amount) AS total_spend
FROM orders
WHERE order_status = 'Delivered'
AND EXTRACT(YEAR FROM order_date) = 2024
GROUP BY customer_id
),
segmented AS (
SELECT customer_id, total_spend,
CASE 
WHEN total_spend >= 100000 THEN 'High Spenders'
WHEN total_spend BETWEEN 50000 AND 99999 THEN 'Medium Spenders'
ELSE 'Low Spenders'
END AS segment
FROM customer_spend
)
SELECT segment,
COUNT(customer_id) AS customer_count,
AVG(total_spend) AS avg_spend_per_customer,
SUM(total_spend) AS total_revenue
FROM segmented
GROUP BY segment
ORDER BY total_revenue DESC;
