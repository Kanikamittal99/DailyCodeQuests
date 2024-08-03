-- MS SQL Server
-- https://leetcode.com/problems/product-sales-analysis-iii/


-- Using Ranking fn
-- Row_Number() won't work here; it will only return one row per product
-- But we might have multiple rows with the same minimum year for a product_id. We want to include them all.
-- Dense_Rank() handles ties well by assigning same rank 

WITH cte AS (
    SELECT 
        product_id,
        year,
        quantity,
        price,
        DENSE_RANK() OVER (PARTITION BY product_id ORDER BY year ASC) AS dr
    FROM sales
)
SELECT 
    product_id,
    year AS first_year,
    quantity,
    price
FROM cte
WHERE dr = 1;



-- Second Way


WITH cte AS (
    SELECT product_id, MIN(year) AS first_year
    FROM Sales
    GROUP BY product_id
)
SELECT cte.product_id, cte.first_year, quantity, price
FROM cte
JOIN Sales ON cte.product_id = Sales.product_id
    AND cte.first_year = Sales.year;
