-- Here is the leetcode problem link:
-- https://leetcode.com/problems/destination-city/description/
-- https://www.youtube.com/watch?v=XssFpKFSNFw


CREATE TABLE travel_data (
    customer VARCHAR(10),
    start_loc VARCHAR(50),
    end_loc VARCHAR(50)
);

INSERT INTO travel_data (customer, start_loc, end_loc) VALUES
    ('c1', 'New York', 'Lima'),
    ('c1', 'London', 'New York'),
    ('c1', 'Lima', 'Sao Paulo'),
    ('c1', 'Sao Paulo', 'New Delhi'),
    ('c2', 'Mumbai', 'Hyderabad'),
    ('c2', 'Surat', 'Pune'),
    ('c2', 'Hyderabad', 'Surat'),
    ('c3', 'Kochi', 'Kurnool'),
    ('c3', 'Lucknow', 'Agra'),
    ('c3', 'Agra', 'Jaipur'),
    ('c3', 'Jaipur', 'Kochi');


select * from travel_data;


-- Method 1

With start_cte as
(
select customer, start_loc 
from travel_data as td
where start_loc not in (select end_loc from travel_data where customer=td.customer)
),
end_cte as(
select customer, end_loc 
from travel_data as td
where end_loc not in (select start_loc from travel_data where customer=td.customer)
)
select s.customer, 
s.start_loc, 
e.end_loc, 
(select COUNT(customer)+1 from travel_data where customer=s.customer) as total_visited 
from start_cte as s join end_cte as e on s.customer = e.customer;


--- Method 2
With cte as(
select customer, start_loc as loc,'start_loc' as identifier from travel_data 
union all
select customer, end_loc as loc,'end_loc' as identifier from travel_data 
),
cte2 as(
select *, COUNT(*) over(partition by customer,loc) as ct
from cte 
)
select customer, 
Max(case when identifier = 'start_loc' then loc end) AS start_pt,
Max(case when identifier = 'end_loc' then loc end) AS end_pt,
(select COUNT(customer)+1 from travel_data where customer=cte2.customer) as total_visited
from cte2 
where ct=1
group by customer;



-- Method 3
-- Using SELF JOIN

With start_cte as
(
select td1.customer, td1.start_loc
from travel_data as td1 left join travel_data as td2 on td1.customer = td2.customer and td1.start_loc=td2.end_loc
where td2.end_loc is null
),
end_cte as(
select td1.customer, td1.end_loc
from travel_data as td1 left join travel_data as td2 on td1.customer = td2.customer and td1.end_loc=td2.start_loc
where td2.start_loc is null
)
select s.customer, s.start_loc, e.end_loc, (select COUNT(customer)+1 from travel_data where customer=s.customer) as total_visited
from start_cte as s join end_cte as e on s.customer = e.customer;


--- Clubbing joins -removing CTE

select td1.customer, 
max(case when td2.start_loc IS null then td1.start_loc end) AS start_pt,
max(case when td3.end_loc IS null then td1.end_loc end) AS end_pt
from travel_data as td1 
left join travel_data as td2 on td1.customer = td2.customer and td1.start_loc=td2.end_loc
left join travel_data as td3 on td1.customer = td3.customer and td1.end_loc=td3.start_loc
group by td1.customer;


-- Method 4
-- Using Except

with start_cte as (
select customer,start_loc
from travel_data
except
select customer,end_loc
from travel_data
)
,end_cte as (
select customer,end_loc
from travel_data
except
select customer,start_loc
from travel_data
)
select s.*,e.end_loc 
from start_cte s
inner join end_cte e  on s.customer=e.customer