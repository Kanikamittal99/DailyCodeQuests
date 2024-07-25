-- MS SQL Server 
-- https://leetcode.com/problems/monthly-transactions-i/description/ 

-- else null should be used instead of else 0 while calculating approved_count
-- 126 style refers to yyyy-mm-dd type, so extracting only 7 characters out of this date

select convert(varchar(7), trans_date, 126) as month,country,count(id) as trans_count, sum(amount) as trans_total_amount, 
count(case when state='approved' then 1 else null end) as approved_count,
sum(case when state='approved' then amount else 0 end) as approved_total_amount
from Transactions
group by convert(varchar(7), trans_date, 126),country