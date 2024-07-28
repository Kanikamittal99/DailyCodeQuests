-- MS SQL Server
-- https://leetcode.com/problems/immediate-food-delivery-ii


-- Using CTE & Window Function: ROW_NUMER()


WITH RankedDeliveries AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date) AS rn
    FROM Delivery
)
SELECT 
    ROUND(SUM(CASE WHEN order_date = customer_pref_delivery_date THEN 1 ELSE 0 END) * 100.0 / COUNT(customer_id),2) AS immediate_percentage
FROM RankedDeliveries
WHERE rn = 1;


-- Using subquery 

SELECT ROUND(SUM(case when order_date = customer_pref_delivery_date then 1 else 0 end)*100.0
    /count(customer_id),2) as immediate_percentage
FROM Delivery d
WHERE d.order_date = (
    SELECT MIN(order_date)
    FROM Delivery
    WHERE customer_id = d.customer_id
);




