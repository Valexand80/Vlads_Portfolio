# World Life Expectancy Project (EDA and data cleaning)
# Part 2 


SELECT *
FROM world_life_expectancy;

#1. Let's look at the range of the lowest and highest life expectancy among the countries

SELECT Country, Status, MIN(`Life expectancy`), MAX(`Life expectancy`), ROUND(MAX(`Life expectancy`) - MIN(`Life expectancy`),2) AS expect_diff
FROM world_life_expectancy
GROUP BY Country, Status
ORDER BY expect_diff DESC; 

# This shows us that Haiti has made the most progress in the last 15 years. It went from having life expectancy of only 36 years to 65 years, a difference of almost 29 years. Great result! 
# On the other hand, if we order by least difference we can see developing countries like Guyana, Seychelles and Kuwait had smallest improvements of all. 

#2. Range by status only. We can see huge difference between developed and developing countries

SELECT Status, MIN(`Life expectancy`), MAX(`Life expectancy`), ROUND(MAX(`Life expectancy`) - MIN(`Life expectancy`),2) AS expect_diff
FROM world_life_expectancy
GROUP BY Status
ORDER BY expect_diff;

#3. Life expectancy variation per year: (On average, life expectancy went up from 67 to 72 years)

SELECT Year, ROUND(AVG(`Life expectancy`),2)
FROM world_life_expectancy
GROUP BY Year
ORDER BY Year; 

#4. Let's look at the relationship between countries and their GDP. We can see that we still have dirty data, as Afghanistan in 2018 is showing GDP vslue of 64, but years in between showed 553 and 670

SELECT Country, ROUND(AVG(`Life expectancy`),1) AS life_expect, ROUND(AVG(GDP),1) AS GDP
FROM world_life_expectancy
GROUP BY Country
ORDER BY life_expect DESC;

#5. Lets investigate 'GDP' column a bit further. From initial look, it looks like it may contain a lot of bad data. Grouping data by country and looking at MIN and MAX values of GDP can give us an idea about our data. 

SELECT Country, MIN(GDP), MAX(GDP)
FROM world_life_expectancy
GROUP BY Country; 

#  As we can see, the GDP column data is very bad. Fro example, Italy GDP data goes from 25 to 38335. In fact, it looks like every country has at least one row of bad data. This makes it unusable. Values have to be cleaned and/or replaced with clean quality data. 

#8. Let's look at other columns, such as 'Adult Mortality' 

SELECT Country, MIN(`Adult Mortality`), MAX(`Adult Mortality`)
FROM world_life_expectancy
GROUP BY Country; 

#  As we can see, the data is once again all over the place. Albania ranges from 1 to 99 (as an example). We can't rely on this kind of data. 

#9. Let's look at BMI numbers

SELECT Country, MIN(BMI), MAX(BMI)
FROM world_life_expectancy
GROUP BY Country
ORDER BY MAX(BMI) DESC; 

#10 Yet again, we are getting very strange numbers. Some countries have BMI index of 70+. We just have a lot of had data on our hands. 

SELECT *
FROM world_life_expectancy;

#11 Let's look at couple more columns to see if we can work with some other data. 'Measles' cases. 

SELECT Country, MIN(Measles), MAX(Measles)
FROM world_life_expectancy
GROUP BY Country;
 # ORDER BY MAX(BMI) DESC; 

# once again, the data is all over the place. We have a lot of 0 values, and ranges from 73 to 6187 (as in Malaysia). 

#12. Looking at infant deaths numbers. 

SELECT Country, MIN(`infant deaths`), MAX(`infant deaths`)
FROM world_life_expectancy
GROUP BY Country; 
 # ORDER BY MAX(BMI) DESC

#13. Infact deaths data seems to be more reliable at first glance. Let's examine it a bit further. Grouping by country status can give us an idea about how it is distributed

SELECT Status, MIN(`infant deaths`), AVG(`infant deaths`), MAX(`infant deaths`)
FROM world_life_expectancy
GROUP BY Status; 
 # ORDER BY MAX(BMI) DESC

#14 Interestingly, the average 'infant death' for developed country is only 1.5, while the number is 36.5 for developing nations. The difference is more than 24x! Lets look at the breakdown by year 

SELECT Status, Year, MIN(`infant deaths`), AVG(`infant deaths`), MAX(`infant deaths`)
FROM world_life_expectancy
GROUP BY Status, Year;  
 
#15 Let's look at the range of values for 'infant deaths' over the 15 years. Average number of deaths in developed countries has dropped from 1.78 to 1.18. While developing nations' value decreased from 45 to 28. Overall, the numbers are impressive. 

SELECT Status, MIN(avg_deaths), MAX(avg_deaths)
FROM  
	(SELECT Status, Year, MIN(`infant deaths`), AVG(`infant deaths`) AS avg_deaths, MAX(`infant deaths`)
	FROM world_life_expectancy
	GROUP BY Status, Year ) AS avg_table 
GROUP BY Status; 














