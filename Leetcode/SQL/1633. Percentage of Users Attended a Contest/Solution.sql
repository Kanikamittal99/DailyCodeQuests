-- MS SQL Server 
-- https://leetcode.com/problems/percentage-of-users-attended-a-contest/description

-- METHOD 1
SELECT contest_id, 
ROUND(COUNT(user_id)*100.0/(SELECT count(user_id) FROM Users),2) AS percentage
FROM Register
GROUP BY contest_id
ORDER BY percentage DESC, contest_id ASC


-- METHOD 2
DECLARE @total_users float;
SELECT @total_users = COUNT(user_id) FROM Users;

SELECT r.contest_id, ROUND((COUNT(u.user_id) / @total_users) * 100, 2) as percentage
FROM Users u 
JOIN Register r ON u.user_id = r.user_id 
GROUP BY r.contest_id
ORDER BY percentage DESC, r.contest_id ASC;