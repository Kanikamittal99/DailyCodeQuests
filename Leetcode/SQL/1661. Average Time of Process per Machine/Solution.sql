--MS SQL Server
-- https://leetcode.com/problems/average-time-of-process-per-machine/


-- USING PIVOT()

With processes_time as (
    select machine_id, process_id, [end]- start as time_taken
    from(
        select machine_id, process_id, activity_type,timestamp from Activity
    ) bq
    pivot(
        min(timestamp)
	    for activity_type in([start],[end])
    )pq
)
select machine_id
, round(sum(time_taken)/count(process_id),3) as processing_time -- can use avg() as well
from processes_time
group by machine_id;


-- USING JOINS

select a1.machine_id, ROUND(AVG(a2.timestamp - a1.timestamp),3) as processing_time
from Activity a1
join Activity a2
on a1.process_id=a2.process_id
and a1.machine_id=a2.machine_id
and a1.timestamp<a2.timestamp
group by a1.machine_id;
