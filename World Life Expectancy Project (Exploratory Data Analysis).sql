# World Life Expectancy Project (Exploratory Data Analysis)

SELECT *
FROM world_life_expectancy
;


		# After perusing the data broadly, noted a number of suspciously low values as low as zeroes under each numeric data reported.
		# However, lacking more information from a supervisor on what to do with data that is potentially incorrect/null, rejected the idea of deleting or replacing any further values.
        # Instead, values of 0 were excluded when looking for insights on the data.


		# Explored the `Life expectancy` field to see the minimum life expectancy per country and its maximum life expectancy
SELECT Country,
MIN(`Life expectancy`),
MAX(`Life expectancy`)
FROM world_life_expectancy
GROUP BY Country
;

		# Excluded zeroes from the data.
SELECT Country,
MIN(`Life expectancy`),
MAX(`Life expectancy`)
FROM world_life_expectancy
GROUP BY Country
HAVING MIN(`Life expectancy`) <> 0 
AND MAX(`Life expectancy`) <> 0
ORDER BY Country DESC
;

		# Looked at the change in life expectancy per country over the reported data from the last 15 years.
SELECT Country,
MIN(`Life expectancy`) as min,
MAX(`Life expectancy`) as max,
ROUND(abs(MAX(`Life expectancy`)-MIN(`Life expectancy`)),1) as life_increase_15_years
FROM world_life_expectancy
GROUP BY country
HAVING MIN(`Life expectancy`) <> 0 
AND MAX(`Life expectancy`) <> 0
ORDER BY life_increase_15_years DESC
;

		# Changed the grouping to years to see how life expectancy has changed across every reporting country over time
SELECT YEAR, ROUND(avg(`Life expectancy`),1)
FROM world_life_expectancy
WHERE `Life expectancy` <> 0 
AND `Life expectancy` <> 0
GROUP BY Year
ORDER BY year
;

SELECT *
FROM world_life_expectancy
;


		# Correlated life expectancy to GDP. (Predicted higher GDPs to have higher life expectancies)
		# Comparing countries having top GDPs to the lowest GDPS, even without a visualization tool, it is apparent that higher GDP countries also had higher life expectancies typically
SELECT Country, 
ROUND(AVG(`Life expectancy`),1) AS life_exp, ROUND(AVG(GDP),0) AS GDP
FROM world_life_expectancy
GROUP BY Country
HAVING life_exp > 0 
AND gdp > 0
ORDER BY GDP ASC
;

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

		# In order to compare the countries with the top GDPs with the bottom GDPs, found the median GDP
SELECT SUM(GDP)/COUNT(GDP) as median_gdp
FROM world_life_expectancy
;

		# Found the number of countries with a higher than average GDP and those countries' life expectancies
		# Compared these values tot he lower than avg GDP and their life expectancies
        # Further confirmed that there is a correlation between countries having a higher GDP and having a higher life expectancy
SELECT 
ROUND(SUM(CASE
	WHEN GDP >= 6342 THEN 1
    ELSE 0
END),1) high_gdp_count,
ROUND(AVG(CASE 
	WHEN GDP >= 6342 THEN `Life expectancy`
	ELSE NULL
END),0) high_gdp_life_expectancy,
ROUND(SUM(CASE
	WHEN GDP <= 6342 THEN 1
    ELSE 0
END),1) low_gdp_count,
ROUND(AVG(CASE 
	WHEN GDP <= 6342 THEN `Life expectancy`
	ELSE NULL
END),0) low_gdp_life_expectancy
FROM world_life_expectancy
ORDER BY GDP
;


		# Compared developed countries to developing countries in terms of life expectancy while showing that the number of countries with each status is skewed towards developing
SELECT Status,
COUNT(DISTINCT Country),
ROUND(AVG(`Life expectancy`),1)
FROM world_life_expectancy
GROUP BY status
;

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		# Since BMI is a decent baseline health indicator, chose to correlate BMI and life expectancy for each country
SELECT *
FROM world_life_expectancy
ORDER BY BMI DESC
;       
        # Did not find a strong correlation b/w high BMI and life expectancy, however, very low BMIs were more closely tied to low life expectancies
SELECT Country, 
ROUND(AVG(`Life expectancy`),1) AS life_exp, ROUND(AVG(BMI),0) AS BMI
FROM world_life_expectancy
GROUP BY Country
HAVING life_exp > 0 
AND BMI > 0
ORDER BY BMI DESC
;
