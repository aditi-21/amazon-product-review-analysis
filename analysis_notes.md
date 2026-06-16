# Amazon Product & Review Analysis

## Dataset Overview
- The dataset contains 1465 rows.
- There are 1351 distinct product IDs.
- The dataset is about Amazon products and reviews, not sales transactions.
- Important columns include product_id, product_name, category, discounted_price, actual_price, rating, rating_count, review_id, and review_content.

## Candidate Key Investigation

At the beginning of the project, I was unsure whether product_id or review_id should be used as the main identifier for the dataset.

To investigate this, I checked for duplicate values in both columns. I found that some product_ids appeared multiple times. It looked like that he only difference among the rows where product_id is same are the img_link and product_link column. This suggests the duplicates may be artifacts of the data collection process, although the exact cause could not be verified.

Review information appeared to be shared across multiple product variants. For example, products that differed only in cable length had different product_id values but identical review information.

Based on these observations, I decided to use product_id as the business identifier for product-level analysis.

## Duplicate Analysis
How many rows were in the dataset?
1465 rows

How many distinct product IDs were there?
1351

How many duplicated product IDs were found?
92

How did you calculate that?
--investigation
I first calculated the number of distinct products.
I then identified product IDs appearing more than once using GROUP BY and HAVING.
After identifying duplicated product IDs, I manually inspected several examples to compare column values and understand the nature of the duplicates.

What did you learn from investigating the duplicates?
Investigation of duplicate product IDs showed that duplicated rows were nearly identical. Product information, ratings, and review information were generally the same, while differences were mainly observed in img_link and product_link. This suggests the duplicates are likely data artifacts rather than separate products, although the exact source could not be verified.

## Category Structure Investigation
Why did you investigate the category field?
When I calculated the number of distinct categories, I found 211 unique values among only 1,351 products. This seemed unusually high, so I investigated the category field to understand how category information was stored.

What did you discover?
I noticed that the category column is actyally having hierarchical structure instead of one general category type. Like Electronics->Computer->Accesories

Why was the original category field unsuitable for top-level category analysis?
Using the full category path would split products into many highly specific groups, making it difficult to compare categories at a business level.

What approach did you use instead?
So instead of keeping hierarchical category I extracted the top level category.

Summary:
Investigation of the category field revealed that categories were stored as hierarchical paths rather than individual category labels. The field contained multiple levels separated by |. Using the full hierarchy resulted in 211 distinct category values, which was too granular for high-level category analysis. To perform category-level comparisons, I extracted only the first level of the hierarchy and used it as the top-level category.

## Rating Analysis
What issue did you discover with the rating column?
The rating values represented numeric data, but the column was stored as text. This prevented direct use of numerical functions such as AVG() without first converting the values to a numeric data type.
 
Why couldn't you immediately convert it to numeric?
When I attempted to convert the entire column to a numeric data type, PostgreSQL returned an error because not all values in the column were valid numeric values.

How did you investigate the problem?
I investigated the issue by searching for values that did not match the expected numeric format.

What did you find?
i found there was a rating value as '| '

How did you handle it in the analysis?
Since only one row contained an invalid rating value (|), I excluded that row from rating-based analysis and converted the remaining ratings to numeric values when calculating averages.

## Key Finding

- Category with Most Products
The Electronics category contained the highest number of products (490).

- Highest Rated Category
After filtering categories to include only those with at least 30 products, OfficeProducts had the highest average rating (4.31) with 31 products.

- Importance of Sample Size
Initial analysis showed that some categories had very high average ratings. However, these categories contained only one or two products. Applying a minimum sample size threshold resulted in more reliable category comparisons.

- Category Distribution
Most products in the dataset belonged to Electronics, Home&Kitchen, and Computers&Accessories.

## Lessons Learned
- Importance of understanding row granularity. Before performing analysis, it is important to understand what each row represents. Initially, it was unclear whether a row represented a product, a review, or a product variant. Investigating this helped avoid incorrect assumptions during analysis.
- Importance of identifying the correct business key. Product ID and review ID could not be assumed to be interchangeable. Investigating both helped determine which identifier was most appropriate for product-level analysis.
- Data quality issues are common. For instance in this dataset there were data like:
    rating = '|'
    duplicate product_ids
    hierarchical categories
- Category structures may require transformation before analysis
- Sample size should be checked before interpreting averages. Categories with only one or two products produced high average ratings, but these results were less reliable than categories with larger sample sizes.
- Investigation is often more important than immediately creating charts