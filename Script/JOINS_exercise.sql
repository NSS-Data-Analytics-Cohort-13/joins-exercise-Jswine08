SELECT *
FROM revenue

--1. Give the name, release year, and worldwide gross of the lowest grossing movie.

SELECT 
		s.film_title
	,	s.release_year


	,	MIN(r.worldwide_gross) AS min_gross

FROM specs AS s

	LEFT JOIN revenue AS r
		ON s.movie_id = r.movie_id

GROUP BY s.film_title, s.release_year
ORDER BY min_gross ASC
limit 1;

--Answer "Semi-Tough", year 1977 gross 37187139.


--2. What year has the highest average imdb rating?

SELECT 
		s.release_year


	,	AVG(r.imdb_rating) AS avg_rating

FROM specs AS s

	LEFT JOIN rating AS r
		ON s.movie_id = r.movie_id

GROUP BY release_year
ORDER BY avg_rating DESC;

--Answer 1991 (7.45)


--3. What is the highest grossing G-rated movie? Which company distributed it?

SELECT 
		s.mpaa_rating
	,	s.film_title

	,	d.company_name

	,	r.worldwide_gross

FROM specs AS s

	LEFT JOIN distributors AS d
		ON s.domestic_distributor_id = d.distributor_id
	
	LEFT JOIN revenue AS r
		ON s.movie_id=r.movie_id
	
WHERE s.mpaa_rating='G'
GROUP BY d.company_name, s.mpaa_rating, r.worldwide_gross, s.film_title
ORDER BY r.worldwide_gross DESC;

--Answer The Toy Story 4 by Walt Disney grossing (1073394593)


--4. Write a query that returns, for each distributor in the distributors table, the distributor name and the number of movies associated with that distributor in the movies table. Your result set should include all of the distributors, whether or not they have any movies in the movies table.

SELECT 
		--d.distributor_id
		d.company_name


	--,	--s.movie_id
	,	COUNT(s.film_title) AS count_title
	--,	--s.domestic_distributor_id

FROM distributors AS d
	FULL JOIN specs AS s
	ON d.distributor_id = s.domestic_distributor_id
	
GROUP BY d.company_name --, d.distributor_id, s.movie_id, s.domestic_distributor_id
ORDER BY count_title;

--Answer run quesry


--5. Write a query that returns the five distributors with the highest average movie budget.


SELECT 
		d.distributor_id
	,	d.company_name


	,AVG(r.film_budget)	AS avg_budget

FROM distributors AS d
	CROSS JOIN revenue AS r

GROUP BY d.distributor_id, d.company_name
ORDER BY avg_budget DESC
LIMIT 5;


SELECT d.company_name, AVG(film_budget) AS avg_budget
FROM distributors AS d
	INNER JOIN specs AS s
		ON d.distributor_id=s.domestic_distributor_id
	INNER JOIN revenue
		USING(movie_id)
GROUP BY d.company_name
ORDER BY avg_budget DESC
--LIMIT 5;


--Answer "Walt Disney "	148735526.31578947
"Sony Pictures"	139129032.25806452
"Lionsgate"	122600000.00000000
"DreamWorks"	121352941.17647059
"Warner Bros."	103430985.91549296

--6. How many movies in the dataset are distributed by a company which is not headquartered in California? Which of these movies has the highest imdb rating?

SELECT 
		--d.distributor_id
		d.company_name
	,	d.headquarters 


	,	r.imdb_rating


	,	s.film_title

FROM distributors AS d
	INNER JOIN specs AS s
		ON d.distributor_id=s.domestic_distributor_id
	INNER JOIN rating AS r
		ON s.movie_id = r.movie_id
WHERE d.headquarters NOT LIKE '%, CA'
GROUP BY --d.distributor_id
		d.company_name
	,	d.headquarters 

	,	r.imdb_rating
	
	,	s.film_title
ORDER BY r.imdb_rating DESC;

--Answer "Chicago, Illinois"	7.0	"Dirty Dancing"
--"New York, NY"	6.5	"My Big Fat Greek Wedding"


--7. Which have a higher average rating, movies which are over two hours long or movies which are under two hours?

SELECT
		(s.length_in_min/60) AS hour_movies
	,	s.movie_id


	,	r.movie_id
	,	MAX(r.imdb_rating) AS max_rating

FROM specs AS s
	LEFT JOIN rating AS r
	ON s.movie_id = r.movie_id
WHERE (s.length_in_min/60)>'2' OR (s.length_in_min/60)<'2'
GROUP BY r.imdb_rating, s.movie_id, r.movie_id, s.length_in_min
HAVING AVG(r.imdb_rating)>8
ORDER BY hour_movies DESC, r.imdb_rating DESC;



SELECT
	CASE 
		WHEN s.length_in_min > 120 THEN 'Over 2 hrs'
		ELSE 'Under 2 hrs' 
		END AS filtered_length
,	ROUND(AVG(r.imdb_rating),2) AS avg_imdb
FROM specs AS s
	INNER JOIN rating AS r
		ON s.movie_id = r.movie_id
GROUP BY 
	filtered_length
ORDER BY avg_imdb DESC;


--Answer  "Over 2 hrs"	7.26
--"Under 2 hrs"	6.92
