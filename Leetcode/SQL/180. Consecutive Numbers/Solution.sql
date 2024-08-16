-- https://leetcode.com/problems/consecutive-numbers/description/


/*
Input: 
Logs table:
+----+-----+
| id | num |
+----+-----+
| 1  | 1   |
| 2  | 1   |
| 3  | 1   |
| 4  | 2   |
| 5  | 1   |
| 6  | 2   |
| 7  | 2   |
+----+-----+
Output: 
+-----------------+
| ConsecutiveNums |
+-----------------+
| 1               |
+-----------------+
Explanation: 1 is the only number that appears consecutively for at least three times.
*/


-- Does not handle the case when id(auto-incremental) is missing numbers from between.
-- P>S Order of ID column is not fixed
-- | id | num |
-- | -- | --- |
-- | 1  | 1   |
-- | 2  | 1   |
-- | 4  | 1   |
-- | 5  | 1   |
-- | 6  | 2   |
-- | 7  | 1   |

WITH cte as(
    SELECT id, num, lead(num) OVER(ORDER BY id) as next, lag(num) OVER(ORDER BY id) as prev
    FROM logs
)
SELECT DISTINCT num as ConsecutiveNums 
FROM cte
WHERE num = next AND next = prev



-- PASSES ALL CASES
-- Logic: 2 columns with numbers incrementing by 1 >>  When subtracted will reuslt in same number UNLESS there is a discrepancy in one of those columns
-- Like one column incremented by +2 or +3 while other column incrementing correctly by +1 all over.

-- Intermediate result
-- | id | num | rn | rw |
-- | -- | --- | -- | -- |
-- | 1  | 1   | 1  | 0  |
-- | 2  | 1   | 2  | 0  |
-- | 3  | 1   | 3  | 0  |
-- | 5  | 1   | 4  | 1  |
-- | 4  | 2   | 1  | 3  |
-- | 6  | 2   | 2  | 4  |
-- | 7  | 2   | 3  | 4  |


DECLARE @times INT = 3;

WITH cte AS 
(
    SELECT id , num , id - row_number() OVER(PARTITION BY num ORDER BY id) AS rn 
    FROM logs
)
SELECT distinct num AS consecutivenums 
FROM cte 
GROUP BY num, rn  -- to make distinction
HAVING count(rn) >= @times;



-- Using JOINS

SELECT DISTINCT l1.num AS ConsecutiveNums
FROM logs l1, logs l2, logs l3
WHERE l1.id = l2.id + 1 
AND l1.num = l2.num
AND l1.id = l3.id + 2 
AND l1.num = l3.num;


