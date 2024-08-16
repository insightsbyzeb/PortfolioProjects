# US Household Income (Data Cleaning)
use us_household_income_schema;

RENAME TABLE ushouseholdincome TO us_household_income;
ALTER TABLE us_household_stats
RENAME COLUMN `ï»¿id` to `id`; 

SELECT * FROM us_household_income_schema.us_household_income;

		# Cleaned US Household Income Data
		# Step 1: Identify duplicates for Income Table
SELECT id,
COUNT(id)
FROM us_household_income
GROUP BY id
HAVING COUNT(id) > 1;

		# Located rows of duplicates
SELECT *
FROM (        
        SELECT row_id,
        id,
		ROW_NUMBER() OVER(PARTITION BY id ORDER BY id) AS row_num
		FROM us_household_income ) AS duplicates
WHERE row_num > 1;

		# Deleted duplicates
DELETE FROM us_household_income
WHERE row_id IN (
	SELECT row_id
	FROM (        
        SELECT row_id,
        id,
		ROW_NUMBER() OVER(PARTITION BY id ORDER BY id) AS row_num
		FROM us_household_income ) AS duplicates
	WHERE row_num > 1 );

SELECT * FROM us_household_income_schema.us_household_stats;

		# Identify duplicates for Stats Table. None found.
SELECT id,
COUNT(id)
FROM us_household_stats
GROUP BY id
HAVING COUNT(id) > 1;

		# Cleaning State_name Data
SELECT state_name,
COUNT(state_name)
FROM us_household_stats
GROUP BY State_Name;
SELECT DISTINCT state_name
FROM us_household_stats
ORDER BY state_name;

SELECT * FROM us_household_income_schema.us_household_income;

UPDATE us_household_income_schema.us_household_income
SET state_name = 'Georgia'
WHERE state_name = 'georia';
UPDATE us_household_income_schema.us_household_income
SET state_name = 'Alabama'
WHERE state_name = 'alabama';

SELECT *
FROM us_household_income_schema.us_household_income
WHERE County = 'Autauga County'ORDER BY 1;

UPDATE us_household_income_schema.us_household_income
SET Place = 'Autaugaville'
WHERE Place = ''
AND County = 'Autauga County';

		# Cleaned `type` field
SELECT type, COUNT(type)
FROM us_household_income_schema.us_household_income
GROUP BY type;

UPDATE us_household_income_schema.us_household_income
SET type = 'CDP'
WHERE type = 'CPD';
UPDATE us_household_income_schema.us_household_income
SET type = 'Borough'
WHERE type = 'Boroughs';

-- --------------------------------------------------------------------------------------------------------------------
# US Household Income (Exploratory Data Analysis)

SELECT * 
FROM us_household_income_schema.us_household_income;

		# Found the states with the most land and water masses
		# Found Texas has the most land mass and Michigan has the most water mass
SELECT State_Name,
SUM(ALand),
sum(AWater)
FROM us_household_income
GROUP BY state_name
ORDER BY 2 DESC;
SELECT State_Name,
SUM(ALand),
sum(AWater)
FROM us_household_income
GROUP BY state_name
ORDER BY 3 DESC;

		# Joined the two tables together to gain new insights
SELECT *
FROM us_household_income_schema.us_household_income u
INNER JOIN us_household_income_schema.us_household_stats us
	ON u.id = us.id
WHERE MEAN <> 0;


SELECT u.state_name,
County,
Type,
`Primary`,
Mean,
Median
FROM us_household_income_schema.us_household_income u
INNER JOIN us_household_income_schema.us_household_stats us
	ON u.id = us.id
WHERE MEAN <> 0;


		# Found the lowest 5 avg and median incomes by state
SELECT u.state_name,
ROUND(AVG(Mean),1),
ROUND(AVG(Median),1)
FROM us_household_income_schema.us_household_income u
INNER JOIN us_household_income_schema.us_household_stats us
	ON u.id = us.id
WHERE MEAN <> 0
GROUP BY u.state_name
ORDER BY 3
LIMIT 20;
		# Found the highest 5 avg and median incomes by state
SELECT u.state_name,
ROUND(AVG(Mean),1),
ROUND(AVG(Median),1)
FROM us_household_income_schema.us_household_income u
INNER JOIN us_household_income_schema.us_household_stats us
	ON u.id = us.id
WHERE MEAN <> 0
GROUP BY u.state_name
ORDER BY 2 DESC
LIMIT 20;
		# Excluded low count types to exclude outliers
SELECT type, COUNT(Type),
ROUND(AVG(Mean),1),
ROUND(AVG(Median),1)
FROM us_household_income_schema.us_household_income u
INNER JOIN us_household_income_schema.us_household_stats us
	ON u.id = us.id
WHERE MEAN <> 0
GROUP BY 1
HAVING COUNT(type) > 100
ORDER BY 4 DESC
LIMIT 20;


		# Took a closer look at highest income cities
SELECT U.State_name,
City,
ROUND(AVG(Mean),1),
ROUND(AVG(Median),1)
FROM us_household_income_schema.us_household_income u
INNER JOIN us_household_income_schema.us_household_stats us
	ON u.id = us.id
GROUP BY u.State_name, city
ORDER BY 3 DESC;

SELECT customer_id
FROM customers
WHERE TIMESTAMPDIFF(YEAR, birth_date, '2023-01-01') >= 55
ORDER BY customer_id;