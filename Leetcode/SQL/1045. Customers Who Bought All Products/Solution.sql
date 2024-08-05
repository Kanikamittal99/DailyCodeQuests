-- MS SQL Server
-- https://leetcode.com/problems/customers-who-bought-all-products/

-- BEats 80% solutions

select customer_id
from Customer 
group by customer_id
having count(distinct product_key) = (select count(product_key) from Product)


-- Using Counter

DECLARE @counter INT;
SELECT @counter = COUNT(product_key) FROM product;

select customer_id 
from customer
group by customer_id
having count(distinct product_key) = @counter