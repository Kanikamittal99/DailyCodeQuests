-- https://www.interviewquery.com/questions/search-ratings

/*
You’re given a table that represents search results from searches on Facebook. 
The query column is the search term, the position column represents each position the search result came in, 
and the rating column represents the human rating of the search result from 1 to 5 where 5 is high relevance and 1 is low relevance.

Example:

Input:

search_results table

Column	Type
query	VARCHAR
result_id	INTEGER
position	INTEGER
rating	INTEGER
You want to be able to compute a metric that measures the precision of the ranking system based on position. 
For example, if the results for dog and cat are…

query	result_id	position	rating	notes
dog	    1000	    1	        2	    picture of hotdog 
dog	    998	        2	        4	    dog walking 
dog	    342	        3	        1	    zebra 
cat	    123	        1	        4	    picture of cat 
cat	    435	        2	        2	    cat memes 
cat	    545	        3	        1	    pizza shops 
…we would rank ‘cat’ as having a better search result ranking precision than ‘dog’ based on the correct sorting by rating.

Write a query to create a metric that can validate and rank the queries by their search result precision. 
Round the metric (avg_rating column) to 2 decimal places.

Output:

Column	Type
query	VARCHAR
avg_rating	FLOAT

*/

-- Creating Metric !!!
-- Our Metric should take into account 2 factors: rating and position





-- Method 1 : 
-- Weighted factor = Max(position) - Current Position
-- Metric = AVG(weight * rating)
WITH max_position AS (
    SELECT MAX(position) AS maxPos FROM search_results
),
add_weights AS (
    SELECT 
        sr.*, 
        (mp.maxPos+1 - sr.position) AS weight
    FROM 
        search_results sr
    CROSS JOIN 
        max_position mp  -- Join to bring in maxPos
)
SELECT query, avg(rating * weight) as avg_rating_column
FROM 
    add_weights 
GROUP BY 
    query;


--same as 
WITH add_weights AS (
    SELECT 
        *, 
        (SELECT MAX(position) AS maxPos FROM search_results)+1 - position AS weight
    FROM 
        search_results
  )
SELECT query, avg(rating * weight) as avg_rating_column
FROM 
    add_weights 
GROUP BY 
    query;





-- Method 2: Wont work well in case number of positions per query is not same
-- Ranking based on rating
with add_weights as (
    SELECT 
        query, 
        position, 
        rating, 
        row_number() over(partition by query order by rating desc) as weight
    FROM search_results
)
select 
    query, 
    round(avg(rating * weight), 2) as avg_rating
from add_weights
group by query





-- Method 3 : 
-- Weighted factor = 1/position
-- Metric = AVG(1/position * rating)
/*
For example, in a table of 2 search results for one query:

If the first result is rated a 5, and the last result is rated a 1:
        (position 1, rating 5): (1⁄1) * 5 = 5 

        (position 2, rating 1): (1⁄2) * 1 = 0.5

        = (5+0.5) / 2 = 2.75 (good)

If the first result is rated a 5, and the last result is also rated a 5:
        (position 1, rating 5): (1⁄1) * 5 = 5 

        (position 2, rating 5): (1⁄2) * 5 = 2.5

        = (5+2.5) / 2 = 3.75 (even better)

If the first result is rated a 1 and last result is rated a 5:
        (position 1, rating 1): (1⁄1) * 1 = 1 

        (position 2, rating 5): (1⁄2) * 5 = 2.5

        = (1+2.5) / 2 = 1.75 (bad)

*/
SELECT query, ROUND(AVG((1.0/position) * rating), 2) AS avg_rating
FROM search_results
GROUP BY query