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
### 1. Content Distribution Analysis.
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
