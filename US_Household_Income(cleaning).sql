# US Household income project. Part 1 (Data discovery and data cleaning)

SELECT * 
FROM us_household_income;

SELECT * 
FROM us_household_income_statistics;

#1. Data discovery. We have two related tables. Primary key column is 'id'. Let's see how many records are in our tables 



SELECT Count(*)
FROM us_household_income_statistics;

#2. Let's check for duplicates in the income table. We will have to delete these

SELECT id, Count(id)
FROM us_household_income
GROUP BY id
HAVING COUNT(id) > 1;

# It looks like we have 6 duplicates

#3. Let's check for duplicates in the stats table. We will have to delete these

SELECT id, Count(id)
FROM us_household_income_statistics
GROUP BY id
HAVING COUNT(id) > 1;

# No duplicates in the stats table. 

#4. let's explore more of the income table. Let's count total states, 

SELECT count(distinct State_name) 
FROM us_household_income;

# Looks like we are getting 53 states, which should NOT be the case

#5 Lets take a look in detail 

SELECT distinct State_name
FROM us_household_income;

# So, we have a misspell.. 'georia' should be 'Georgia'? Let's double check

SELECT row_id
FROM us_household_income
WHERE State_name = 'georia';

SELECT distinct *
FROM us_household_income
WHERE State_ab = 'GA' AND City = 'Milledgeville';

# We confirmed that name 'georia' should in fact be 'Georgia', its row_id is 7833

#6. Correcting state name

UPDATE us_household_income
SET State_Name = 'Georgia' WHERE
State_Name = 'georia'; 




#7. Removing our 6 duplicates

SELECT id, Count(id)
FROM us_household_income
GROUP BY id
HAVING COUNT(id) > 1;

SELECT * 
FROM (
SELECT row_id, 
id,
ROW_NUMBER() OVER(PARTITION BY id ORDER BY id) as row_num
FROM us_household_income) AS row_table
WHERE row_num > 1; 

# Now that we have the row_id number that need to be deleted, let's proceed with that 

DELETE FROM us_household_income 
WHERE row_id IN (
SELECT row_id 
FROM (
SELECT row_id, 
id,
ROW_NUMBER() OVER(PARTITION BY id ORDER BY id) as row_num
FROM us_household_income) AS row_table
WHERE row_num > 1 );

# 6 rows were changed, let's double check now. We now have no duplicates 

SELECT id, Count(id)
FROM us_household_income
GROUP BY id
HAVING COUNT(id) > 1;

#8 Lets do more discovery in few other columns: 
# Checking for County values that are blank

SELECT * 
FROM us_household_income
WHERE County = ''; 

# City
 
SELECT * 
FROM us_household_income
WHERE City =''; 

# Place is blank? 
 
SELECT * 
FROM us_household_income
WHERE Place =''; 

# Looks like we have 1 record in Alabama that has 'Place' as a blank. Lets update it 

SELECT * 
FROM us_household_income
WHERE State_ab = 'AL' AND City = 'Vinemont'; 

UPDATE us_household_income
SET Place = 'Autaugaville' 
WHERE County = 'Autauga County' AND City = 'Vinemont'; 

# 1 row was updates (confirmed)

#9. Lets look at some more columns

SELECT Type, COUNT(Type)
FROM us_household_income
GROUP BY Type; 

# Looks like we have a misspelling in one of the 'Boroughs'

#10. Update our table to reflect that change 
UPDATE us_household_income
SET Type = 'Borough'
WHERE City = 'Wyalusing' AND Place = 'Wyalusing';










