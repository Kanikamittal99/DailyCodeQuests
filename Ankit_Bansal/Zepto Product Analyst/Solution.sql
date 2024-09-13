-- https://www.youtube.com/watch?v=xS6iq3d8Eb4
-- Input: 1,2,3,4,5
-- Output: 1,2,2,3,3,3,4,4,4,4,5,5,5,5,5

use advanceSQL;

Create table numbers(n int);
delete from numbers;
insert into numbers values(1),(2),(3),(4),(5);

select * from numbers;

----------------------RECURSIVE CTE---------------------------

With recursive_cte as(
    select n, 1 as counter   --Base Query
    from numbers
    
    union ALL
    
    select n, counter + 1 as counter   -- Recursive Query with termination condition
    from recursive_cte
    where counter + 1 <= n 

)
select n
from recursive_cte
order by n;


----------------------USING CROSS JOIN---------------------------

select n1.n
from numbers as n1 cross join numbers as n2   
where n2.n <= n1.n 
order by n1.n;

-- OR
select n1.n
from numbers as n1 inner join numbers as n2 on n2.n <= n1.n 
order by n1.n;

-- CONS: Incorrect output when data has gaps
insert into numbers values(9);


----------------------USING HYBRID APPROACH (RECURSIVE CTE + CROSS JOIN)---------------------------

With recursive_cte as(               --generates table of 1 to max(n)
    select max(n) as n from numbers
    union ALL
    select n-1 as n from recursive_cte
    where n-1 >= 1
)
select n2.n, n1.n
from recursive_cte as n1 cross join numbers as n2
where n1.n <= n2.n
order by n2.n;


--- Can be solved with any table in DB

With recursive_cte as(
    select ROW_NUMBER() over(order by (select null)) as n 
    from sys.all_columns
)
select n2.n
from recursive_cte as n1 cross join numbers as n2
where n1.n <= n2.n
order by n2.n;


/* Output
n
1
2
2
3
3
3
4
4
4
4
5
5
5
5
5
9
9
9
9
9
9
9
9
9
*/