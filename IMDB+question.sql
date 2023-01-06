USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/

-- Segment 1:

-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

/* 
Query to find the total number of rows in each table of the schema:
There are 6 tables of the schema 
They are 
1.directors_mapping, 2.genre, 3.movie, 4.names, 5.ratings, 6.role_mapping
Using COUNT(*) function, we're going to find the number of rows in each table.
The COUNT(*) returns the number of rows including duplicate, non-NULL and NULL rows.
*/

WITH director_mapping_summary
     AS (SELECT Count(*) AS d
         FROM   director_mapping) 
SELECT 'director_mapping' AS Table_of_Schema,
       d                  AS No_of_rows
FROM   director_mapping_summary
-- INSIGHT: Number of rows in director_mapping table = 3867
UNION
(
WITH genre_summary
     AS (SELECT Count(*) AS g
         FROM   genre)
SELECT 'genre' AS Table_of_Schema,
       g       AS No_of_rows
 FROM   genre_summary)
-- INSIGHT: Number of rows in genre table = 14662
UNION
(
WITH movie_summary
     AS (SELECT Count(*) AS m
         FROM   movie)
SELECT 'movie' AS Table_of_Schema,
       m       AS No_of_rows
 FROM   movie_summary)
-- INSIGHT: Number of rows in movie table = 7997
UNION
(
WITH names_summary
     AS (SELECT Count(*) AS n
         FROM   names)
SELECT 'names' AS Table_of_Schema,
       n       AS No_of_rows
 FROM   names_summary)
-- INSIGHT: Number of rows in names table = 25735
UNION
(
WITH ratings_summary
     AS (SELECT Count(*) AS r
         FROM   ratings)
SELECT 'ratings' AS Table_of_Schema,
       r         AS No_of_rows
 FROM   ratings_summary)
-- INSIGHT: Number of rows in ratings table = 7997
UNION
(
WITH role_mapping_summary
     AS (SELECT Count(*) AS r_m
         FROM   role_mapping)
SELECT 'role_mapping' AS Table_of_Schema,
       r_m            AS No_of_rows
 FROM   role_mapping_summary);
-- INSIGHT: Number of rows in role_mapping table = 15615


-- Q2. Which columns in the movie table have null values?
-- Type your code below:

-- Using CASE statement with IS NULL, we're going to find which column in the movie table has Null values.
SELECT Sum(CASE
             WHEN id IS NULL THEN 1
             ELSE 0
           END) AS id_null_count,
       Sum(CASE
             WHEN title IS NULL THEN 1
             ELSE 0
           END) AS title_null_count,
       Sum(CASE
             WHEN year IS NULL THEN 1
             ELSE 0
           END) AS year_null_count,
       Sum(CASE
             WHEN date_published IS NULL THEN 1
             ELSE 0
           END) AS date_published_null_count,
       Sum(CASE
             WHEN duration IS NULL THEN 1
             ELSE 0
           END) AS duration_null_count,
       Sum(CASE
             WHEN country IS NULL THEN 1
             ELSE 0
           END) AS country_null_count,
       Sum(CASE
             WHEN worlwide_gross_income IS NULL THEN 1
             ELSE 0
           END) AS worlwide_gross_income_null_count,
       Sum(CASE
             WHEN languages IS NULL THEN 1
             ELSE 0
           END) AS languages_null_count,
       Sum(CASE
             WHEN production_company IS NULL THEN 1
             ELSE 0
           END) AS production_company_null_count
FROM   movie; 
/* INSIGHT:
There are 
20 null values in country column, 
3724 null values in worlwide_gross_income column, 
194 null values in languages column, and 
528 null values in production_company column.*/


-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

-- 1. To find the total number of movies released each year:
SELECT year,
       Count(title) AS number_of_movies
FROM   movie
GROUP  BY year
ORDER  BY year; 
/**INSIGHT: The highest no of movies were released in the year 2017.**/


-- To find the number of movies released each month:
SELECT Month(date_published) AS month_num,
       Count(*)              AS number_of_movies
FROM   movie
GROUP  BY month_num
ORDER  BY month_num; 

/**INSIGHT: The highest no of movies are released in the month of MARCH.**/


/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Let's find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

SELECT year,
       Count(title) AS number_of_movies
FROM   movie
WHERE  ( country LIKE '%INDIA%'
          OR country LIKE '%USA%' )
       AND year = 2019; 
-- INSIGHT: 1059 movies were produced in the USA or India in the year 2019.


/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

SELECT DISTINCT genre
FROM genre;
-- INSIGHT: There are 13 genres present in the Data Set.


/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

SELECT genre,
       year,
       Count(m.id) AS number_of_movies
FROM   movie AS m
       INNER JOIN genre AS g
               ON g.movie_id = m.id
WHERE  year = 2019
GROUP  BY genre
ORDER  BY number_of_movies DESC
LIMIT  1; 
/* -----------------------------------------------------------------------------------------------+
INSIGHTS: 1.'DRAMA' genre had the highest number of movies produced in the last year i.e., in 2019.
		  2. The number of movies of DRAMA genre, produced in the year 2019 = 1078. 
+--------------------------------------------------------------------------------------------------*/


-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

-- As we need only the highest number of movies produced overall, we can use LIMIT clause here.
SELECT genre,
       Count(movie_id) AS number_of_movies
FROM   genre
GROUP  BY genre
ORDER  BY number_of_movies DESC
LIMIT  1; 
-- INSIGHT: DRAMA genre had the highest number of movies produced overall and the number of movies of this genre was 4285.


/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

/* ----------------------------------------------------------------------------------------------------------------------------+
1. Genre table can be used to find the number of movies which belong to only one genre.
2. Using GROUP BY Statement, let's group the rows having the same values into summary rows by movie_id column from genre table.
3. Using CTE, we can find the exact number of movies which belong to only one genre.
+-------------------------------------------------------------------------------------------------------------------------------*/

WITH gre_one
     AS (SELECT movie_id,
                Count(DISTINCT genre) AS number_of_movies
         FROM   genre
         GROUP  BY movie_id
         HAVING number_of_movies = 1)
SELECT Count(movie_id) AS movies_of_one_genre
FROM   gre_one; 
-- INSIGHT: 3289 movies belong to only one genre.


/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

/* -------------------------------------------------------------------------------------------------+
1. To select data from 'genre' and 'movie' tables, INNER JOIN Clause can be used.
2. Using GROUP BY Statement, let's group the rows having the same values into summary rows by genre.
+----------------------------------------------------------------------------------------------------*/

SELECT genre,
       Round(Avg(duration), 2) AS avg_duration_in_mins
FROM   movie AS m
       INNER JOIN genre AS g
               ON g.movie_id = m.id
GROUP  BY genre
ORDER  BY avg_duration_in_mins DESC; 
/**INSIGHTs: 1.The highest Average Duration is 112.88 minutes and it's of Action genre.
          2. The least Average Duration is 92.72 minutes and it's of Horror genre.**/


/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

/* -------------------------------------------------------------------------------------------------+
1. Genre table can be used to find the rank of the ‘thriller’ genre of movies.
2. Using GROUP BY Statement, let's group the rows having the same values into summary rows by genre.
3. Using CTE, we can find the rank of the ‘thriller’ genre of movies.
+----------------------------------------------------------------------------------------------------*/

WITH gen_rank_table
     AS (SELECT genre,
                Count(movie_id)                    AS movie_count,
                Rank()
                  OVER(
                    ORDER BY Count(movie_id) DESC) AS genre_rank
         FROM   genre
         GROUP  BY genre)
SELECT *
FROM   gen_rank_table
WHERE  genre = 'Thriller'; 
/*
+------------+-------------+------------+
|   genre	 | movie_count | genre_rank |
+------------+-------------+------------+	
|   Thriller |	1484	   |     3      |
+------------+-------------+------------+
INSIGHT: 1. The rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced = 3 
         2. The number of movies, of Thriller genre, produced = 1484 */
         

/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/

-- Segment 2:

-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

-- We can use 'MAX' and 'MIN' functions for getting the required values.

SELECT Min(avg_rating)    AS min_avg_rating,
       Max(avg_rating)    AS max_avg_rating,
       Min(total_votes)   AS min_total_votes,
       Max(total_votes)   AS max_total_votes,
       Min(median_rating) AS min_median_rating,
       Max(median_rating) AS max_median_rating
FROM   ratings; 


/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too

-- Finding the rank of each movie based on its Average Rating.

-- We can get top 10 movies using Derived Table Expression and WHERE Clause.
SELECT *
FROM   (SELECT title,
               avg_rating,
               Row_number()
                 OVER(
                   ORDER BY avg_rating DESC) AS movie_rank
        FROM   ratings AS r
               INNER JOIN movie AS m
                       ON m.id = r.movie_id) AS derived_tab
WHERE  movie_rank <= 10; 
-- INSIGHTS: There are 2 movies with Average Rating 10. They are 'Kirket' & 'Love in Kilnerry'


/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have

SELECT median_rating,
       Count(movie_id) AS movie_count
FROM   ratings
GROUP  BY median_rating
ORDER  BY median_rating DESC; 
-- INSIGHT: The number of movies with median rating 7 is the highest and is equal to 2257.

/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:

-- Let's use CTE for getting the number of hit movies produced by different companies.
-- Using RANK function, we can give ranking to the production companies on the basis of their hit movie count.

WITH prod_company_hit_mov_tab
     AS (SELECT production_company,
                Count(movie_id)                    AS MOVIE_COUNT,
                Rank()
                  OVER(
                    ORDER BY Count(movie_id) DESC) AS prod_company_rank
         FROM   ratings AS r
                INNER JOIN movie AS m
                        ON m.id = r.movie_id
         WHERE  avg_rating > 8
                AND production_company IS NOT NULL
         GROUP  BY production_company)
SELECT *
FROM   prod_company_hit_mov_tab
WHERE  prod_company_rank = 1;

/*-----------------------------------------------------------------------------------------------------+
INSIGHTS: 
1. There are 2 production houses which have produced the most number of hit movies (average rating > 8).
2. They are Dream Warrior Pictures & National Theatre Live. Movie count of each = 3
+------------------------------------------------------------------------------------------------------*/


-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT genre,
       Count(g.movie_id) AS movie_count
FROM   genre AS g
       INNER JOIN ratings AS r
               ON g.movie_id = r.movie_id
       INNER JOIN movie AS m
               ON m.id = g.movie_id
WHERE  country LIKE '%USA%'
       AND total_votes > 1000
       AND Month(date_published) = 3
       AND year = 2017
GROUP  BY genre
ORDER  BY movie_count DESC; 

/**INSIGHTS: 1. 24 movies which were released in DRAMA genre during March 2017 in the USA had more than 1,000 votes, and it's the highest count.
             2. Only 1 movie of Family genre had more than 1000 votes, and it's the least count. **/

-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT title,
       avg_rating,
       genre
FROM   genre AS g
       INNER JOIN ratings AS r
               ON g.movie_id = r.movie_id
       INNER JOIN movie AS m
               ON m.id = g.movie_id
WHERE  title LIKE 'The%'
       AND avg_rating > 8
ORDER  BY avg_rating DESC; 
/** INSIGHTS: 1. There are 8 movies which start with the word 'The' and have average rating > 8.
              2. The movie named 'The Brighton Miracle' has the highest average rating among all.
              3. Top 3 movies in terms of average rating are of 'DRAMA' genre. **/

-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

SELECT median_rating,
       Count(movie_id) AS no_of_movies
FROM   movie AS m
       INNER JOIN ratings AS r
               ON m.id = r.movie_id
WHERE  median_rating = 8
       AND date_published BETWEEN '2018-04-01' AND '2019-04-01'
GROUP  BY median_rating; 
-- INSIGHT: Of the movies released between 1 April 2018 and 1 April 2019, 361 movies were given a median rating of 8.        


-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:
   
-- Using 'languages' column:
WITH germanl_movies
     AS (SELECT languages,
                SUM(total_votes) AS Total_votes
         FROM   ratings r
                inner join movie m
                        ON r.movie_id = m.id
         WHERE  languages LIKE '%Germa%'
         GROUP  BY languages) SELECT 'German'         AS Movies,
       SUM(total_votes) AS Total_votes
FROM   germanl_movies
UNION
(
WITH italianl_movies
     AS (SELECT languages,
                SUM(total_votes) AS Total_votes
         FROM   ratings r
                inner join movie m
                        ON r.movie_id = m.id
         WHERE  languages LIKE '%Ital%'
         GROUP  BY languages)
SELECT 'Italian'        AS Movies,
       SUM(total_votes) AS Total_votes
 FROM   italianl_movies); 
/* INSIGHTS: 1.The total no of votes for German language movies = 4421525
		     2.The total no of votes for Italian language movies = 2559540 */

-- Query to check whether German movies got more votes than Italian movies, and to get output in tes of 'Yes' or 'No'
WITH check_table AS
(
WITH germanl_movies
     AS (SELECT languages,
                Sum(total_votes) AS Total_votes
         FROM   ratings r
                INNER JOIN movie m
                        ON r.movie_id = m.id
         WHERE  languages LIKE '%Germa%'
         GROUP  BY languages) SELECT 'German'         AS Movies,
       Sum(total_votes) AS Total_votes
FROM   germanl_movies
UNION
(
WITH italianl_movies
     AS (SELECT languages,
                Sum(total_votes) AS Total_votes
         FROM   ratings r
                INNER JOIN movie m
                        ON r.movie_id = m.id
         WHERE  languages LIKE '%Ital%'
         GROUP  BY languages)
SELECT 'Italian'        AS Movies,
       Sum(total_votes) AS Total_votes
 FROM   italianl_movies)
 )
SELECT IF(Movies = 'German', 'Yes', 'No') AS Answer
FROM check_table
ORDER BY Total_votes DESC limit 1;
-- Answer is 'Yes'
-- CONCLUSION: German movies got more votes than Italian movies.
 
/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/

-- Segment 3:

-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT Sum(CASE
             WHEN name IS NULL THEN 1
             ELSE 0
           END) AS name_nulls,
       Sum(CASE
             WHEN height IS NULL THEN 1
             ELSE 0
           END) AS height_nulls,
       Sum(CASE
             WHEN date_of_birth IS NULL THEN 1
             ELSE 0
           END) AS date_of_birth_nulls,
       Sum(CASE
             WHEN known_for_movies IS NULL THEN 1
             ELSE 0
           END) AS known_for_movies_nulls
FROM   names; 
/* INSIGHT:
There are 
17335 null values in height column, 
13431 null values in date_of_birth column, and 
15226 null values in known_for_movies column.
There are no null value in 'name' column, and 'known_for_movies' column has the highest number of null values. */


/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

WITH top_genre AS
(
           SELECT     genre,
                      Count(g.movie_id) AS movie_count
           FROM       genre             AS g
           INNER JOIN ratings           AS r
           ON         g.movie_id = r.movie_id
           WHERE      avg_rating > 8
           GROUP BY   genre
           ORDER BY   movie_count DESC limit 3 ), top_director AS
(
           SELECT     NAME                                               AS director_name,
                      Count(g.movie_id)                                  AS movie_count,
                      Row_number() OVER(ORDER BY Count(g.movie_id) DESC) AS director_row_rank
           FROM       names                                              AS n
           INNER JOIN director_mapping                                   AS d_m
           ON         d_m.name_id = n.id
           INNER JOIN genre AS g
           ON         g.movie_id = d_m.movie_id
           INNER JOIN ratings AS r
           ON         r.movie_id = g.movie_id,
                      top_genre
           WHERE      g.genre IN ( top_genre.genre )
           AND        avg_rating > 8
           GROUP BY   director_name
           ORDER BY   Count(movie_id) DESC )
SELECT director_name,
       movie_count
FROM   top_director
WHERE  director_row_rank <= 3;
/* INSIGHTS: 'James Mangold' is the Top-1 director with movie count 4 having an average rating > 8 
              followed by 'Soubin Shahir' and 'Joe Russo' with movie count 3 each.*/


/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT name            AS actor_name,
       Count(r.movie_id) AS movie_count
FROM   role_mapping AS r_m
       INNER JOIN movie AS m
               ON m.id = r_m.movie_id
       INNER JOIN ratings AS r USING(movie_id)
       INNER JOIN names AS n
               ON n.id = r_m.name_id
WHERE  median_rating >= 8
       AND category = 'ACTOR'
GROUP  BY actor_name
ORDER  BY movie_count DESC
LIMIT  2; 
-- INSIGHT: The top 2 actors whose movies have a median rating >= 8 are 'Mammootty' with movie count 8 & 'Mohanlal' with movie count 5.

/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT *
FROM   (SELECT production_company,
               Sum(total_votes)                    AS vote_count,
               Rank()
                 OVER(
                   ORDER BY Sum(total_votes) DESC) AS prod_comp_rank
        FROM   movie AS m
               INNER JOIN ratings AS r
                       ON r.movie_id = m.id
        GROUP  BY production_company) AS rank_tab
WHERE  prod_comp_rank < 4; 
/* INSIGHTS: 1. The top three production houses based on the number of votes received by their movies are 'Marvel Studios', 'Twentieth Century Fox' & 'Warner Bros.'
             2. 'Marvel Studios' stood first with the highest vote count. */

/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH actor_rank_summary
     AS (SELECT name                                                       AS actor_name,
                Sum(total_votes)                                           AS total_votes,
                Count(r.movie_id)                                          AS movie_count,
                Round(Sum(avg_rating * total_votes) / Sum(total_votes), 2) AS actor_avg_rating,
                Rank()
                  OVER(
                    ORDER BY Sum(avg_rating * total_votes) / Sum(total_votes)
                  DESC)                                                    AS actor_rank
         FROM   movie m
                INNER JOIN ratings r
                        ON m.id = r.movie_id
                INNER JOIN role_mapping r_m
                        ON r.movie_id = r_m.movie_id
                INNER JOIN names n
                        ON n.id = r_m.name_id
         WHERE  category = 'Actor'
                AND country LIKE '%India%'
         GROUP  BY name
         HAVING movie_count >= 5)
SELECT *
FROM   actor_rank_summary; 
/* INSIGHTS: 1. It's not a surprise that 'Vijay Sethupathi' topped the list with average rating 8.42 and movie count 5
             2. Vijay is followed by 'Fahadh Faasil' with average rating 7.99 & 'Yogi Babu' with average rating 7.99
             3. Movie count for 'Yogi Babu' is the highest(It's 11) among all in the list.*/

-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH actress_rank_summary
     AS (SELECT name AS actress_name,
                Sum(total_votes)                                           AS total_votes,
                Count(r.movie_id)                                          AS movie_count,
                Round(Sum(avg_rating * total_votes) / Sum(total_votes), 2) AS actress_avg_rating,
                Rank()
                  OVER(
                    ORDER BY Sum(avg_rating * total_votes) / Sum(total_votes)
                  DESC)                                                    AS actress_rank
         FROM   movie m
                INNER JOIN ratings r
                        ON m.id = r.movie_id
                INNER JOIN role_mapping r_m
                        ON r.movie_id = r_m.movie_id
                INNER JOIN names n
                        ON n.id = r_m.name_id
         WHERE  category = 'Actress'
                AND country LIKE '%India%'
                AND languages LIKE '%Hindi%'
         GROUP  BY name
         HAVING movie_count >= 3)
SELECT *
FROM   actress_rank_summary
WHERE  actress_rank <= 5; 
/* INSIGHTS: 1. The top five actresses in Hindi movies released in India based on their average ratings are
                'Taapsee Pannu','Kriti Sanon','Divya Dutta','Shraddha Kapoor' and 'Kriti Kharbanda'
			 2. Tapsee has topped the list with average rating 7.74. */ 


/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

SELECT DISTINCT title,
                avg_rating,
                CASE
                  WHEN avg_rating > 8 THEN 'Superhit movies'
                  WHEN avg_rating BETWEEN 7 AND 8 THEN 'Hit movies'
                  WHEN avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch movies'
                  ELSE 'Flop movies'
                END AS avg_rating_category
FROM   movie AS m
       INNER JOIN ratings AS r
               ON m.id = r.movie_id
       INNER JOIN genre AS g
               ON r.movie_id = g.movie_id
WHERE  genre = 'THRILLER';     
/** INSIGHT: 1482 Thriller movies were classified into mentioned categories.**/

/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:
SELECT genre,
       Round(Avg(duration), 2)                      AS avg_duration,
       SUM(Round(Avg(duration), 2))
         over(
           ORDER BY genre ROWS unbounded preceding) AS running_total_duration,
       Avg(Round(Avg(duration), 2))
         over(
           ORDER BY genre ROWS 10 preceding)        AS moving_avg_duration
FROM   movie AS m
       inner join genre AS g
               ON m.id = g.movie_id
GROUP  BY genre
ORDER  BY genre; 
/** The output table is as follows
+------------+--------------+----------------------+----------------------+
|    genre	 | avg_duration |running_total_duration| moving_avg_duration  |
+------------+--------------+----------------------+----------------------+
|   Action	     112.88	             112.88	               112.880000     |
|	Adventure	 101.87	             214.75	               107.375000     |
|	Comedy	     102.62	             317.37	               105.790000     |
|	Crime	     107.05	             424.42	               106.105000     |
|	Drama	     106.77	             531.19	               106.238000     |
|	Family	     100.97	             632.16	               105.360000     |
|	Fantasy	     105.14	             737.30	               105.328571     |
|	Horror	      92.72	             830.02	               103.752500     |
|	Mystery	     101.80	             931.82	               103.535556     |
|	Others	     100.16	            1031.98	               103.198000     |
|	Romance	     109.53	            1141.51	               103.773636     |
|	Sci-Fi	      97.94	            1239.45	               102.415455     |
|	Thriller	 101.58	            1341.03	               102.389091     |
+-----------+--------------+----------------------+-----------------------+**/

-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies
WITH top_genre AS
(
           SELECT     g.genre AS genre
           FROM       genre   AS g
           INNER JOIN movie   AS m
           ON         m.id=g.movie_id
           GROUP BY   g.genre
           ORDER BY   Count(m.id) DESC limit 3 ), top_movies AS
(
           SELECT     g.genre AS genre,
                      year    AS year,
                      title   AS movie_name,
                      worlwide_gross_income,
                      Row_number() OVER( PARTITION BY year ORDER BY CONVERT(Replace(Trim(worlwide_gross_income), "$ ",""),
                                         unsigned int) DESC ) AS movie_rank
           FROM       movie                                   AS m
           INNER JOIN genre                                   AS g
           ON         m.id=g.movie_id
           WHERE      genre IN
                                (
                                SELECT DISTINCT genre
                                FROM            top_genre
                                )
)                                
SELECT *
FROM   top_movies
WHERE  movie_rank<=5;
/* INSIGHTS: 1. The highest-grossing movies of the year 2017 is 'The Fate of the Furious'
			 2. The highest-grossing movies of the year 2018 is 'Bohemian Rhapsody'
             3. The highest-grossing movies of the year 2019 is 'Avengers: Endgame' */


-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:


-- Using POSITION(',' IN languages)>0 logic & DTE:
SELECT *
FROM   (SELECT production_company,
               Count(m.id)                    AS movie_count,
               Row_number()
                 OVER(
                   ORDER BY Count(m.id) DESC) AS prod_comp_rank
        FROM   movie m
               INNER JOIN ratings rt
                       ON m.id = rt.movie_id
        WHERE  median_rating >= 8
               AND production_company IS NOT NULL
               AND Position(',' IN languages) > 0
        GROUP  BY production_company) a
WHERE  prod_comp_rank <= 2; 
/* INSIGHTS:1. The top two production houses that have produced the highest number of hits (median rating >= 8) 
			   among multilingual movies are 'Star Cinema' & 'Twentieth Century Fox'
			2. 'Star Cinema' has topped the list. */


-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
SELECT *
FROM   (SELECT NAME                                  AS actress_name,
               Sum(total_votes)                      AS total_votes,
               Count(rm.movie_id)                    AS movie_count,
               Round(Avg(avg_rating), 2)             AS actress_avg_rating,
               Row_number()
                 OVER(
                   ORDER BY Count(rm.movie_id) DESC) AS actress_rank
        FROM   names n
               INNER JOIN role_mapping rm
                       ON n.id = rm.name_id
               INNER JOIN ratings rt
                       ON rm.movie_id = rt.movie_id
               INNER JOIN genre g
                       ON rt.movie_id = g.movie_id
        WHERE  category = 'actress'
               AND avg_rating > 8
               AND genre LIKE '%Drama%'
        GROUP  BY NAME) a
WHERE  actress_rank <= 3; 
/*INSIGHTS: 1. The top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre
			   are 'Parvathy Thiruvothu', 'Susan Brown' & 'Amanda Lawrence' */


/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:

WITH next_date_publ_summary AS
(
           SELECT     d.name_id,
                      NAME,
                      d.movie_id,
                      duration,
                      avg_rating,
                      total_votes,
                      date_published,
                      Lead(date_published,1) OVER(partition BY d.name_id ORDER BY date_published, movie_id ) AS next_date_published
           FROM       director_mapping                                                                       AS d
           INNER JOIN names                                                                                  AS n
           ON         n.id = d.name_id
           INNER JOIN movie AS m
           ON         m.id = d.movie_id
           INNER JOIN ratings AS r
           ON         r.movie_id = m.id ), director_summary AS
(
       SELECT *,
              Datediff(next_date_published, date_published) AS date_difference
       FROM   next_date_publ_summary)
SELECT   name_id                       AS director_id,
         NAME                          AS director_name,
         Count(movie_id)               AS number_of_movies,
         Round(Avg(date_difference),0) AS avg_inter_movie_days,
         Round(Avg(avg_rating),2)      AS avg_rating,
         Sum(total_votes)              AS total_votes,
         Min(avg_rating)               AS min_rating,
         Max(avg_rating)               AS max_rating,
         Sum(duration)                 AS total_duration
FROM     director_summary
GROUP BY director_id
ORDER BY Count(movie_id) DESC limit 9;
/*-------------------------------------------------------------------------------------------------+
INSIGHTS: 1. The top 9 directors (based on number of movies) are
                'Andrew Jones', 'A.L. Vijay', 'Sion Sono',
                'Chris Stokes', 'Sam Liu', 'Steven Soderbergh'
                'Jesse V. Johnson', 'Justin Price', 'Özgür Bakar' 
             2. 'Andrew Jones' has topped the list with movie count 5
             3.  His Average inter movie duration 191 days
             4.  His Avaerage rating is 3.02 with minimum rating being 2.7 and max rating being 3.2
+-------------------------------------------------------------------------------------------------*/


