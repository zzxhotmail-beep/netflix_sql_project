-- Netflix Project

CREATE TABLE netflix
(
	show_id	VARCHAR(6),
	type    VARCHAR(10),
	title	VARCHAR(250),
	director VARCHAR(550),
	casts	VARCHAR(1050),
	country	VARCHAR(550),
	date_added	VARCHAR(55),
	release_year	INT,
	rating	VARCHAR(15),
	duration	VARCHAR(15),
	listed_in	VARCHAR(250),
	description VARCHAR(550)
);
SELECT * FROM netflix;

SELECT COUNT(*) as total_content
FROM netflix;

SELECT DISTINCT type
FROM netflix;

-- Data Exploration 
-- 15 Business Problems & Solutions

-- 1. Count the number of Movies vs TV Shows.
SELECT type,COUNT(type) as total_content
FROM netflix
GROUP BY type;
-- Movie: 6131, TV Show: 2676

--2. Find the most common rating for movies and TV shows.
WITH RatingCounts AS (
    SELECT 
        type,
        rating,
        COUNT(*) AS rating_count
    FROM netflix
    GROUP BY type, rating
),
RankedRatings AS (
    SELECT 
        type,
        rating,
        rating_count,
        RANK() OVER (PARTITION BY type ORDER BY rating_count DESC) AS rank
    FROM RatingCounts
)
SELECT 
    type,
    rating AS most_frequent_rating
FROM RankedRatings
WHERE rank = 1;
-- Movie: TV-MA, TV Show: TV-MA

--3. List all movies released in a specific year (e.g., 2020).
SELECT title
FROM netflix
WHERE type='Movie' AND release_year = 2020;

--4. Find the top 5 countries with the most content on Netflix.
SELECT country,COUNT(*) as total_content
FROM netflix
WHERE country IS NOT NULL
GROUP BY country
ORDER BY total_content DESC
LIMIT 5;
-- United States, India, United kingdom, Japan, South Korea

--5. Identify the longest movie.
SELECT title, duration
FROM netflix
WHERE type='Movie' AND duration IS NOT NULL
ORDER BY SPLIT_PART(duration, ' ', 1)::INT DESC
LIMIT 1;
--Black Mirror: Bandersnatch: 312mins

--6. Find content added in the last 5 years.
SELECT *
FROM netflix
WHERE TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';

--7. Find all the movies/TV shows by director 'Rajiv Chilaka'!
SELECT *
FROM
(
SELECT *, UNNEST(STRING_TO_ARRAY(director, ',')) as director_name
FROM netflix
)
WHERE director_name = 'Rajiv Chilaka';

--8. List all TV shows with more than 5 seasons.
SELECT *
FROM netflix
WHERE type='TV Show' AND SPLIT_PART(duration, ' ', 1)::INT >5;

--9. Count the number of content items in each genre.
SELECT UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre_name,COUNT(*) AS genre_count
FROM netflix
GROUP BY genre_name
ORDER BY genre_name;

--10.Show how many content items India released on Netflix each year.
--return top 5 year with highest content release!
SELECT country, release_year,COUNT(*) as num
FROM netflix
WHERE country='India'
GROUP BY country,release_year
ORDER BY num DESC
LIMIT 5;
--2017: 101, 2018: 94, 2019: 87, 2020: 75, 2016: 73

--11. List all movies that are documentaries
SELECT *
FROM(
	SELECT *, UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre_name
	FROM netflix
	)
WHERE type='Movie' AND genre_name='Documentaries';

--12. Find all content without a director
SELECT *
FROM netflix
WHERE director IS NULL;

--13. Find how many movies actor 'Salman Khan' appeared in last 10 years!
SELECT release_year,COUNT(release_year) AS num
FROM netflix
WHERE type = 'Movie' 
      AND casts like '%Salman Khan%' 
	  AND TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '10 years'
GROUP BY release_year
ORDER BY release_year DESC;

--14. Find the top 10 actors who have appeared in the highest number of movies produced in India.
SELECT UNNEST(STRING_TO_ARRAY(casts, ', ')) AS actor_name, COUNT(*) AS num
FROM netflix
WHERE type = 'Movie' AND country LIKE '%India%'
GROUP BY actor_name
ORDER BY num DESC  
LIMIT 10;

/*
15.Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
the description field. Label content containing these keywords as 'Bad' and all other 
content as 'Good'. Count how many items fall into each category.
*/
SELECT
CASE WHEN description LIKE '%kill%' OR description ILIKE '%violence%' THEN 'Bad'
ELSE 'Good' END AS content_category, COUNT(*) AS total_num
FROM netflix
GROUP BY content_category
ORDER BY content_category;
--Bad: 335, Good: 8472

-- End of Project
