SELECT TOP (1000) [customer_id]
      ,[order_date]
      ,[product_id]
  FROM [dannys_diner].[dbo].[sales]


-- both are same
Select distinct customer_id, product_id, 
count(product_id) over(partition by customer_id, product_id order by product_id) 
from [dannys_diner].[dbo].[sales];

Select customer_id, product_id, count(product_id) as freq
from [dannys_diner].[dbo].[sales] 
group by customer_id, product_id;


-- Most frequently ordered products for each customer
With cte as(
    Select customer_id, product_id, count(product_id) as freq
    from [dannys_diner].[dbo].[sales] 
    group by customer_id, product_id
), 
ranking as(
    select *,
    DENSE_RANK() over(partition by customer_id order by freq desc) as drk
    from cte
)
select customer_id, product_id from ranking where drk=1;