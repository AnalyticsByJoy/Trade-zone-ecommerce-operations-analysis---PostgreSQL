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
| HP Pavilion 15 Laptop Intel i5 - v2 |	Electronics |	₦26,702,504 |	25 |
| Mechanical Keyboard RGB Backlit |	Electronics |	₦25,124,824	| 24 |
| TP-Link WiFi Router AC1200 - v2 |	Electronics |	₦23,727,475 |	24 |
| Hisense 32 inch LED TV |	Electronics |	₦23,597,927 | 26 |
| Apple AirPods Pro 2nd Gen |	Electronics |	₦21,681,843 |	25 |
| JBL Bluetooth Speaker Portable |	Electronics | ₦20,388,232 |	22 |
| Kingston 256GB USB Flash Drive - v2 |	Electronics |	₦19,165,030 |	21 |
| Garmin Forerunner 255 Watch - v2 |	Electronics |	₦18,470,211 |	29 |
| Lenovo IdeaPad 3 Laptop 8GB RAM - v2 |	Electronics |	₦18,182,471 |	20 |
| Anker PowerBank 20000mAh USB-C |	Electronics | ₦17,729,180 |	19 |

#### Key Finding:
Electronics dominated platform revenue, revealing strong dependence on a single product category.

View the SQL script [Q2.sql](Q2.sql)

### Q3:Seller Fulfilment Efficiency
Measured average fulfilment time and compared seller operational efficiency against customer ratings.
| Seller name | Total orders | Avg fulfillment hours | Avg rating |
| ----------- | -------- | ------------- | ---------------------- | 
|RunFast NG|20|91.20 |3.25|
|SportNation NG|29|92.69|3.65|
|SportsCentral NG|20|98.40|4.08|
|GadgetPro NG|25|99.84|3.70|
|TechPower NG|20|105.60|3.40|
|FashionHub NG|21|108.57|3.55|
|AgriMart NG|21|108.57|2.50|
|TechHub Nigeria|22|110.18|4.13|
|DigiTech NG|20|110.40|3.67|
|GadgetKing NG|23|110.61|1.64|
|AllFashion NG|20|112.80|4.56|
|OrganicLife NG|22|116.73|3.67|
|PureSkin NG|20|117.60|3.38|
|EarthHome NG|21|117.71|3.80|
|TechStore NG|20|118.80|3.55|
|GreenHome Stores|21|118.86|2.91|
|StyleKraft NG|23|121.04|4.21|
|WellnessHub NG|26|121.85|3.86|
|VogueNG|27|126.22|4.18|
|QuickTech NG|24|129.00|3.69|

### Key Finding
Faster delivery times showed weak correlation with customer satisfaction scores.

View the SQL script [Q3.sql](Q3.sql)

### Q4:Quarterly Revenue Trends
Compared quarterly revenue performance across 2023 and 2024.

#### Key Finding
Q4 recorded the strongest revenue growth, indicating seasonal demand patterns.

### Q5:Customer Spend Segmentation
Segmented customers into:
- High Spenders
- Medium Spenders
- Low Spenders
| Segment | Customer count | Avg spend per customer | Total revenue |
| ------- | -------------- | ---------------------- | ------------- | 
|High Spenders|418|₦996,285|₦416,447,403|
|Medium Spenders|50|₦74,732|₦3,736,623|
|Low Spenders|71|₦26,149|₦1,804,325|
  
#### Key Finding
Revenue was heavily concentrated among high-spending customers, creating customer concentration risk.

View the SQL script [Q5.sql](Q5.sql)

### Q6:Payment Preferences by State
Analyzed regional payment behavior across Nigerian states.
| State | Most preferred payment method | Transactions count |
| ----- | ----------------------------- | ------------------ |
|FCT|Card|194|	
|Kano|Cash on Delivery|90|	
|Lagos|Card|371|	
|Oyo|Cash on Delivery|114|
|Rivers|Card|137|	

#### Key Finding
Urban states favored digital payments, while some regions remained highly dependent on cash on delivery.

View the SQL script [Q6.sql](Q6.sql)

### Q7:Review Ratings vs Sales Performance
Grouped products by average ratings and analyzed financial performance.
| Rating category | Product count | Total revenue | Avg unit price |
| --------------- | ------------- | ------------- | -------------- |
|Mid Rated|118|₦239,899,126|₦64,904|
|High Rated|114|₦174,644,943|₦45,762|
|Low Rated|48|₦86,065,150|₦52,943|

#### Key Finding
Mid-rated products unexpectedly generated the highest revenue.

View the SQL script [Q7.sql](Q7.sql)

### Q8:Seller Bonus Qualification
Identified sellers meeting operational and customer satisfaction thresholds for performance incentives.
| Seller name | Total orders | Avg rating | total revenue |
| ----------- | ------------ | ---------- | ------------- |
|SportsCentral NG|18|4.0|₦10,978,246|
|GardenHouse NG|16|4.1|₦9,002,467|
|SkinGlow NG|17|4.2|₦7,562,171|
|GlowBeauty Shop|13|4.2|₦7,514,005|
|WellnessHub NG|19|4.4|₦6,793,826|
|FitZone NG|11|4.2|₦6,405,726|
|ModaNG|13|4.1|₦6,386,413|
|BookWorld Nigeria|14|4.0|₦6,098,536|
|CozyHome NG|15|4.0|₦5,538,087|
|CleanHome NG|15|4.2|₦5,500,122|

### Key Finding
Some sellers balanced both strong revenue and high customer ratings, making them ideal candidates for reward programs.

View the SQL script [Q8.sql](Q8.sql)
