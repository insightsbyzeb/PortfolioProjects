# World Life Expectancy Project (Data Cleaning)
use world_life_expectancy;

SELECT * 
FROM world_life_expectancy;

# Step 1: Removing Duplicates
		# Found duplicates using the fact that there should only be one country+year. CONCAT()!
SELECT 
Country,
Year,
CONCAT(Country, YEAR),
COUNT(CONCAT(Country, Year))
FROM world_life_expectancy
GROUP BY COUNTRY, Year, CONCAT(Country, Year)
HAVING COUNT(CONCAT(Country, Year)) > 1
;

		# Located where duplicates are using ROW_NUMBER() OVER(PARTITION BY)
SELECT *
FROM (        
        SELECT row_id,
		CONCAT(Country, Year),
		ROW_NUMBER() OVER(PARTITION BY CONCAT(Country, Year) ORDER BY CONCAT(Country,YEAR)) AS row_num
		FROM world_life_expectancy ) as table_row
WHERE row_num > 1
;

		# Deleted the three duplicates using the located rows and the DELETE FROM WHERE 
DELETE FROM world_life_expectancy
WHERE row_id IN (
	SELECT row_id
	FROM (        
        SELECT row_id,
		CONCAT(Country, Year),
		ROW_NUMBER() OVER(PARTITION BY CONCAT(Country, Year) ORDER BY CONCAT(Country,YEAR)) AS row_num
		FROM world_life_expectancy ) as table_row
	WHERE row_num > 1 )
;
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Cleaning the 'Status' Column using available data
SELECT * 
FROM world_life_expectancy;

		# Found empty cells while scanning. Looked into empty cells (NOT NULL).
		# Asked 'Can we populate these cells using data surrounding them?'. Answer: YES! Each of these countries had a given status we could use to populate the cells.
SELECT *
FROM world_life_expectancy
WHERE status = ''
;

		# Confirmed that the countries missing a status had statuses before and/or after. Found that all cells besides the empty ones had a status.
SELECT DISTINCT(Status)
FROM world_life_expectancy
WHERE Status <> ''
;

		# Found countries that have a 'Devloping' Status
SELECT DISTINCT(Country)
FROM world_life_expectancy
WHERE Status = 'Developing'
;

/* List of countries missing a status before Data Cleaning [Afghanistan,Albania,Georgia,Georgia,United States of America,Vanuatu,Zambia,Zambia] */

		# Replaced Blanks when Countries had a status of 'Developing'
	# Attempt 1 -> Error due to the subquery in the where clause of an update
UPDATE world_life_expectancy
SET Status = 'Developing'
WHERE Country IN (SELECT DISTINCT(Country)
				FROM world_life_expectancy
				WHERE Status = 'Developing')
;

	# Attempt 2 -> Joined our data to itself to find where a country's status is blank in at least 1 row and developing in at least one row
UPDATE world_life_expectancy a
JOIN world_life_expectancy b 
	ON a.Country = b.Country
SET a.Status = 'Developing'
WHERE a.Status = ''
AND b.Status = 'Developing'
;
		# Confirmed the replacement of blanks with developing
SELECT *
FROM world_life_expectancy
WHERE status = ''
;
SELECT DISTINCT(Status)
FROM world_life_expectancy
WHERE Status <> ''
;
		# Noted that there is a blank that was not replaced with 'Developing'. Checked the status of the country in other row. Found it was 'Developed' not 'Developing'
Select status
FROM world_life_expectancy
WHERE country = 'United States of America'
;
		# Updated the status.
UPDATE world_life_expectancy.world_life_expectancy a
JOIN world_life_expectancy.world_life_expectancy b 
	ON a.Country = b.Country
SET a.Status = 'Developed'
WHERE a.Status = ''
AND b.Status = 'Developed'
;

		# Confirmed the replacement of blank with 'Developing' and checked status column for cleaned data.
SELECT *
FROM world_life_expectancy
WHERE status = ''
;
SELECT DISTINCT(Status)
FROM world_life_expectancy
WHERE Status <> ''
;
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Cleaning the Life Expectancy Column

		# Found empty cells. Looked into empty cells (NOT NULLs)
SELECT *
FROM world_life_expectancy
WHERE `Life Expectancy` = ''
;

		# Asked myself logically 'Can we populate these cells using data surrounding them?'. 
        # Answer: YES! The Life Expectancy grows fairly linearly near the two empty cells.
SELECT Country,
YEAR,
`Life Expectancy`
FROM world_life_expectancy
WHERE `Life Expectancy` = ''
;
		
        # Goal: Take the average of the previous year's life expectancy and the next year's life expectance to populate the empty cells.
		# Step 1: Join the data to itself twice in order to get a column for each years' data.
        # Step 2: Filter data to select the rows where Life Expectancy is missing from the first column
        # Step 3: Calculate the average using each years' Life Expectancy using ROUND((previous_year + future_year)/2,1)
SELECT a.Country, a.Year, a.`Life Expectancy`,
b.Country, b.Year, b.`Life Expectancy`,
c.Country, c.Year, c.`Life Expectancy`,
ROUND((b.`Life Expectancy` + c.`Life Expectancy`)/2,1)
FROM world_life_expectancy a
JOIN world_life_expectancy b 
	ON a.Country = b.Country
    AND a.Year = b.year - 1 # previous_year
JOIN world_life_expectancy c 
	ON a.Country = c.Country
    AND a.Year = c.year + 1 # future_year
WHERE a.`Life Expectancy` = ''
;


		# Applied derived data to the two empty cells.
        # Step 4: Joined using the join statement found in Step 1 and set the original column 1 data equal to the avg from Step 3 to populate the empty cells.
UPDATE world_life_expectancy a
JOIN world_life_expectancy b 
	ON a.Country = b.Country
    AND a.Year = b.year - 1
JOIN world_life_expectancy c 
	ON a.Country = c.Country
    AND a.Year = c.year + 1
SET a.`Life Expectancy` = ROUND((b.`Life Expectancy` + c.`Life Expectancy`)/2,1)
WHERE  a.`Life Expectancy` = ''
;

		# Checked to make sure the data had no empty cells and was populated with the averages!
SELECT *
FROM world_life_expectancy
WHERE `Life Expectancy` = ''
;
SELECT *
FROM world_life_expectancy
WHERE `Life Expectancy` <> ''
;
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		# First deeper look at the data
SELECT *
FROM world_life_expectancy
;

		# Noted there are a number of countries reporting numbers as low as 0 infant deaths for an entire year
		# Used RANK() OVEER(PARITION BY)) to find countries with suspiciously low infant deaths.
SELECT *
FROM (
        SELECT *,
		RANK() OVER(PARTITION BY Country ORDER BY `infant deaths` ASC) rank_infant_death
		FROM world_life_expectancy) AS infant_death_table
WHERE rank_infant_death < 2
;