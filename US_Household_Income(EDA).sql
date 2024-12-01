# Exploratory Data analysis of household income dataset 

#1. Top 10 States with the highest income  

SELECT State_Name, AVG(Mean)
FROM us_household_income_statistics
GROUP BY State_Name
ORDER BY AVG(Mean) DESC
limit 10; 


#2. States with the lowest average household income 

SELECT State_Name, AVG(Mean)
FROM us_household_income_statistics
GROUP BY State_Name
ORDER BY AVG(Mean) ASC
limit 10;

#3. Let's join this dataset (statistics with household income dataset) and check for null and 0 values in the "Mean" incomes which would indicate bad or dirty data

SELECT * 
FROM us_household_income uhi
JOIN us_household_income_statistics uhs ON uhi.id = uhs.id
WHERE Mean = 0; 

SELECT * 
FROM us_household_income uhi
JOIN us_household_income_statistics uhs ON uhi.id = uhs.id
WHERE Mean IS NULL; 

# Looks like we have 310 rows where we have some bad/missing data but we have no NULL values which is good. From now on, we will exclude those values with 0 or delete them altogether from our dataset

#4. Let's see top 10 States with the highest household income but now we will be excluding those regions with " 0 income ' 

SELECT State_Name, AVG(Mean)
FROM us_household_income_statistics
WHERE Mean <>0
GROUP BY State_Name
ORDER BY AVG(Mean) DESC
limit 10; 

#5. Let's apply same logic to the 10 States with the lowest household income. 

SELECT State_Name, AVG(Mean)
FROM us_household_income_statistics
WHERE Mean <> 0
GROUP BY State_Name
ORDER BY AVG(Mean); 

#6. Let's examine State of California a bit closer. Lets see top counties with the highest income

SELECT County, ROUND(AVG(Mean),0)
FROM us_household_income uhi
JOIN us_household_income_statistics uhs ON uhi.id = uhs.id
WHERE Mean <> 0 AND uhs.State_Name = "California"
GROUP BY County
ORDER BY ROUND(AVG(Mean),0) DESC; 

#7. Now, Lets see counties with the lowest income 

SELECT County, ROUND(AVG(Mean),0) AS Income 
FROM us_household_income uhi
JOIN us_household_income_statistics uhs ON uhi.id = uhs.id
WHERE Mean <> 0 AND uhs.State_Name = "California"
GROUP BY County
ORDER BY ROUND(AVG(Mean),0) ASC; 

#8. Let's examine areas of land and areas of water and how it is different for some states. 
    # Values are in square meters. Now, this dataset does not provide the data for all the cities, only selected ones.
    # Here an example of only 1 city returning for Mono Country in California

SELECT State_Name, City, County, ALand, AWater
FROM us_household_income
WHERE State_Name = 'California' AND County = 'Mono County'; 

#9. It appears to show that Texas has the mosts land which is not true. Alaska is the biggest state in US. It appears that Alaska has very few data points. Let's investigate this further. 

SELECT State_Name, SUM(ALand), SUM(AWater)
FROM us_household_income
GROUP BY State_Name 
ORDER BY SUM(ALand) DESC; 

#10. Let's look at Alaska specifically and why it is not showing that it is the biggest state. 

SELECT COUNT(City) 
FROM us_household_income
WHERE State_Name = 'Alaska'; 

# We have 87 Cities, while in reality Alaska contains 149 incorporated cities. 

#11. How many different area codes are there in Alaska? 
  
SELECT COUNT(DISTINCT Area_Code) 
FROM us_household_income
WHERE State_Name = 'Alaska';

# Alaska only has 1 distinct area code (in our dataset), which is very interesting 

SELECT COUNT(City) 
FROM us_household_income
WHERE State_Name = 'Alaska'; 

#12. Let's create couple calcuated columns based on Area of land and areas of water. Also, let's categorize our data as far as water content and use CASE statement. 

SELECT State_Name, City, County, ALand, AWater, (ALand + AWater) as Total_area, ROUND(AWater/(ALand + AWater)*100,2) as WaterPercent, 
CASE WHEN ROUND(AWater/(ALand + AWater)*100,2) = 100 THEN 'All Water' 
WHEN ROUND(AWater/(ALand + AWater)*100,2) > 50 THEN 'Mostly Water'
WHEN ROUND(AWater/(ALand + AWater)*100,2) > 20 THEN 'Lotsa Water'
WHEN ROUND(AWater/(ALand + AWater)*100,2) < 10 THEN 'Little or No Water'
END AS Water_content 
FROM us_household_income; 

#13. Let's create a View and investigate our new Water_content column further

CREATE VIEW Water_content_view AS 
SELECT State_Name, City, County, ALand, AWater, (ALand + AWater) as Total_area, ROUND(AWater/(ALand + AWater)*100,2) as WaterPercent, 
CASE WHEN ROUND(AWater/(ALand + AWater)*100,2) = 100 THEN 'All Water' 
WHEN ROUND(AWater/(ALand + AWater)*100,2) > 50 THEN 'Mostly Water'
WHEN ROUND(AWater/(ALand + AWater)*100,2) > 20 THEN 'Lotsa Water'
WHEN ROUND(AWater/(ALand + AWater)*100,2) < 10 THEN 'Little or No Water'
END AS Water_content 
FROM us_household_income;

SELECT Water_content, COUNT(State_Name)
FROM Water_content_view
GROUP BY Water_content; 


# Let's do an example of using CTE for the same purpose 

WITH Water_content_CTE AS
(SELECT State_Name, City, County, ALand, AWater, (ALand + AWater) as Total_area, ROUND(AWater/(ALand + AWater)*100,2) as WaterPercent, 
CASE WHEN ROUND(AWater/(ALand + AWater)*100,2) = 100 THEN 'All Water' 
WHEN ROUND(AWater/(ALand + AWater)*100,2) > 50 THEN 'Mostly Water'
WHEN ROUND(AWater/(ALand + AWater)*100,2) > 20 THEN 'Lotsa Water'
WHEN ROUND(AWater/(ALand + AWater)*100,2) < 10 THEN 'Little or No Water'
END AS Water_content 
FROM us_household_income)

# Let's filter for those areas where there is NO Land. Meaning those are probably bad values. 
Select * 
FROM Water_content_CTE
WHERE ALand = 0;   

#14. Let's get back to a national income table joined with this one to see some of the towns with the highest income.

SELECT uhi.State_Name, City, AVG(Mean)
FROM us_household_income uhi
JOIN us_household_income_statistics uhs ON uhi.id = uhs.id
GROUP BY State_Name, City
ORDER BY AVG(Mean) DESC; 

# Most of the highest earning cities are in the northeast 

#15. Let's see the similar list but with the lowest income

SELECT uhi.State_Name, City, AVG(Mean)
FROM us_household_income uhi
JOIN us_household_income_statistics uhs ON uhi.id = uhs.id
GROUP BY State_Name, City
ORDER BY AVG(Mean) ;

# We have some 0 values, data is not clean and those should have been removed in our cleaning project. For now, we can filter those out 

SELECT uhi.State_Name, City, AVG(Mean)
FROM us_household_income uhi
JOIN us_household_income_statistics uhs ON uhi.id = uhs.id
GROUP BY State_Name, City
HAVING AVG(Mean) <> 0
ORDER BY AVG(Mean) ;  

