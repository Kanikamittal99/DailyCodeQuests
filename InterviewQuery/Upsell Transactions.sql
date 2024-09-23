-- https://www.interviewquery.com/questions/upsell-transactions
/*
We’re given a table of product purchases. Each row in the table represents an individual user product purchase.

Write a query to get the number of customers that were upsold, or in other words, the number of users who bought additional products after their first purchase.

Note: If the customer purchased two things on the same day, that does not count as an upsell, as they were purchased within a similar timeframe.

CREATE TABLE orders (
    id INT PRIMARY KEY,
    user_id INT,
    created_at DATETIME,
    product_id INT,
    quantity INT
);

INSERT INTO orders (id, user_id, created_at, product_id, quantity) VALUES
(1, 59, '2019-10-05 00:00:00', 968, 1),
(2, 84, '2019-08-11 00:00:00', 432, 2),
(3, 21, '2020-01-25 00:00:00', 43, 3),
(4, 47, '2019-12-25 00:00:00', 529, 3),
(5, 100, '2020-03-05 00:00:00', 40, 2),
(6, 45, '2019-06-30 00:00:00', 799, 1),
(7, 44, '2020-07-07 00:00:00', 134, 1),
(8, 38, '2020-09-23 00:00:00', 210, 2),
(9, 45, '2020-03-08 00:00:00', 525, 2),
(10, 16, '2020-04-22 00:00:00', 415, 1),
(11, 21, '2020-01-25 00:00:00', 438, 2),
(12, 45, '2020-09-17 00:00:00', 653, 1),
(13, 34, '2019-07-05 00:00:00', 631, 1),
(14, 59, '2020-02-16 00:00:00', 737, 3),
(15, 38, '2020-05-22 00:00:00', 363, 3);

*/

With cte as (
    select user_id, 
    dense_rank() over(partition by user_id order by created_at) as drk
    from transactions
)
select count(distinct user_id) as num_of_upsold_customers
from cte
where drk > 1

-- another way
SELECT COUNT(*) AS num_of_upsold_customers
FROM (
	SELECT user_id
	FROM transactions
	GROUP BY user_id
	HAVING COUNT(DISTINCT DATE(created_at)) > 1
) as t