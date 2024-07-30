-- MS SQL Server
-- https://leetcode.com/problems/queries-quality-and-percentage/

select query_name, 
    round(avg(rating*1.0/position),2) as quality,
    round(sum(case when rating<3 then 1 else 0 end)*100.0/count(query_name),2) as poor_query_percentage 
from Queries
where query_name is not null
group by query_name
