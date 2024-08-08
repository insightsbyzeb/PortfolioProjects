# World Life Expectancy Project (Exploratory Data Analysis)
use world_life_expectancy;

SELECT *
FROM world_life_expectancy
;


		# After perusing the data broadly, we noted a number of suspciously low values as low as zeroes under each numeric field reported.
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

		# Next, we grouped by years to see how life expectancy has changed across every reporting country over the last 15 years.
SELECT YEAR, ROUND(avg(`Life expectancy`),1)
FROM world_life_expectancy
WHERE `Life expectancy` <> 0 
AND `Life expectancy` <> 0
GROUP BY Year
ORDER BY year
;

		# Correlated life expectancy to GDP. (Prediction: Higher GDPs will have higher life expectancies)
		# Insight: Comparing countries with the top GDPs to the lowest GDPS, even without a visualization tool, it is apparent that higher GDP countries also had higher life expectancies typically
SELECT Country, 
ROUND(AVG(`Life expectancy`),1) AS life_exp, ROUND(AVG(GDP),0) AS GDP
FROM world_life_expectancy
GROUP BY Country
HAVING life_exp > 0 
AND gdp > 0
ORDER BY GDP DESC
;

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

		# In order to compare the countries with the top GDPs with the bottom GDPs, found the median GDP
SELECT SUM(GDP)/COUNT(GDP) as median_gdp
FROM world_life_expectancy
;

		# Found the number of countries with a higher than median GDP and their life expectancies
		# Compared these values to the lower than avg GDP and their life expectancies
        # Further confirmed that there is a correlation between countries having a higher GDP and having a higher life expectancy
SELECT 
ROUND(SUM(CASE
		WHEN GDP >= 6342 THEN 1
		ELSE 0
	END),1) high_gdp_count,
ROUND(AVG(CASE 
		WHEN GDP >= 6342 THEN `Life expectancy`
		ELSE NULL
	END),0) high_gdp_avg_lifexpncy,
ROUND(SUM(CASE
		WHEN GDP <= 6342 THEN 1
		ELSE 0
	END),1) low_gdp_count,
ROUND(AVG(CASE 
		WHEN GDP <= 6342 THEN `Life expectancy`
		ELSE NULL
	END),0) low_gdp_avg_lifexpncy
FROM world_life_expectancy
ORDER BY GDP
;


		# Compared Developed countries to Developing countries in terms of life expectancy while showing that the number of countries with each status is skewed towards developing
SELECT Status,
COUNT(DISTINCT Country) AS num_countries,
ROUND(AVG(`Life expectancy`),1) AS avg_life_expectancy
FROM world_life_expectancy
GROUP BY status
;

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		# Since BMI is a common baseline health indicator, chose to correlate BMI and life expectancy for each country
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
