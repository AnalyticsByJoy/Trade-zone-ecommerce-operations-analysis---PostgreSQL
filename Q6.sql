--PART B----------------------------------------------------------------------------------------------------------
--BUSINESS QUESTIONS SQL---------------------------------------------------------
--Question 6: Payment Method Preferences by State
--Analyse payment method preferences across each state in the dataset. For each state, show the transaction count and total amount for each payment method (Cash on Delivery, Card, Mobile Money, Bank Transfer) and identify the most popular method per state.
WITH payment_status AS ( 
SELECT c.state, p.payment_method,
COUNT(*) AS transaction_count,
SUM(p.amount) AS total_amount
FROM payments p
JOIN orders o ON p.order_id = o.order_id
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.state, p.payment_method
),
ranked AS (
SELECT state, payment_method,transaction_count,total_amount,
RANK() OVER (
PARTITION BY state 
ORDER BY transaction_count DESC
) AS rank_in_state
FROM payment_status
)
SELECT *
FROM ranked
ORDER BY state, rank_in_state;

-- Attempted to run: SELECT * FROM ranked WHERE rank_in_state = 1;
-- This resulted in an error because ‘ranked’ is a CTE and does not persist 
-- beyond the query in which it is defined.

