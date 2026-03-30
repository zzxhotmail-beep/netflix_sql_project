# Netflix Content Analysis | SQL Portfolio Project
![Netflix Logo](https://cdn.jsdelivr.net/gh/zzxhotmail-beep/netflix_sql_project@main/logo.png)

## Project Overview

This project analyzes Netflix’s content catalog using SQL in PostgreSQL to uncover patterns in content distribution, audience targeting, and production trends.

The analysis focuses on transforming raw data into actionable insights that could support content strategy and platform decision-making.

## Core Objectives

- Understand the balance between movies and TV shows on the platform.
- Identify dominant content ratings and their implications for target audiences.
- Analyze trends across release years, countries, and content duration.
- Explore content themes and categorize titles based on keywords and metadata.

## Dataset

The data for this project is sourced from the Kaggle dataset:
- **Dataset Link:** [Netflix Dataset](https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download)

## Technical Skills Demonstrated

- **SQL (PostgreSQL)**: Performed data extraction, transformation, and analysis on structured datasets.
- **Exploratory Data Analysis (EDA)**: Uncovered trends and patterns through exploratory analysis and aggregation techniques.
- **Advanced SQL Techniques**: Utilized CTEs, window functions, and CASE statements for complex querying.
- **Business Acumen**: Converted business requirements into analytical queries to support decision-making.

## Database Setup

- **Data Structuring**: Created a `netflix` table to organize content metadata with key attributes (e.g., content type, release year, rating, country, and genre), enabling efficient querying and analysis.

```sql
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
```

## Business Problems and Solutions
These analyses demonstrate SQL proficiency in handling real-world datasets, including data cleaning, transformation, and business-driven insights generation.
### 1. Content Distribution Analysis
- **Objective**: Evaluate the distribution of Movies vs TV Shows on Netflix
```sql
SELECT type,COUNT(type) as total_content
FROM netflix
GROUP BY type;
```
- **Insight**: Movies dominate the catalog, indicating a stronger focus on standalone content

### 2. Rating Distribution Analysis
- **Objective**: Identify the most common content ratings across Movies and TV Shows
```sql
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
```
- **Insight**: "TV-MA" is the most common rating, suggesting a strong presence of mature content

### 3. Release Year Analysis
- **Objective**: Analyze content released in a specific year (e.g., 2020)
```sql
SELECT title
FROM netflix
WHERE type='Movie' AND release_year = 2020;
```
- **Insight**: Content production remains high in recent years, reflecting Netflix’s expansion

### 4. Geographical Distribution Analysis
- **Objective**: Identify top content-producing countries
```sql
SELECT country,COUNT(*) as total_content
FROM netflix
WHERE country IS NOT NULL
GROUP BY country
ORDER BY total_content DESC
LIMIT 5;
```
- **Insight**: The U.S. leads production, with increasing contributions from India, the U.K., and Asia(Japan and South Korea)

### 5. Content Duration Analysis
- **Objective**: Identify the longest movie in the dataset
```sql
SELECT title, duration
FROM netflix
WHERE type='Movie' AND duration IS NOT NULL
ORDER BY SPLIT_PART(duration, ' ', 1)::INT DESC
LIMIT 1;
```
- **Insight**: *Black Mirror: Bandersnatch* stands out as the longest movie record in the dataset, featuring an exceptional runtime of 312 minutes as an interactive special.

### 6. Recent Content Trends
- **Objective**: Analyze content added in the last 5 years
```sql
SELECT *
FROM netflix
WHERE TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';
```
- **Insight**: A significant portion of content has been added recently, reflecting rapid platform growth

### 7. Director Analysis
- **Objective**: Identify content associated with a specific director
```sql
SELECT *
FROM
(
SELECT *, UNNEST(STRING_TO_ARRAY(director, ',')) as director_name
FROM netflix
)
WHERE director_name = 'Rajiv Chilaka';
```
- **Insight**: Enables deeper analysis of individual creator contributions

### 8. TV Show Duration Analysis
- **Objective**: Identify long-running TV shows
```sql
SELECT *
FROM netflix
WHERE type='TV Show' AND SPLIT_PART(duration, ' ', 1)::INT >5;
```
- **Insight**: Most shows have limited seasons, suggesting a preference for shorter series

### 9. Genre Distribution Analysis
- **Objective**: Analyze content distribution across genres
```sql
SELECT UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre_name,COUNT(*) AS genre_count
FROM netflix
GROUP BY genre_name
ORDER BY genre_name;
```
- **Insight**: Certain genres dominate the platform, reflecting audience preferences

### 10. Country-Specific Trend Analysis (India)
- **Objective**: Analyze yearly content production trends in India
```sql
SELECT country, release_year,COUNT(*) as num
FROM netflix
WHERE country='India'
GROUP BY country,release_year
ORDER BY num DESC
LIMIT 5;
```
- **Insight**: Content production in India peaked around 2017–2019

### 11. Genre-Based Content Filtering
- **Objective**: Identify documentary movies
```sql
SELECT *
FROM(
	SELECT *, UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre_name
	FROM netflix
	)
WHERE type='Movie' AND genre_name='Documentaries';
```
- **Insight**: Documentary content forms a niche but important segment

### 12. Missing Data Analysis
- **Objective**: Identify content with missing director information
```sql
SELECT *
FROM netflix
WHERE director IS NULL;
```
- **Insight**: Missing metadata may impact recommendation quality and analysis accuracy

### 13. Actor-Based Trend Analysis
- **Objective**: Analyze recent activity of a specific actor (e.g., Salman Khan)
```sql
SELECT release_year,COUNT(release_year) AS num
FROM netflix
WHERE type = 'Movie' 
      AND casts like '%Salman Khan%' 
	  AND TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '10 years'
GROUP BY release_year
ORDER BY release_year DESC;
```
- **Insight**: Actor-level analysis helps understand popularity and content trends

### 14. Top Actors Analysis
- **Objective**: Identify top actors in Indian movie productions
```sql
SELECT UNNEST(STRING_TO_ARRAY(casts, ', ')) AS actor_name, COUNT(*) AS num
FROM netflix
WHERE type = 'Movie' AND country LIKE '%India%'
GROUP BY actor_name
ORDER BY num DESC  
LIMIT 10;
```
- **Insight**: Highlights frequently featured actors in regional content

### 15. Content Classification Analysis
- **Objective**: Categorize content based on keywords in descriptions
```sql
SELECT
CASE WHEN description LIKE '%kill%' OR description ILIKE '%violence%' THEN 'Bad'
ELSE 'Good' END AS content_category, COUNT(*) AS total_num
FROM netflix
GROUP BY content_category
ORDER BY content_category;
```
- **Insight**: The majority of content falls into the “non-violent” category, indicating broad audience targeting

## Key Findings
1. **Content Distribution**:
   - Movies dominate the Netflix catalog (≈70%), indicating a strategic focus on standalone content rather than episodic TV series.
2. **Audience Targeting**:
   - Most content carries a “TV-MA” rating, reflecting a significant proportion of mature-audience material.
3. **Geographical Trends**:
   - The U.S. leads in content production, but India, the U.K., Japan, and South Korea are emerging markets with growing contributions.
4. **Production & Release Patterns**:
   - Content production has increased sharply since 2015, showing Netflix’s aggressive global expansion strategy.
5. **Genre & Actor Insights**:
   - Certain genres dominate the catalog, while analysis of actor appearances highlights recurring talent in specific regions (e.g., India).
6. **Content Characteristics**:
   - Movies tend to have standard durations; TV shows generally have fewer than 5 seasons, reflecting a preference for shorter series formats.
   - Keyword-based content classification shows most titles are “non-violent,” suggesting broad audience targeting.

## Conclusion
- Netflix’s catalog reflects a strategic emphasis on scalable, globally accessible content, with a strong presence of mature and mainstream entertainment.
- Insights from this analysis can inform content acquisition, regional expansion, and audience segmentation strategies.
- The project demonstrates SQL proficiency, data cleaning, exploratory analysis, and business-driven insight extraction, bridging technical skills with decision-making relevance.

## Author - Zixuan Zhang
This project is part of my portfolio, showcasing the SQL skills essential for data analyst roles.
- **LinkedIn**: [My Professional Profile](https://www.linkedin.com/in/zixuan-zhang-78ba38274)
