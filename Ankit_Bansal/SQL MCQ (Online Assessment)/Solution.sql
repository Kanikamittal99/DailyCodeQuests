/*		
    >>> Online Assessment of a product based company
-- goal.teamid is the team id of the player who scored the goal
-- List every game with the goals scored by each team.
-- Result set: mdate, team1, score, team2, score

https://www.youtube.com/watch?v=lyW5U9RNvgc
*/

--drop table game
--drop table goal
CREATE TABLE team (
    id CHAR(1) PRIMARY KEY,
    teamname VARCHAR(50),
    coach VARCHAR(50)
);

CREATE TABLE goal (
    matchid INT,
    teamid CHAR(1),
    player VARCHAR(50),
    goal_time INT
);

CREATE TABLE game (
    id INT PRIMARY KEY,
    mdate DATE,
    stadium VARCHAR(50),
    team1 CHAR(1),
    team2 CHAR(1)
);
INSERT INTO team (id, teamname, coach) VALUES 
('A', 'Team A', 'Coach A'),
('B', 'Team B', 'Coach B'),
('C', 'Team C', 'Coach C'),
('D', 'Team D', 'Coach D');

INSERT INTO goal (matchid, teamid, player, goal_time) VALUES 
(101, 'A', 'A1', 17),
(101, 'A', 'A9', 58),
(101, 'B', 'B7', 89),
(102, 'D', 'D10', 63);

INSERT INTO game (id, mdate, stadium, team1, team2) VALUES 
(101, '2019-01-04', 'stadium 1', 'A', 'B'),
(102, '2019-01-04', 'stadium 3', 'D', 'E'),
(103, '2019-01-10', 'stadium 1', 'A', 'C'),
(104, '2019-01-13', 'stadium 2', 'B', 'E');

select * from team
select * from goal
select * from game


-- Solution
use AdvanceSQL;
select mdate, team1, SUM(case when goal.teamid = game.team1 then 1 else 0 end) as t1_score,
team2, SUM(case when goal.teamid = game.team2 then 1 else 0 end) as t2_score
from game left join goal on game.id = goal.matchid
group by id,mdate, team1, team2