--PART B----------------------------------------------------------------------------------------------------------
--BUSINESS QUESTIONS SQL---------------------------------------------------------------------
--QUESTION 1: Customer Acquisition & 30-Day Conversion
--Find the top 5 states by number of new customer sign-ups in 2024. For each state, calculate what percentage of these new customers made at least one purchase within their first 30 days of signing up.
WITH latest_customers AS(SELECT customer_id, state, signup_date
FROM customers 
WHERE signup_date BETWEEN '2024-01-01' AND '2024-12-31'
),
orders_within_30_days AS( SELECT DISTINCT lc.customer_id
FROM latest_customers lc
JOIN orders o
ON lc.customer_id = o.customer_id
WHERE o.order_date <= lc.signup_date + INTERVAL '30 days'
)
SELECT lc.state, 
COUNT (lc.customer_id) AS total_registrations, 
COUNT (ow.customer_id) AS converted_customers,
ROUND(COUNT(ow.customer_id) ::decimal / COUNT(lc.customer_id) * 100,
2
) AS conversion_rate
FROM latest_customers lc
LEFT JOIN orders_within_30_days ow
ON lc.customer_id = ow.customer_id
GROUP BY lc.state
ORDER BY total_registrations DESC
LIMIT 5;



