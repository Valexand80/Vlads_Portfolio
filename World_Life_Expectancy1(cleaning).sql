# World Life Expectancy Project (Data discovery, data cleaning and exploratory data analysis)
# Part 1. Data discovery and cleaning

SELECT * 
FROM world_life_expectancy;

# 1. Looking at our table, let's see how many records we have (2941): 

SELECT COUNT(Row_ID)
FROM world_life_expectancy;

# 2. Total contries and looking and examining a list of disctinct countries. (193): 

SELECT COUNT(DISTINCT Country)
FROM world_life_expectancy;

SELECT DISTINCT Country
FROM world_life_expectancy;

# 3. Looking at 'Status' column, lets see a breakdown: 

SELECT Status, COUNT(Status)
FROM world_life_expectancy
GROUP BY Status;

# As we can see, we have 2421 records of Developing Countries and 512 records of countries that are "Developed", we also have 8 blanks that we will have to fill out in our cleaning stage

# 4. First and last years in our dataset (2007 - 2022)

SELECT MIN(Year), MAX(Year)
FROM world_life_expectancy;

# 5. Looking at overall count of how many years of records we have for each country. We can see that few countries only have a single record. We also have couple that have 17 years.. this needs to be fixed. 

SELECT DISTINCT Country, COUNT(Year)
FROM world_life_expectancy
GROUP BY Country;


#6. Looking at the countries that have more than 16 and we have a few. These might be duplicates and we will remove those. 

SELECT DISTINCT Country, COUNT(Year)
FROM world_life_expectancy
GROUP BY Country
HAVING COUNT(Year) = 1;

#7. Identifying Rows that we need to delte and then removing bad and insufficient data (countries with missing data). First, let's create a temp table to identify our targeted rows.


CREATE TEMPORARY TABLE temp_table AS 
SELECT *
FROM world_life_expectancy
WHERE Country IN (
	SELECT DISTINCT Country
	FROM world_life_expectancy
	GROUP BY Country
	HAVING COUNT(Year) =1
    );
    
DELETE FROM world_life_expectancy
WHERE 
	Row_ID IN (
		SELECT Row_ID
		FROM temp_table);

#8. Identifying duplicate data. Since we do not have ID column where it would be easy to recognize duplicated, we will concatenate 'Country' and 'Year' columns to get a unique column. 

SELECT Country, Year, CONCAT(Country, Year), COUNT(CONCAT(Country, Year))
FROM world_life_expectancy
GROUP BY Country, Year, CONCAT(Country, Year)
HAVING COUNT(CONCAT(Country, Year)) > 1 ; 

#9. Now, we can remove those Row_ID that we have identified as. We can use partition and row_number

SELECT Row_ID, 
CONCAT(Country, Year), 
ROW_NUMBER() OVER(PARTITION BY CONCAT(Country, Year) ORDER BY CONCAT(Country, Year)) AS Row_Numb
FROM world_life_expectancy; 

#10. Using above query as a subquery, we can filter for the duplicates that we need to remove

DELETE FROM world_life_expectancy
WHERE Row_ID IN (

SELECT Row_ID
FROM (
	SELECT Row_ID, 
	CONCAT(Country, Year), 
	ROW_NUMBER() OVER(PARTITION BY CONCAT(Country, Year) ORDER BY CONCAT(Country, Year)) AS Row_Numb
	FROM world_life_expectancy) AS Row_table1
WHERE Row_numb > 1 )
; 

#11. Let's see how many blanks we have in our data: Looks like 'status' is missing from some of the record.
# Life expectancy is blank for 2 rows. Let's fix those issues first. 

SELECT *
FROM world_life_expectancy
WHERE status = '';

SELECT *
FROM world_life_expectancy
WHERE `Life expectancy` = '';

SELECT status, MIN(`Adult Mortality`), MAX(`Adult Mortality`)
FROM world_life_expectancy
GROUP by status; 

SELECT DISTINCT(Status)
FROM world_life_expectancy
WHERE Status <> '';

SELECT DISTINCT(Country)
FROM world_life_expectancy
WHERE Status = 'Developing';

#12. The list of countries that are 'Developing' will be used to populate missing fields for those countries. Later we will do the same for 'Developed'. 

UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.Country = t2.Country
SET t1.Status = 'Developing'
WHERE t1.Status = ''
AND t2.Status <> ''
AND t2.Status = 'Developing'; 

#13. Similarly, let's populate 'Developed' countries.

UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.Country = t2.Country
SET t1.Status = 'Developed'
WHERE t1.Status = ''
AND t2.Status <> ''
AND t2.Status = 'Developed';

#14. Let's double check that we no longer have empty fields in 'Status' (Now we have 0 rows )

SELECT *
FROM world_life_expectancy
WHERE status = '';

#15. Looking at 'Life expectancy' column, lets populate missing values with average 

SELECT *
FROM world_life_expectancy
WHERE `Life expectancy` = '';

SELECT *
FROM world_life_expectancy
WHERE `Life expectancy` = '';

SELECT t1.Country, t1.Year, t1.`Life expectancy`, t2.Country, t2.Year, t2.`Life expectancy`, t3.Country, t3.Year, t3.`Life expectancy`, ROUND((t2.`Life expectancy` + t3.`Life expectancy`)/2,1) as average_exp
FROM world_life_expectancy t1
JOIN world_life_expectancy t2 
	ON t1.Country = t2.Country
    AND t1.Year = t2.Year - 1
JOIN world_life_expectancy t3
	ON t1.Country = t3.Country
    AND t1.Year = t3.Year + 1
WHERE t1.`Life expectancy` = '';
 
UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2 
	ON t1.Country = t2.Country
    AND t1.Year = t2.Year - 1
JOIN world_life_expectancy t3
	ON t1.Country = t3.Country
    AND t1.Year = t3.Year + 1
SET t1.`Life expectancy` = ROUND((t2.`Life expectancy` + t3.`Life expectancy`)/2,1)
WHERE t1.`Life expectancy` = '';
    
#16 . Double checking we we have no blanks in the 'Status' field 

SELECT *
FROM world_life_expectancy
WHERE status = '';

# We continue our cleaning and will perform EDA in part 2. 


