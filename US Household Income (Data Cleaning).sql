# US Household Income (Data Cleaning)

/* RENAME TABLE ushouseholdincome TO us_household_income
;
ALTER TABLE us_household_stats
RENAME COLUMN `ï»¿id` to `id`; */

SELECT * FROM us_household_income_schema.us_household_income;

		# Cleaned US Household Income Data
		# Step 1: Identify duplicates for Income Table
SELECT id,
COUNT(id)
FROM us_household_income
GROUP BY id
HAVING COUNT(id) > 1
;

		# Located rows of duplicates
SELECT *
FROM (        
        SELECT row_id,
        id,
		ROW_NUMBER() OVER(PARTITION BY id ORDER BY id) AS row_num
		FROM us_household_income ) AS duplicates
WHERE row_num > 1
;

		# Deleted duplicates
DELETE FROM us_household_income
WHERE row_id IN (
	SELECT row_id
	FROM (        
        SELECT row_id,
        id,
		ROW_NUMBER() OVER(PARTITION BY id ORDER BY id) AS row_num
		FROM us_household_income ) AS duplicates
	WHERE row_num > 1 )
;

SELECT * FROM us_household_income_schema.us_household_stats;

		# Identify duplicates for Stats Table. None found.
SELECT id,
COUNT(id)
FROM us_household_stats
GROUP BY id
HAVING COUNT(id) > 1
;

		# Cleaning State_name Data
SELECT state_name,
COUNT(state_name)
FROM us_household_stats
GROUP BY State_Name
;
SELECT DISTINCT state_name
FROM us_household_stats
ORDER BY state_name
;

SELECT * FROM us_household_income_schema.us_household_income;

UPDATE us_household_income_schema.us_household_income
SET state_name = 'Georgia'
WHERE state_name = 'georia'
;
UPDATE us_household_income_schema.us_household_income
SET state_name = 'Alabama'
WHERE state_name = 'alabama'
;

SELECT *
FROM us_household_income_schema.us_household_income
WHERE County = 'Autauga County'
ORDER BY 1
;

UPDATE us_household_income_schema.us_household_income
SET Place = 'Autaugaville'
WHERE Place = ''
AND County = 'Autauga County'
;

		# Cleaned `type` field
SELECT type, COUNT(type)
FROM us_household_income_schema.us_household_income
GROUP BY type
;

UPDATE us_household_income_schema.us_household_income
SET type = 'CDP'
WHERE type = 'CPD'
;
UPDATE us_household_income_schema.us_household_income
SET type = 'Borough'
WHERE type = 'Boroughs'
;