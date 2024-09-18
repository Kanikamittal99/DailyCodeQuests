CREATE TABLE int_orders(
 [order_number] [int] NOT NULL,
 [order_date] [date] NOT NULL,
 [cust_id] [int] NOT NULL,
 [salesperson_id] [int] NOT NULL,
 [amount] [float] NOT NULL
) 

INSERT int_orders ([order_number], [order_date], [cust_id], [salesperson_id], [amount]) VALUES (30, CAST(N'1995-07-14' AS Date), 9, 1, 460)
INSERT int_orders ([order_number], [order_date], [cust_id], [salesperson_id], [amount]) VALUES (10, CAST(N'1996-08-02' AS Date), 4, 2, 540)
INSERT int_orders ([order_number], [order_date], [cust_id], [salesperson_id], [amount]) VALUES (40, CAST(N'1998-01-29' AS Date), 7, 2, 2400)
INSERT int_orders ([order_number], [order_date], [cust_id], [salesperson_id], [amount]) VALUES (50, CAST(N'1998-02-03' AS Date), 6, 7, 600)
INSERT int_orders ([order_number], [order_date], [cust_id], [salesperson_id], [amount]) VALUES (60, CAST(N'1998-03-02' AS Date), 6, 7, 720)
INSERT int_orders ([order_number], [order_date], [cust_id], [salesperson_id], [amount]) VALUES (70, CAST(N'1998-05-06' AS Date), 9, 7, 150)
INSERT int_orders ([order_number], [order_date], [cust_id], [salesperson_id], [amount]) VALUES (20, CAST(N'1999-01-30' AS Date), 4, 8, 1800)

select * from int_orders;

-- 1. Window with no condition [Window = Full table]

select * ,
SUM(amount) over()
from int_orders;


-- 2. Window with condition [Overcoming the shortcoming of groupby]

select salesperson_id ,SUM(amount)  
from int_orders
group by salesperson_id;

-- sums all orders of a salesperson
select * ,                          -- select all
SUM(amount) over(partition by salesperson_id)  
from int_orders;

-- Provides running sum = Prev rows amount + current row amount
select * ,
SUM(amount) over(order by order_date)
from int_orders;

-- apply running sum to each salesperson_id window 
select * ,
SUM(amount) over(partition by salesperson_id order by order_date)
from int_orders;


-- 3. ROWS BETWEEN 

-- Rolling 3 Sum 
-- Current row + prev 2 rows
/*
For Row 1: A1
For Row 2: A2 + A1
For Row 3: A3 + A2 + A1
For Row 4: A4 + A3 + A2
*/
select * ,
SUM(amount) over(order by order_date rows between 2 preceding and current row)
from int_orders;


-- Prev 2 rows sum
/*
For Row 1: NULL
For Row 2: A1
For Row 3: A2 + A1
For Row 4: A3 + A2
*/
select * ,
SUM(amount) over(order by order_date rows between 2 preceding and 1 preceding)
from int_orders;


-- Prev row + current row + Next row
/*
For Row 1: A1 + A2
For Row 2: A1 + A2 + A3
For Row 3: A2 + A3 + A4
*/
select * ,
SUM(amount) over(order by order_date rows between 1 preceding and 1 following)
from int_orders;


-- current row + all prev rows
/*
For Row 1: A1 
For Row 2: A2 + A1
For Row 3: A3 + A2 + A1
For Row 4: A4 + A3 + A2 + A1
*/
select * ,
SUM(amount) over(order by order_date rows between unbounded preceding and current row)
from int_orders;


-- partition by
select * ,
SUM(amount) over(partition by salesperson_id order by order_date rows between 1 preceding and current row)
from int_orders;


-- 4. using lead/lag with using lead/lag keywords
select * ,
SUM(amount) over(order by order_date rows between 1 preceding and 1 preceding)
from int_orders;

select * ,
SUM(amount) over(order by order_date rows between 1 following and 1 following)
from int_orders;