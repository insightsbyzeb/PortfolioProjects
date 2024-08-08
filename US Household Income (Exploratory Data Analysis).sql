# US Household Income (Exploratory Data Analysis)

SELECT * 
FROM us_household_income_schema.us_household_income
;

		# Found the states with the most land and water masses
		# Found Texas has the most land mass and Michigan has the most water mass
SELECT State_Name,
SUM(ALand),
sum(AWater)
FROM us_household_income
GROUP BY state_name
ORDER BY 2 DESC
;
SELECT State_Name,
SUM(ALand),
sum(AWater)
FROM us_household_income
GROUP BY state_name
ORDER BY 3 DESC
;

		# Tied the two tables together to gain new insights
SELECT *
FROM us_household_income_schema.us_household_income u
INNER JOIN us_household_income_schema.us_household_stats us
	ON u.id = us.id
WHERE MEAN <> 0
;


SELECT u.state_name,
County,
Type,
`Primary`,
Mean,
Median
FROM us_household_income_schema.us_household_income u
INNER JOIN us_household_income_schema.us_household_stats us
	ON u.id = us.id
WHERE MEAN <> 0
;


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
LIMIT 20
;
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
LIMIT 20
;
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
LIMIT 20
;


		# Took a closer look at highest income cities
SELECT U.State_name,
City,
ROUND(AVG(Mean),1),
ROUND(AVG(Median),1)
FROM us_household_income_schema.us_household_income u
INNER JOIN us_household_income_schema.us_household_stats us
	ON u.id = us.id
GROUP BY u.State_name, city
ORDER BY 3 DESC
;

SELECT customer_id
FROM customers
WHERE TIMESTAMPDIFF(YEAR, birth_date, '2023-01-01') >= 55
ORDER BY customer_id
;
