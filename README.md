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
| customers | customer demographic and registration information |
| sellers |	seller information and locations |
| products |	product details and pricing |
| orders |	transactional order information |
| order_items |	individual line-item purchases |
| payments |	payment records and methods |
| reviews |	customer review ratings |

## Entity Relationships
'''
Customers ─────< Orders >───── Sellers
                     │
                     │
                     ▼
               Order_Items
                 ▲      ▲
                 │      │
             Products   │
                        │
          Orders ─────< Payments
          Orders ─────< Reviews
'''


| Relationship | Description |
|--------------|-------------|
| customers → orders | One customer can place multiple orders|
| sellers → orders | One seller can fulfil multiple orders |
| orders → order_items | One order can contain multiple products |
| products → order_items | Products can appear across multiple orders |
| orders → payments | Orders are linked to payment transactions |
| orders → reviews | Customers can review completed orders |



## Data Cleaning & Validation
Before analysis, the dataset required extensive cleaning and validation to improve reliability and consistency.

### Missing Values
Several NULL values were identified in:
- unit_price
- total_amount
- payment amounts
- line_total
- delivery_date
  #### Actions Taken
- payment amounts were updated using matching order totals where appropriate
- missing revenue-related values were handled using COALESCE() during aggregation
- undelivered orders with NULL delivery dates were preserved rather than removed
 
### Duplicate Checks:
Duplicate validation was performed across:
- customers
- sellers
- orders
  
No major duplicate records were identified after inspection.

### Inconsistent Formatting:
Several inconsistencies were found including:
- “Lago S”
- “Port-Harcourt”
- “Electronis”
- “Fashon”
  
### Standardization:
- city names were standardized using INITCAP() and manual correction
- category names were normalized into consistent formats
- date fields were validated for consistency

### Data Validation:
Additional validation checks included:
- verifying order totals against line-item totals
- validating review ratings between 1–5
- checking for invalid product prices
- identifying incomplete transactions

Click here to view full cleaning process:
[part 1.sql](part%201.sql)
