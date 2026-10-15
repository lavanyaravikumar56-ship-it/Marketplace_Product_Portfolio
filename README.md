# Product Analytics Dashboard – Marketplace Investment Analysis

## Project Overview

This project analyzes a marketplace business to identify where the company should invest its ₹15 crore budget for future growth.

The analysis focuses on:
- Product Portfolio
- Customer Experience
- Product Discovery
- City Expansion
- Experimentation
- Executive Investment Recommendations

---

## Problem Statement

The company has ₹15 crore available for investment and wants to identify the best opportunities for business growth.

The project analyzes product performance, customer experience, search problems, and city expansion to recommend where the investment should be allocated.

---

## Objectives

The main objectives of this project are:

1. Identify high-performing and low-performing products.
2. Identify products with high GMV but poor customer experience.
3. Analyze delivery delays and customer satisfaction.
4. Identify search terms with high zero-result searches.
5. Rank cities for expansion opportunities.
6. Evaluate experiments and identify promising variants.
7. Recommend an investment plan for ₹15 crore.

---

## Dataset

The project uses marketplace data covering:

- Customers
- Products
- Orders
- Delivery & Customer Experience
- Support Tickets
- Search Events
- City Economics
- Experiments

---

## Tools Used

- **Excel** – Data cleaning, PivotTables, calculations and business analysis
- **SQL / MySQL** – Data analysis, joins, CTEs, window functions and ranking
- **Power BI** – Interactive dashboard and KPI visualization

---

## Excel Analysis

Excel was used to analyze:

### Product Portfolio
- Category GMV
- Average product rating
- SKU performance
- Customer Experience status
- Portfolio classification

Portfolio roles:
- Hero
- Growth Bet
- Long-tail Cleanup

### Customer Experience
- Delivery delay rate
- Delivery status
- Support tickets
- Customer satisfaction

### Product Discovery
- Search volume
- Zero-result searches
- Zero-result rate
- Search opportunity

### City Expansion
Cities were evaluated using:
- GMV
- Contribution Margin
- Repeat Rate
- Delivery Success
- Customer Experience

### Experimentation
Experiments were reviewed based on:
- Conversion
- Retention
- Variant performance

---

## SQL Analysis

SQL was used for:

- Duplicate order identification
- Missing-value checks
- Multi-table joins
- Customer-level metrics
- Product ranking
- Category performance
- Customer segment analysis
- Search opportunity analysis
- City ranking
- Executive KPI dataset creation

SQL techniques used:

- JOIN
- LEFT JOIN
- CTE
- GROUP BY
- CASE WHEN
- RANK()
- Aggregate functions

---

## Key Findings

### Product Portfolio

Sports & Fitness generated the highest category GMV, followed by Electronics and Home Appliances.

The product portfolio was classified into:

- **Hero:** 9 SKUs
- **Growth Bet:** 589 SKUs
- **Long-tail Cleanup:** 502 SKUs

---

### Customer Experience

Overall average rating is approximately **3.00**.

The overall delivery delay rate is approximately **31.30%**.

New customers showed the weakest customer satisfaction compared with other customer segments.

---

### Product Discovery

There were **18,000 searches** in the dataset.

Approximately **13,476 searches returned zero results**, resulting in a zero-result rate of approximately **74.87%**.

This indicates a significant opportunity to improve product discovery and search relevance.

---

### City Expansion

The recommended city decisions are:

#### SCALE
- Delhi NCR
- Indore

#### WATCH
- Lucknow
- Pune
- Kochi

#### WAIT
- Kolkata
- Bengaluru
- Jaipur
- Hyderabad
- Chennai
- Mumbai
- Ahmedabad

---

## Power BI Dashboard

The Power BI dashboard contains five pages:

### 1. CPO Executive Scorecard
Key business KPIs including:
- Total GMV
- Total Orders
- Average Rating
- Delay Rate
- Zero-Result Rate
- Average CSAT

### 2. Product Portfolio & Category Economics
Shows:
- GMV by Category
- Average Rating by Category
- Portfolio Distribution
- SKU Performance

### 3. Customer Experience & Delivery
Shows:
- Delivery Status
- Delay Rate
- Support Tickets
- CSAT by Issue Type

### 4. Search & Product Discovery
Shows:
- Zero-result searches
- Zero-result rate
- Searches by search term
- Device-level search performance

### 5. City Expansion Opportunity
Shows:
- GMV by City
- Contribution Margin
- Orders by City
- Delivery Success
- Repeat Rate

---

## ₹15 Crore Investment Recommendation

| Area | Investment |
|---|---:|
| Product Portfolio | ₹2.5 Cr |
| Customer Experience | ₹3.5 Cr |
| Search & Discovery | ₹2 Cr |
| City Expansion | ₹5 Cr |
| Experimentation & Data | ₹2 Cr |
| **Total** | **₹15 Cr** |

---

## Executive Recommendation

The recommended strategy is to **scale Delhi NCR and Indore**, while keeping Lucknow, Pune and Kochi under observation.

At the same time, the company should improve **product quality, customer experience and search performance** before expanding aggressively into additional cities.

---

## Project Structure

```text
Product-Analytics-Dashboard/
│
├── PowerBI/
│   └── Product_Analytics_Dashboard.pbix
│
├── Excel/
│   └── Product_Portfolio_Analysis.xlsx
│
├── SQL/
│   └── Product_Analytics_SQL.sql
│
├── Screenshots/
│   ├── Page1_Executive_Scorecard.png
│   ├── Page2_Product_Portfolio.png
│   ├── Page3_Customer_Experience.png
│   ├── Page4_Search_Discovery.png
│   └── Page5_City_Expansion.png
│
└── README.md
