# Amazon Product & Review Analysis

## Project Overview
This project analyzes Amazon product and review data using SQL in PostgreSQL. The objective was to investigate product categories, ratings, and data quality issues while practicing exploratory data analysis techniques.

The project involved identifying the appropriate business key, investigating duplicate records, examining category hierarchies, cleaning rating data, and comparing category performance based on product counts and average ratings.

## Dataset
- Source: Amazon Product & Review Dataset (Kaggle)
- Total Rows: 1465
- Distinct Product IDs: 1351
- Main fields: product_id, category, rating, rating_count, review_id, review_content, discounted_price, actual_price

## Analysis Workflow
1. Imported the dataset into PostgreSQL.
2. Performed initial data inspection.
3. Investigated candidate business keys.
4. Analyzed duplicate records.
5. Examined category hierarchy structure.
6. Cleaned invalid rating data.
7. Calculated category-level metrics.
8. Evaluated category ratings using minimum sample size thresholds.

## Business Questions
- What does each row represent?
- Which identifier should be used for product-level analysis?
- Which categories contain the most products?
- Which categories have the highest average ratings?
- How does sample size affect category comparisons?

## Data Investigation
Investigated candidate business keys.
Analyzed duplicate product IDs.
Examined category hierarchy structure.
Identified invalid rating values.

## Key Findings
- Electronics contained the highest number of products (490).
- OfficeProducts had the highest average rating (4.31) among categories with at least 30 products.
- Some product IDs appeared multiple times but were largely identical, suggesting dataset artifacts rather than separate products.
- The category field contained hierarchical values separated by "|" and required transformation before category-level analysis.

## Tools Used
- PostgreSQL
- pgAdmin
- SQL
- VS Code

## Skills Demonstrated
- SQL
- PostgreSQL
- Data Cleaning
- Exploratory Data Analysis (EDA)
- Data Validation
- String Manipulation
- Aggregation Functions
- Subqueries
- Business Analysis
- Data Quality Investigation