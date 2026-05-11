--PART B----------------------------------------------------------------------------------------------------------
--BUSINESS QUESTIONS SQL---------------------------------------------------------
--QUESTION 4: Question 4: Quarterly Revenue Trends
--Compare quarterly revenue across 2023 and 2024. For each quarter, calculate total revenue, average order value and total number of orders.
WITH quarterly AS ( SELECT 
EXTRACT(YEAR FROM order_date) AS year,
EXTRACT(QUARTER FROM order_date) AS quarter,
SUM(total_amount) AS total_revenue,
AVG(total_amount) AS avg_order_value,
COUNT(*) AS total_orders
FROM orders
WHERE order_status = 'Delivered'
GROUP BY year, quarter
)
SELECT * 
FROM quarterly
ORDER BY year, quarter;

--Identify which single quarter showed the strongest revenue growth from 2023 to 2024.
WITH q AS ( SELECT 
EXTRACT(YEAR FROM order_date) AS year,EXTRACT(QUARTER FROM order_date) AS quarter,
SUM(total_amount) AS revenue
FROM orders
WHERE order_status = 'Delivered'
GROUP BY year, quarter
),
growth AS (
SELECT 
q2024.quarter,
 (q2024.revenue - q2023.revenue) AS Strongest_revenue_growth
FROM q q2023
JOIN q q2024 
ON q2023.quarter = q2024.quarter
AND q2023.year = 2023
AND q2024.year = 2024
)
SELECT *
FROM growth
ORDER BY revenue_growth DESC
LIMIT 1;
--I broke the data down by quarter for both 2023 and 2024, then compared each quarter side by side. 
--After calculating the revenue differences, Q4 stood out as the quarter with the strongest growth.
