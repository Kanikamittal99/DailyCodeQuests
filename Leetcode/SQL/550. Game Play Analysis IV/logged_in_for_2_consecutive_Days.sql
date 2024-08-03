-- https://leetcode.com/problems/game-play-analysis-iv


-- OPTIMIZED
-- Uses a temporary variable to store the total count and a join operation. 
-- Reducing the overhead of multiple calculations and making use of indexing more effectively.

DECLARE @totalplayers INT;
SELECT @totalplayers = COUNT(DISTINCT player_id) from Activity;
WITH cte as (
    SELECT player_id, MIN(event_date) as first_login FROM Activity GROUP BY player_id
)
SELECT ROUND(CAST(COUNT(a1.player_id) as decimal(10,2)) / @totalplayers,2) as fraction FROM Activity as a1 INNER JOIN cte as a2
ON a1.player_id = a2.player_id AND DATEDIFF(day, a1.event_date, a2.first_login) = -1


-- OPTIMIZED (If Indexes present)
-- It performs conditional counting and division to calculate the fraction.
-- Likely to perform well if the table is indexed properly, especially on player_id and event_date.

WITH dates AS (
    SELECT
        player_id, event_date,
        LEAD(event_date, 1, NULL) OVER(PARTITION BY player_id ORDER BY event_date) AS post_date,
        RANK() OVER(PARTITION BY player_id ORDER BY event_date) AS rank
    FROM Activity
)
SELECT
    ROUND(
        COUNT(CASE WHEN (DATEDIFF(day, event_date, post_date) = 1 AND rank = 1) THEN 1 END) * 1.0
        / COUNT(CASE WHEN rank = 1 THEN 1 END), 2
    ) AS fraction
FROM dates;


-- ANOTHER METHOD
with cte as (
    select player_id, min(event_date) as first_login
    from activity
    group by player_id
)
select 
round(sum(case when datediff(day, first_login,event_date)=1 then 1 else 0 end)*1.0/ count(distinct a.player_id),2) as fraction
from cte
join activity a
on a.player_id = cte.player_id


-- NOT OPTIMIZED
-- Uses a subquery to get the total count of distinct players, which can be costly depending on the size of the data.
--  Involves distinct counting and a filter on the window function output

WITH cte AS (
    SELECT 
        player_id,
        LEAD(event_date) OVER(PARTITION BY player_id ORDER BY event_date ASC) AS next_date,
        MIN(event_date) OVER(PARTITION BY player_id ORDER BY event_date ASC) AS first_logged_in_date
    FROM Activity
)
SELECT 
    ROUND(
        COUNT(DISTINCT player_id) * 1.0 / (SELECT COUNT(DISTINCT player_id) FROM Activity), 2
    ) AS fraction
FROM cte
WHERE next_date = DATEADD(dd, 1, first_logged_in_date)


