/*
Write a solution to swap the seat id of every two consecutive students.
If the number of students is odd, the id of last student is not swapped.
*/
drop table seats
CREATE TABLE seats
(
    id INT,
    student VARCHAR(10)
);

INSERT INTO seats
VALUES
    (1, 'Amit'),
    (2, 'Deepa'),
    (3, 'Rohit'),
    (4, 'Anjali'),
    (5, 'Neha'),
    (6, 'Sanjay'),
    (7, 'Priya');

select *
from seats;

-- METHOD 1 :  Considering id is starting from odd value

select id, student,
    isnull(case when id%2=0 then lag(id) over(order by id) 
        else lead(id) over(order by id) 
        end,id) as flip_id
from seats 


-- METHOD 2: Assumming ids are consecutive

select *,
case when id  = (select MAX(id) from seats) and id%2=1 then id
    when id%2 = 0 then id-1
    else id+1
    end as new_id
from seats


-- METHOD 3: When ids are not consecutive

insert into seats values(9,'Sonia')
insert into seats values(13,'Sonia')


With cte as(
    select *,
    ROW_NUMBER() over(order by id) as rn
    from seats
)
select *,
    case when rn%2=0 then lag(id) over(order by id) 
    else lead(id,1,id) over(order by id)     -- 3rd argument is the default value to show when lead gives null
    end as flip
from cte 


-- UPDATE TABLE 


With cte as(
    select *,
        ROW_NUMBER() over(order by id) as rn
    from seats
),
new_seats as(
    select *,
        case when rn%2=0 then lag(id) over(order by id) 
        else lead(id,1,id) over(order by id)     -- 3rd argument is the default value to show when lead gives null
        end as flip_id
    from cte 
)
update seats 
set id = new_seats.flip_id
from new_seats
where seats.id = new_seats.id



select * from seats 


-- ANOTHER 
update seats
set seats.id = new_seats.new_id
from (
select *,
    case when id  = (select MAX(id) from seats) and id%2=1 then id
        when id%2 = 0 then id-1
        else id+1
        end as new_id
from seats
) new_seats
where seats.id = new_seats.new_id 

with cte as (
select CEILing(COUNT(*)/2) as cnt from seats
),cte2 as(
    select id, student
    NTILE((select CEILing(COUNT(*)/2) as cnt from seats
)) over(order by id) as seat_grp
    from seats;
)
select id,student,
ROW_NUMBER() over(partition by seat_grp order by seat_grp,id) as rn
from cte2

select *,ntile(3) over(order by id)
from seats