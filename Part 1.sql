--PART A: DATA CLEANING SECTION
--CHECKING AND HANDLING MISSING VALUES-------------------------------------------------------------------

--Checking customers table for null:
SELECT * FROM customers
SELECT *
FROM customers
WHERE customer_id IS NULL
OR first_name IS NULL
OR last_name IS NULL
OR email IS NULL
OR city IS NULL
OR state IS NULL
OR signup_date IS NULL
OR account_status IS NULL;
-- only email has missing values
-- email is not critical for analysis so i left as it is



--Checking sellers table for null:
SELECT * FROM sellers
SELECT *
FROM sellers
WHERE seller_id IS NULL
OR seller_name IS NULL
OR onboarding_date IS NULL
OR product_category IS NULL
OR city IS NULL
OR state IS NULL
OR account_status IS NULL;
--no null values found in sellers table 



--Checking products table for nulls:
SELECT * FROM products
SELECT *
FROM products
WHERE product_id IS NULL
OR product_name IS NULL
OR category IS NULL
OR unit_price IS NULL
OR seller_id IS NULL;
--noticed some products have missing unit_price
--instead of deleting them, i flagged them using a CASE statement
--flagging missing prices
SELECT product_id, product_name, unit_price,
CASE
WHEN unit_price IS NULL THEN 'Unlisted Price' 
ELSE 'Listed'
END AS price_Condition
FROM products;
--this allows me to exclude them during analysis without deleting the raw data



--Checking orders table for nulls:
SELECT * FROM orders
SELECT *
FROM orders
WHERE order_id IS NULL
OR customer_id IS NULL
OR seller_id IS NULL
OR order_date IS NULL
OR delivery_date IS NULL
OR order_status IS NULL
OR total_amount IS NULL;
--found a substantial amount of nulls of the delivery_date column and total_amount column
-- -instead of deleting them, i flagged them using a CASE statement
-- flagging nulls in delivery_date
SELECT order_id, order_date, delivery_date,
CASE
WHEN delivery_date IS NULL THEN 'Pending or Undelivered'
ELSE 'Delivered'
END AS Delivery_Condition
FROM orders;
-- the nulls on the delivery_date column likely represented 'Pending or undelivered orders'

--counting missing total_amount column
SELECT COUNT(*)
FROM orders
WHERE total_amount IS NULL;
--some total_amount wasn't updated from the line_total
SELECT o.order_id, o.total_amount AS current_total, COALESCE(SUM(oi.line_total),0) AS calculated_total
FROM orders o
LEFT JOIN order_items oi
ON o.order_id = oi.order_id
GROUP BY o.order_id, o.total_amount
ORDER BY o.order_id;
--updated the total_amount to correspond with the sum of line total
UPDATE orders o
SET total_amount = sub.total_amount
FROM(SELECT o.order_id, SUM(oi.line_total) AS total_amount
FROM orders o
JOIN order_items oi
ON o.order_id = oi.order_id
GROUP BY o.order_id) sub
WHERE o.order_id = sub.order_id;
--the nulls reduced to 19 from 150



--Checking order_items table for nulls:
SELECT * FROM order_items
SELECT *
FROM order_items
WHERE item_id IS NULL
OR order_id IS NULL
OR product_id IS NULL
OR quantity IS NULL
OR unit_price IS NULL
OR line_total IS NULL;
--a substantial amount null values found in unit_price and line_total colums
--i flagged them using a CASE statement
--for unit_price column:
SELECT *,
CASE 
WHEN unit_price IS NULL THEN 'Invalid'
ELSE 'Valid'
END AS Price_condition
FROM order_items;
--the unit price is the reason why they're nulls values in the line totsl



--Checking payments table for nulls:
SELECT * FROM payments
SELECT *
FROM payments
WHERE payment_id IS NULL
OR order_id IS NULL
OR payment_method IS NULL
OR amount IS NULL
OR payment_date IS NULL;
--a substantial amount null values found in amount column
--counting missing total_amount column
SELECT COUNT(*)
FROM payments
WHERE amount IS NULL;
--updated the amount column to correspond with the total amount on orders table
UPDATE payments p
SET amount = o.total_amount
FROM orders o
WHERE p.order_id = o.Order_id
AND p.amount IS NULL
AND p.order_id in (
SELECT order_id
FROM payments
GROUP BY order_id
HAVING COUNT(*) = 1
);
--the nulls reduced to 12 from 155 due to the nulls from total_amount


--Checking reviews table for nulls:
SELECT * FROM reviews
SELECT *
FROM reviews
WHERE review_id IS NULL
OR product_id IS NULL
OR customer_id IS NULL
OR order_id IS NULL
OR rating IS NULL
OR review_date IS NULL;
--no null values found in reviewes table



--CHECKING FOR DUPLICATES ROWS IN CUSTOMERS, SELLERS AND ORDERS TABLE--------------------------------------------------------
--Checking duplicates customers
SELECT customer_id, COUNT (*) AS count
FROM customers
GROUP BY customer_id
HAVING count(*) > 1;

--Checking duplicates sellers
SELECT seller_id, COUNT (*) AS count
FROM sellers
GROUP BY seller_id
HAVING count(*) > 1;

--Checking duplicates orders
SELECT order_id, COUNT (*) AS count
FROM orders
GROUP BY order_id
HAVING count(*) > 1;
--Found no duplicates in customers,sellers and orders.



--CHECKING AND HANDLING INCONSISTENT FORMATTING----------------------------------------------------------
--STANDARDIZING CITY NAMES:
UPDATE customers
SET city = INITCAP(TRIM(city));

UPDATE sellers
SET city = INITCAP(TRIM(city));

--checking the city in both the customers and sellers for any abnormalities
SELECT DISTINCT city
FROM customers
ORDER BY city;

SELECT DISTINCT city
FROM sellers
ORDER BY city;
--noticed an incorrect spelling is "Lagos" and inconsistent variation in "port harcourt"
--applied pattern-based standardization to map all variations into consistent names

--Fixing lagos first in both tables:
UPDATE customers 
SET city = 'Lagos'
WHERE city ILIKE '%Lago%';

UPDATE sellers 
SET city = 'Lagos'
WHERE city ILIKE '%Lago%';

--Fixing Port Harcourt variations in both tables:
UPDATE customers
SET city = 'Port Harcourt'
WHERE city ILIKE '%port%harcourt%';

UPDATE sellers
SET city = 'Port Harcourt'
WHERE city ILIKE '%port%harcourt%';



--ENSURING ALL DATE COLUMNS FOLLOW A CONSISTENT FORMAT(YYYY-MM-DD)--------------------------------------------------------
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'customers';

SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'sellers';

SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'orders';

SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'payments';

SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'reviews';

--verified date columns across all tables
--most were stored as DATE, while payments table use TIMESTAMP WITHOUT TIME ZONE
--this format was retained as it does not affect analysis



--NORMALISING PRODUCT CATEGORY NAMES TO TITLE CASE--------------------------------------------------------
UPDATE products 
SET category = INITCAP(TRIM(category));

--reviewing distinct count values to ensure consistency across the dataset
SELECT DISTINCT category
FROM products
ORDER BY category;

--noticed inconsistent and misspelled product categories 
--applied pattern-based standardization to map all variations into consistent category names
UPDATE products
SET category =
CASE
WHEN category ILIKE '%beauty%' THEN 'Beauty And Personal Care'
WHEN category ILIKE '%book%' THEN 'Books And Stationery'
WHEN category ILIKE '%elect%' THEN 'Electronics'
WHEN category ILIKE '%fash%' THEN 'Fashion'
WHEN category ILIKE '%food%' THEN 'Food And Beverages'
WHEN category ILIKE '%home%garden%' THEN 'Home And Garden'
WHEN category ILIKE '%sport%' THEN 'Sports And Fitness'
ELSE INITCAP(TRIM(category))
END;
--ensured eavh product category is represented by a single standardized label for accurate analysis



--DATA VALIDATION --------------------------------------------------------
--verifyingb that each order"s total_amount matches the sum of its line items in order_items
--and checking orders where the difference is greater than #10
SELECT o.order_id, o.total_amount, SUM(oi.line_total) AS calculated_total, (o.total_amount - SUM(oi.line_total)) AS difference
FROM orders o
JOIN order_items oi
ON o.order_id = oi.order_id
GROUP BY o.order_id, o.total_amount
HAVING ABS(o.total_amount - SUM(oi.line_total)) > 10;
--noticed that all order's total_amount matches the sum of its line items 
--and no orders where the difference is greater than #10



--CHECKING THAT ALL REVIEW RATINGS ARE BETWEEN 1 and 5---------------------------------------------------------------------
SELECT *
FROM reviews
WHERE rating < 1 OR rating >5;
--i noticed invalid ratings found (-1,7,0)



--CHECKING FOR NEGATIVE PRODUCT PRICES OR DISCIUNT PERCENTAGES ABOVE 100%---------------------------------------------------
--checking negative product prices:
SELECT * 
FROM products
WHERE unit_price <0;
--i noticed no negative product prices found
-- negative pricing wpuld;ve indicated data entry error or invalid records

--No discount percentages column on any of the tables.

--END OF PART A CLEANING PROCESS.