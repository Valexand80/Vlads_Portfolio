# SQL for Data Science Final Project. For this projoect, we are working with USDA's 7 different datasets.
  # cheese_production, coffee_production, egg_production, honey_production, milk_production, state_lookup,   		yogurt_peoduction. We have 10 questions to answer. 


#1. Can you find out the total milk production for 2023? Your manager wants this information for the yearly report.
    #What is the total milk production for 2023?

SELECT SUM(Value)
FROM milk_production
WHERE Year = 2023; 
# Answer: 91812000000

#2. Which states had cheese production greater than 100 million in April 2023? The Cheese Department wants to focus their marketing efforts there. 
#   How many states are there?

SELECT s.State,
 s.State_ANSI
FROM cheese_production c
JOIN state_lookup s
ON c.State_ANSI = s.State_ANSI
WHERE c.Value > 100000000
 AND c.Period = 'APR'
 AND c.Year = 2023;

#3. Your manager wants to know how coffee production has changed over the years. 

# What is the total value of coffee production for 2011?

SELECT SUM(Value)
FROM coffee_production
WHERE Year = 2011;


#4. There's a meeting with the Honey Council next week. Find the average honey production for 2022 so you're prepared.

SELECT AVG(Value)
FROM honey_production
WHERE Year = 2022; 


#5. The State Relations team wants a list of all states names with their corresponding ANSI codes. Can you generate that list?

# What is the State_ANSI code for Florida?
 
SELECT *
FROM state_lookup;
 
 
#6. For a cross-commodity report, can you list all states with their cheese production values, even if they didn't produce any cheese in April of 2023?

# What is the total for NEW JERSEY?

SELECT  s.State, 
 SUM(c.Value) total_cheese_prod
FROM state_lookup s
LEFT JOIN cheese_production c
ON s.State_ANSI = c.State_ANSI
WHERE c.Period = 'APR'
 AND c.Year = 2023
GROUP BY s.State
HAVING s.State = 'NEW JERSEY';

#7. Can you find the total yogurt production for states in the year 2022 which also have cheese production data from 2023? This will help the Dairy Division in their planning.

SELECT
 SUM(y.Value) total_yogurt
FROM yogurt_production y
WHERE y.Year = '2022'
 AND y.State_ANSI IN (
  SELECT DISTINCT
   c.State_ANSI
  FROM cheese_production c
  WHERE c.Year = '2023'
 );

#8. List all states from state_lookup that are missing from milk_production in 2023.

#   How many states are there?

SELECT COUNT(DISTINCT s.State) missing_states
FROM state_lookup s
LEFT JOIN milk_production p
ON S.State_ANSI = p.State_ANSI
 AND p.Year = 2023
WHERE p.State_ANSI IS NULL;

#9. List all states with their cheese production values, including states that didn't produce any cheese in April 2023.

#   Did Delaware produce any cheese in April 2023?

SELECT DISTINCT
 s.State, 
 p.Year 
FROM state_lookup s
LEFT JOIN cheese_production p
ON p.State_ANSI = s.State_ANSI 
 AND P.Year = 2023
 AND P.Period = 'APR'
WHERE S.State = 'DELAWARE';

# Answer: NO. 

#10. Find the average coffee production for all years where the honey production exceeded 1 million.

SELECT AVG(c.Value) AS average_coffee_production 
FROM coffee_production c 
JOIN honey_production h 
WHERE h.Value > 1000000;

