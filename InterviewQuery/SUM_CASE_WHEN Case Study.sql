--https://www.interviewquery.com/p/sum-case-when-sql


-- SUM + CASE WHEN Usecases


-- Question: 
--Suppose we want to found out total amount spent for each Allowance, Basic, House category and a total for all others.

-- creates new columns for each case when applying conditions per row
SELECT  
case when [trns_type] = 'Allowance' then amount else 0 end as alw_amt,
case when [trns_type] = 'Basic' then amount else 0 end as basic_amt,
case when [trns_type] = 'House' then amount else 0 end as house_amt,
case when [trns_type] not in('Allowance','Basic','House') then amount else 0 end as extra_amt
FROM [TechTFQ_SQL_Challenges].[dbo].[emp_transaction];

-- outputs correct data
-- aggregates column data and provides single output( since no partiton/groupby)
-- Same as - select sum(amount) from emp_transaction ;
SELECT  
sum(case when [trns_type] = 'Allowance' then amount else 0 end) as alw_amt,
sum(case when [trns_type] = 'Basic' then amount else 0 end) as basic_amt,
sum(case when [trns_type] = 'House' then amount else 0 end) as house_amt,
sum(case when [trns_type] not in('Allowance','Basic','House') then amount else 0 end) as extra_amt
FROM [TechTFQ_SQL_Challenges].[dbo].[emp_transaction];


-- aggregates data but ouputs by trns_type - leaving zeroes in all other rows not included in calculation
-- output : trns_type, alw_amount, so on
SELECT trns_type,
sum(case when [trns_type] = 'Allowance' then amount else 0 end) as alw_amt,
sum(case when [trns_type] = 'Basic' then amount else 0 end) as basic_amt,
sum(case when [trns_type] = 'House' then amount else 0 end) as house_amt,
sum(case when [trns_type] not in('Allowance','Basic','House') then amount else 0 end) as extra_amt
FROM [TechTFQ_SQL_Challenges].[dbo].[emp_transaction]
group by trns_type;


-- outputs correct data leaving no gaps
SELECT emp_id,
sum(case when [trns_type] = 'Allowance' then amount else 0 end) as alw_amt,
sum(case when [trns_type] = 'Basic' then amount else 0 end) as basic_amt,
sum(case when [trns_type] = 'House' then amount else 0 end) as house_amt,
sum(case when [trns_type] not in('Allowance','Basic','House') then amount else 0 end) as extra_amt
FROM [TechTFQ_SQL_Challenges].[dbo].[emp_transaction]
group by emp_id;



--- HR Case Study
-- Suppose we have a table of transactions with each transaction belonging to different departments within a company. We want to calculate the total spend for ‘IT’, ‘HR’, and ‘Marketing’, and also have a total for ‘Other’ departments, grouped by quarters.
use AdvanceSQL;
select * from transactions

SELECT CEILING(DATEPART(QUARTER,transaction_date)) as sales_quarter,   --CEILING(MONTH(transaction_date)*1.0/3) 
sum(case when [department] = 'IT' then amount else 0 end) as IT_amt,
sum(case when [department] = 'HR' then amount else 0 end) as HR_amt,
sum(case when [department] = 'Marketing' then amount else 0 end) as Marketing_amt,
sum(case when [department] not in('IT','HR','Marketing') then amount else 0 end) as others
FROM [transactions]
group by CEILING(DATEPART(QUARTER,transaction_date));


-- Defining quarters as per needs
-- Let's say quarter 1 starts from April

With define_quarter as(
    SELECT department, amount,
  CASE 
    WHEN MONTH(transaction_date) BETWEEN 1 AND 3 THEN 'Q4'
    WHEN MONTH(transaction_date) BETWEEN 4 AND 6 THEN 'Q1'
    WHEN MONTH(transaction_date) BETWEEN 7 AND 9 THEN 'Q2'
    WHEN MONTH(transaction_date) BETWEEN 10 AND 12 THEN 'Q3'
  END AS sales_quarter
  from transactions
)
SELECT sales_quarter,
  SUM(CASE WHEN department = 'IT' THEN amount ELSE 0 END) AS ITSales,
  SUM(CASE WHEN department = 'HR' THEN amount ELSE 0 END) AS HRSales,
  SUM(CASE WHEN department = 'Marketing' THEN amount ELSE 0 END) AS MarketingSales,
  SUM(CASE WHEN department NOT IN ('IT', 'HR', 'Marketing') THEN amount ELSE 0 END) AS OtherSales
FROM
  define_quarter
GROUP BY
  sales_quarter;


-- HR Case Study
/*
Let’s consider a scenario where we have an employee table, and we want to calculate the total salary expenditure for different job titles while also considering overtime. 
We want to sum up the regular salaries and the overtime payments separately and also include a total sum for each job title.

CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    job_title VARCHAR(50),
    salary DECIMAL(10, 2),
    overtime_hours INT,
    overtime_rate DECIMAL(10, 2)
);
INSERT INTO employees (employee_id, job_title, salary, overtime_hours, overtime_rate) VALUES
(1, 'Software Developer', 7000.00, 5, 50.00),
(2, 'Software Developer', 7200.00, 3, 50.00),
(3, 'Graphic Designer', 5000.00, 10, 30.00),
(4, 'Sales Associate', 4500.00, 0, 0.00),
(5, 'Sales Associate', 4600.00, 2, 45.00),
(6, 'Graphic Designer', 5100.00, 8, 30.00),
(7, 'Human Resources', 4500.00, 0, 0.00);
*/

With cte as (
  select job_title, salary, overtime_hours * overtime_rate AS OVERTTIME_PAY
  from employees
)
select job_title, SUM(salary) as sal, SUM(OVERTTIME_PAY) as Ovt_pay, SUM(salary) + SUM(OVERTTIME_PAY) as total
from cte 
group by job_title

-- adding bonuses based on title 
SELECT
  job_title,
  SUM(salary) AS TotalSalaries,
  SUM(overtime_hours * overtime_rate) AS TotalOvertimePayments,
  SUM(
    salary + 
    (overtime_hours * overtime_rate) + 
    (CASE 
      WHEN job_title = 'Software Developer' THEN 500 
      WHEN job_title = 'Graphic Designer' THEN 300 
      ELSE 200 
     END)
  ) AS TotalCompensation
FROM
  employees
GROUP BY
  job_title;



-- Electronics Retail Case Study
/*
An electronics retail company tracks its sales and wants to run a special performance analysis.
They aim to categorize sales into different bonus eligibility groups based on the amount of sales and the region where the sale occurred. The conditions for categorization are:

Premium Sales: Any sales that are over $2000, or any sales in the “East” region regardless of the amount, are considered premium. These sales receive a higher commission.
Standard Sales: Any sales between $1000 and $2000, except those in the “East” region, are considered standard. They receive a standard commission.
Promotional Sales: Sales made in the “West” region or during the promotional period (June to July), regardless of the amount, are considered promotional and are eligible for special discounts or offers in future transactions.
The company wants a report that sums these amounts by region to help with financial planning and bonus allocations.

CREATE TABLE sales (
    sale_id INT PRIMARY KEY,
    employee_id INT,
    product_id INT,
    sale_amount DECIMAL(10, 2),
    sale_date DATE,
    region VARCHAR(50)
);
INSERT INTO sales (sale_id, employee_id, product_id, sale_amount, sale_date, region) VALUES
(1, 101, 30, 1200.00, '2023-06-15', 'East'),
(2, 102, 22, 800.00, '2023-06-17', 'West'),
(3, 103, 11, 2300.00, '2023-06-25', 'East'),
(4, 101, 45, 400.00, '2023-07-03', 'North'),
(5, 102, 30, 1800.00, '2023-07-19', 'East'),
(6, 104, 25, 1500.00, '2023-07-21', 'South'),
(7, 103, 22, 900.00, '2023-08-05', 'West'),
(8, 101, 11, 1600.00, '2023-08-12', 'East');
*/

  SELECT
  region,
  SUM(sale_amount) AS TotalSales,
  SUM(
    CASE 
      WHEN sale_amount > 2000 OR region = 'East' THEN sale_amount
      ELSE 0 
    END
  ) AS PremiumSales,
  SUM(
    CASE 
      WHEN sale_amount BETWEEN 1000 AND 2000 AND region != 'East' THEN sale_amount
      ELSE 0 
    END
  ) AS StandardSales,
  SUM(
    CASE 
      WHEN region = 'West' OR (sale_date BETWEEN '2023-06-01' AND '2023-07-31') THEN sale_amount
      ELSE 0 
    END
  ) AS PromotionalSales
FROM
  sales
GROUP BY
  region;



-- PAYMENTS CASE STUDY
/*
5. How many customers that signed up in January 2020 had a combined (successful) sending and receiving volume greater than $100 in their first 30 days?
You’re given two tables, payments and users. The payments table holds all payments between users with the payment_state column consisting of either "success" or "failed". 
Note: The sender_id and recipient_id both represent the user_id.

CREATE TABLE users (
    id INTEGER PRIMARY KEY,
    created_at DATETIME
);
CREATE TABLE payments (
    payment_id INTEGER PRIMARY KEY,
    sender_id INTEGER,
    recipient_id INTEGER,
    created_at DATETIME,
    payment_state VARCHAR(10),
    amount_cents INTEGER
);
INSERT INTO users (id, created_at) VALUES
(1, '2020-01-05 10:00:00'),
(2, '2020-01-10 12:30:00'),
(3, '2020-01-15 09:15:00'),
(4, '2020-01-20 11:45:00'),
(5, '2020-02-01 14:00:00'),  -- This user should not be included in the result
(6, '2020-01-25 08:30:00');
INSERT INTO payments (payment_id, sender_id, recipient_id, created_at, payment_state, amount_cents) VALUES
(1, 1, 2, '2020-01-06 10:00:00', 'success', 5000),  -- User 1 to User 2
(2, 1, 3, '2020-01-07 11:00:00', 'success', 6000),  -- User 1 to User 3
(3, 2, 1, '2020-01-11 13:00:00', 'success', 4000),  -- User 2 to User 1
(4, 2, 4, '2020-01-12 14:00:00', 'failed', 3000),   -- User 2 to User 4 (failed)
(5, 3, 1, '2020-01-16 15:00:00', 'success', 2000),  -- User 3 to User 1
(6, 4, 1, '2020-01-21 16:00:00', 'success', 1500),  -- User 4 to User 1
(7, 1, 5, '2020-01-28 17:00:00', 'success', 7000),  -- User 1 to User 5
(8, 6, 1, '2020-01-30 18:00:00', 'success', 8000),  -- User 6 to User 1
(9, 1, 2, '2020-02-06 10:00:00', 'success', 1000); -- need to be excluded
*/

-- join payments,  users 
-- on receipientid and senderid with userid
-- where month = 1 and year =2020 and payment_state = success
-- and payments.created_at < dateadd(30, created_at) 
-- group by user_id having sum > 100
-- select *, sum(amount)
-- Outer query:
-- select count(*)

--select *, DATEADD(DAY,30,created_at) from users

With cte as (
  select u.id,sum(p.amount_cents) as total
FROM payments as p join users as u
on p.sender_id = u.id or p.recipient_id = u.id  --2 rows per payment id. one for sender_id <-> userid and other for recipient_id <-> userid per paymentid. 
where MONTH(u.created_at) = 1 
  and YEAR(u.created_at) = 2020
  and p.payment_state = 'success' 
  and p.created_at <= DATEADD(DAY,30,u.created_at)
  group by u.id
having sum(p.amount_cents) > 100  -- since amount is in cents. 1$ = 100 cents
)
select count(id) as num_users
from cte   


-- another way
WITH prep_users AS (
    SELECT 
        id, 
        created_at, 
        DATEADD(day,30,created_at) AS end_dt
    FROM users
    WHERE MONTH(created_at) = 1 
  and YEAR(created_at) = 2020
),
cte AS (
    SELECT 
        u.id, 
        SUM(p.amount_cents) AS amount_cents
    FROM payments p
    JOIN prep_users u ON u.id = p.sender_id OR u.id = p.recipient_id
    WHERE 
        p.payment_state = 'success'
        AND p.created_at <= u.end_dt
    GROUP BY u.id
    HAVING SUM(amount_cents) > 100
)
SELECT COUNT(id) AS num_customers
FROM cte

/*
Points to Remember:
- Ordering conditional logic: 
  The ordering of conditions in a CASE expression is significant, as the conditions are evaluated in the order they are written. 
  Once a condition is met, the CASE expression will return the corresponding result and not evaluate any subsequent conditions.

- Handling NULLs: The CASE expression within an aggregate function like SUM must be carefully written to handle NULL values appropriately, as SUM disregards rows with NULLs.
  If a row contains a NULL value in the column being summed, it is not included in the calculation. 

-Efficiency: The CASE statement is an additional operation on each row, which can introduce overhead, especially for a large dataset. 
  Use a WHERE clause to limit the rows whenever possible before implementing CASE logic. This can help the query planner to use an index to filter rows first, thus reducing the number of rows over which the CASE needs to be evaluated.
*/