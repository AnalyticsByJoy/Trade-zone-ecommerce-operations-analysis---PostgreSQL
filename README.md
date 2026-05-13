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
```
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
```


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
NULL values were identified in several important fields across:
- products.unit_price
- orders.total_amount
- orders.delivery_date
- order_items.unit_price
- order_items.line_total
- payments.amount
  #### Actions Taken
- Missing payment amounts were updated using corresponding order totals where appropriate.
- total_amount values in orders were reconciled against the sum of line item totals.
- NULL delivery dates were preserved because they represented undelivered or incomplete orders.
- Revenue calculations used COALESCE() where necessary to avoid aggregation errors.
- NULL product prices were flagged and excluded from sensitive revenue analysis instead of being deleted.

### Duplicate Validation:
Duplicate checks were performed across:
- customers
- sellers
- orders
#### Actions Taken
- Duplicate validation queries were executed using primary identifiers.
- No major duplicate records were identified during inspection.
- Existing records were preserved to maintain transactional completeness.

### Standardization & Formatting:
Several formatting inconsistencies were identified in:
- city names
- product categories
- text casing

Examples included:
- Lago S
- Port-Harcourt
- Electronis
- Fashon
#### Actions Taken
- City names were standardized using INITCAP() and manual corrections.
- Product categories were normalized into consistent naming formats.
- Text fields were trimmed to remove excess spaces.
- Date fields were validated to ensure consistent formatting across tables.

### Data Validation:
Validation checks were performed to ensure transactional consistency and business reliability.
#### Actions Taken
- Order totals were validated against summed line item totals.
- Review ratings were checked to confirm values remained between 1 and 5.
- Product prices were reviewed for invalid negative values.
- Discount percentages were checked for values exceeding 100%.
- Incomplete or inconsistent transactions were flagged for awareness during analysis.

### Cleaning Outcome
The cleaning process improved:
- revenue consistency
- category aggregation accuracy
- regional reporting reliability
- transactional validation confidence

This ensured the dataset was more reliable for operational and business-focused SQL analysis.

Click here to view full cleaning process:
[Part 1.sql](Part%201.sql)

---
## Business Questions & Key Findings
### Q1: Customer Acquisition & 30-Day Conversion
Identified the top-performing states by customer signups and measured how many converted into paying customers within 30 days:
| State | Total registrations | Converted customers | Conversion Rate |
| ----- | ------------------- | ------------------- | --------------- | 
| Lagos | 146	| 69	| 47.26 |
| FCT | 92	 | 37	| 40.22 |
| Rivers | 66 |	25 |	37.88 |
| Oyo | 63	| 19	| 30.16 |
| Kano | 58 |	18 |	31.03 |

#### Key Finding:
Lagos recorded both the highest acquisition and conversion rates, while states like Kano and Oyo struggled with conversion despite strong signup numbers.

View the SQL script [Q1.sql](Q1.sql)

### Q2: Product Performance
Analyzed the top 10 revenue-generating products in 2024.
| Product name | Category | Total revenue | Total number of orders |
| ------------ | -------- | ------------- | ---------------------- | 
| HP Pavilion 15 Laptop Intel i5 - v2 |	Electronics |	₦26,702,504.36 |	25 |
| Mechanical Keyboard RGB Backlit |	Electronics |	₦25,124,824.10	| 24 |
| TP-Link WiFi Router AC1200 - v2 |	Electronics |	₦23,727,475.50 |	24 |
| Hisense 32 inch LED TV |	Electronics |	₦23,597,927.50	| 26 |
| Apple AirPods Pro 2nd Gen |	Electronics |	₦21,681,843.09 |	25 |
| JBL Bluetooth Speaker Portable |	Electronics | ₦20,388,232.26 |	22 |
| Kingston 256GB USB Flash Drive - v2 |	Electronics |	₦19,165,030.56 |	21 |
| Garmin Forerunner 255 Watch - v2 |	Electronics |	₦18,470,211.35 |	29 |
| Lenovo IdeaPad 3 Laptop 8GB RAM - v2 |	Electronics |	₦18,182,471.45 |	20 |
| Anker PowerBank 20000mAh USB-C |	Electronics | ₦17,729,180.30 |	19 |

#### Key Finding:
Electronics dominated platform revenue, revealing strong dependence on a single product category.

View the SQL script [Q2.sql](Q2.sql)
