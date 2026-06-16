-- =====================================================
-- Amazon Product & Review Analysis
-- =====================================================

-- Dataset Overview

-- Total rows
SELECT COUNT(*)
FROM amazon_products; --expected result 1465

-- Distinct product IDs
SELECT COUNT(DISTINCT product_id)
FROM amazon_products; --expected result 1351

-- Distinct categories
SELECT COUNT(DISTINCT category)
FROM amazon_products; --expected result 211

-- Candidate Key Investigation

-- Product_ID

SELECT product_id FROM amazon_products GROUP BY product_id  HAVING COUNT(product_id) > 1; --for list of duplicate product_id

SELECT COUNT(*)
FROM
	(SELECT product_id FROM amazon_products GROUP BY product_id  HAVING COUNT(product_id) > 1) AS duplicate_product_ids; --for count of duplicate product_id
	
SELECT * FROM amazon_products WHERE product_id = 'B008FWZGSG'; --to check manually the difference in each column value with same product_id

--Review_ID

SELECT review_id FROM amazon_products GROUP BY review_id  HAVING COUNT(review_id) > 1; --for list of duplicate review_id

SELECT COUNT(*)
FROM
	(SELECT review_id FROM amazon_products GROUP BY review_id  HAVING COUNT(review_id) > 1) AS duplicate_review_ids; --for count of duplicate review_id

SELECT * FROM amazon_products 
WHERE review_id = 'R3B5HP4PJ8JIOG,R2NS7Z2XUJL73H,R3DLYP0JW3PWDP,R3HWHOM95KCAZV,R2EVYBZOHRZ8NQ,R2U4UV55GHL0AB,R2E6IQWP86JIVZ,R225NQB3ASPXBV'; --to check manually the difference in each column value with same review_id

-- Duplicate Analysis

-- Extra duplicate rows beyond unique product IDs
-- Expected result: 114
SELECT COUNT(product_id) - COUNT(DISTINCT product_id) AS extra_duplicate_rows
FROM amazon_products;

-- Unique product_id values that appear more than once
-- Expected result: 92
SELECT COUNT(*) AS duplicated_product_id_count
FROM (
    SELECT product_id
    FROM amazon_products
    GROUP BY product_id
    HAVING COUNT(*) > 1
) AS duplicated_products;

-- Check whether duplicated product IDs have different rating values
SELECT
    product_id,
    COUNT(DISTINCT rating) AS distinct_rating_count
FROM amazon_products
GROUP BY product_id
HAVING COUNT(*) > 1
ORDER BY distinct_rating_count DESC;
-- Observation: 
-- duplicated product IDs generally had one distinct rating value,
-- suggesting most duplicates were not meaningful rating changes.

-- Category Structure Investigation

-- Analyzing distinct category
SELECT DISTINCT category
FROM amazon_products
LIMIT 20;

-- Observation:
-- The category field contains a hierarchy rather than a single category.
-- Example:
-- Electronics|Cameras&Photography|Accessories|Tripods&Monopods|TripodLegs
--
-- For category-level analysis:
-- 1. Extract the top-level category.
-- 2. Treat duplicate product IDs as one product.
-- 3. Count products per category.
-- 4. Sort descending.

SELECT COUNT(product_id) AS product_count, top_level_category
FROM 
	(SELECT DISTINCT product_id, SPLIT_PART(category, '|', 1) AS top_level_category 
	FROM amazon_products) AS extract_top_level_category
GROUP BY top_level_category 
ORDER BY product_count DESC;

-- Key Finding:
-- Electronics had the highest number of products (490).
-- Home&Kitchen had 447 products.
-- Computers&Accessories had 375 products.

-- Rating Analysis

-- Identify non-numeric rating values
-- Expected result: one invalid value '|'
SELECT rating
FROM amazon_products
WHERE rating !~ '^[0-9]+(\.[0-9]+)?$';

-- Average rating and product count by top-level category
SELECT top_level_category, COUNT(DISTINCT product_id) AS product_count, ROUND(AVG(CAST(rating AS NUMERIC)),2) AS avg_rating 
FROM 
	(SELECT DISTINCT product_id, SPLIT_PART(category, '|', 1) AS top_level_category, rating
	FROM amazon_products) AS avg_rating_top_level_category
WHERE rating <> '|'
GROUP BY top_level_category 
ORDER BY avg_rating DESC;

-- Average rating by top-level category with minimum sample size
-- Only include categories with at least 30 distinct products
SELECT top_level_category, COUNT(DISTINCT product_id) AS product_count, ROUND(AVG(CAST(rating AS NUMERIC)),2) AS avg_rating 
FROM 
	(SELECT DISTINCT product_id, SPLIT_PART(category, '|', 1) AS top_level_category, rating
	FROM amazon_products) AS avg_rating_top_level_category
WHERE rating <> '|'
GROUP BY top_level_category
HAVING COUNT(DISTINCT product_id) >=30
ORDER BY avg_rating DESC;

-- Key Finding:
-- OfficeProducts had the highest average rating (4.31)
-- among categories with at least 30 products.