-- MS SQL Server

/*
    ^ -> not
    [a-zA-Z] -> upper or lower case letter
    [a-zA-Z0-9_.-] -> includes upper or lower case letter, numbers or _ or - or .
    '%' -> can be any number of occurences
*/

/*
Create table If Not Exists Users (user_id int, name varchar(30), mail varchar(50))
Truncate table Users
insert into Users (user_id, name, mail) values ('1', 'Winston', 'winston@leetcode.com')
insert into Users (user_id, name, mail) values ('2', 'Jonathan', 'jonathanisgreat')
insert into Users (user_id, name, mail) values ('3', 'Annabelle', 'bella-@leetcode.com')
insert into Users (user_id, name, mail) values ('4', 'Sally', 'sally.come@leetcode.com')
insert into Users (user_id, name, mail) values ('5', 'Marwan', 'quarz#2020@leetcode.com')
insert into Users (user_id, name, mail) values ('6', 'David', 'david69@gmail.com')
insert into Users (user_id, name, mail) values ('7', 'Shapiro', '.shapo@leetcode.com')
*/

SELECT user_id, name, mail
FROM Users
WHERE mail LIKE '[a-zA-z]%@leetcode.com'
-- '@leetcode.com' = 13 characters
-- Extracting characters before '@leetcode.com'
-- '%[^a-zA-Z0-9._-]%' :- checks that the extracted substring does not contain any characters that are not in the set [a-zA-Z0-9._-]
AND left(mail, LEN(mail)-13) NOT LIKE '%[^a-zA-Z0-9._-]%'