# Trade-zone-ecommerce-operations-analysis---PostgreSQL
 
End-to-end SQL business analysis project focused on e-commerce operations, customer behavior, and revenue performance using PostgreSQL dated (2023-2024).

---
## Executive Summary
TradeZone experienced rapid growth between 2023 and 2024 across multiple Nigerian states. However, behind this growth were operational inconsistencies affecting customer conversion, seller performance, and revenue reliability.
This project focused on cleaning and validating operational e-commerce data using PostgreSQL before analyzing customer behavior, seller fulfilment efficiency, revenue trends, payment preferences, and product performance.
The goal was not just to answer SQL questions, but to uncover what the data revealed about the actual health of the business.

---
## Business Problem
TradeZone’s leadership team identified several concerns ahead of the 2025 planning cycle:
- declining customer retention
- inconsistent seller performance
- underperforming product categories
- regional conversion gaps
- operational data inconsistencies

The company needed a business-focused analysis capable of translating raw transactional data into actionable insights for both the Growth Team and Seller Operations Team.

---
## Dataset Overview
The dataset contained transactional and operational e-commerce data across multiple relational tables:

| Table | Description |
|-------|--------------|
|customers | customer demographic and registration information |
|sellers |	seller information and locations |
|products |	product details and pricing |
|orders |	transactional order information |
|order_items |	individual line-item purchases |
|payments |	payment records and methods |
|reviews |	customer review ratings |

---

## Data Cleaning & Validation
Before analysis, the dataset required extensive cleaning and validation to improve reliability and consistency.

Missing Values

Several NULL values were identified in:

unit_price
total_amount
payment amounts
line_total
delivery_date

The analysis focused primarily on 2023–2024 business performance.
