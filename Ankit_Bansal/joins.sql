use sample1

create table table_1(id varchar(2))
create table table_2(id varchar(2))

insert into table_1(id) values
(1),
(1),
(2),
(2),
(3),
(3),
(4)

insert into table_2(id) values
(1),
(2),
(3),
(5),
(6)

select * from table_2

/*
Inner 6
Left/ left outer 7
Right 8 -> left + right - inner
All the single rows from right have 2 rows in left
Full outer 9
Cross 35

*/

-- left + right - all the repeat ids even from left join which are needed in our result
--incorrect
select *
from table_1 as t1
LEFT JOIN table_2 as t2 
on t1.id = t2.id
union 
select *
from table_1 as t1
right JOIN table_2 as t2 
on t1.id = t2.id


-- FULL OUTER JOIN 
-- correct
select *
from table_1 as t1
LEFT JOIN table_2 as t2 
on t1.id = t2.id
where t2.id is null
union 
select *
from table_1 as t1
right JOIN table_2 as t2 
on t1.id = t2.id
where t1.id is null
union all
select *
from table_1 as t1
inner JOIN table_2 as t2 
on t1.id = t2.id

-- correct
select *
from table_1 as t1
LEFT JOIN table_2 as t2 
on t1.id = t2.id
union all
select *
from table_1 as t1
right JOIN table_2 as t2 
on t1.id = t2.id
where t1.id is null


select * from 