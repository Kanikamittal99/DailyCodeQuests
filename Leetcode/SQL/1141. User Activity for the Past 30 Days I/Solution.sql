-- MS SQL Server
-- https://leetcode.com/problems/user-activity-for-the-past-30-days-i/


-- Using DATEADD()

select activity_date as day, count(distinct user_id) as active_users 
from Activity
where activity_date > dateadd(day, -30,'2019-07-27') AND activity_date <= '2019-07-27'
group by activity_date


-- Using DATEDIFF()

SELECT activity_date as day , COUNT(DISTINCT user_id ) as active_users 
FROM Activity 
WHERE DATEDIFF(day,activity_date,'2019-07-27')<30 and DATEDIFF(day,activity_date,'2019-07-27')>=0
GROUP BY activity_date