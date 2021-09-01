USE pizza_runner;

############ Part C. Ingredient Optimisation ######

-- 1. What are the standard ingredients for each pizza?



-- 2. What was the most commonly added extra?
# Step-1. Separate comma separated value in different rows. Use SUBSTRING_INDEX(str,delim,count)
# step-2. Count the occurrences for each item.
# step-3. Find the name of that item.

# experimenting with SUBSTRING_INDEX()
SELECT extras,
       SUBSTRING_INDEX(extras,',',1),   -- first value
       SUBSTRING_INDEX(SUBSTRING_INDEX(extras,',',2),',',-1)    -- last value
FROM customer_orders
WHERE extras REGEXP '[0-9]+' 
;

# finding a way to create multiple row
WITH CTE 
AS (SELECT 1 AS n
	  UNION SELECT 2 AS n
	  UNION SELECT 3 AS n
)

SELECT *
FROM CTE
;



# Final solution

WITH CTE 
AS (SELECT 1 AS n
	  UNION SELECT 2 AS n
	  UNION SELECT 3 AS n
),

CTE2
AS (SELECT extras,
            n,
			CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(extras,',',n),',',-1) AS FLOAT) AS extras_mod
	FROM customer_orders
	JOIN CTE ON CHAR_LENGTH(extras)-CHAR_LENGTH(REPLACE(extras,',',""))>=n-1      -- advanced join
	WHERE extras REGEXP '[0-9]+') ,

CTE3
AS (SELECT extras_mod,COUNT(*) AS occurrences
	FROM CTE2
	GROUP BY 1
	ORDER BY 2 DESC
	LIMIT 1)
    
SELECT topping_name AS most_commonly_added_extra
FROM pizza_toppings
WHERE topping_id=( SELECT extras_mod
                   FROM CTE3)
;


-- # for understanding

-- WITH CTE 
-- AS (SELECT 1 AS n
-- 	  UNION SELECT 2 AS n
-- 	  UNION SELECT 3 AS n
-- )

-- SELECT      *,
--            
--             n,
--             CHAR_LENGTH(extras)-CHAR_LENGTH(REPLACE(extras,',',"")),
--             extras,
--             SUBSTRING_INDEX(extras,',',n),
--             
-- 			CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(extras,',',n),',',-1) AS FLOAT) AS extras_mod
-- 	FROM customer_orders
-- 	JOIN CTE ON CHAR_LENGTH(extras)-CHAR_LENGTH(REPLACE(extras,',',""))>=n-1     -- advanced join
-- 	WHERE extras REGEXP '[0-9]+'
-- ;



-- 3. What was the most common exclusion?

# Step-1. Separate comma separated value in different rows. Use SUBSTRING_INDEX(str,delim,count)
# step-2. Count the occurrences for each item.
# step-3. Find the name of that item.

WITH CTE
AS (SELECT 1 AS n
	UNION SELECT 2 AS  n
	UNION SELECT 3 AS n)
 ,
CTE2 
AS (SELECT order_id,
		   n,
		   exclusions,
		   CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(exclusions,',',n),',',-1) AS FLOAT) AS exclusions_mod
		   
	FROM CTE
	JOIN customer_orders
	ON CHAR_LENGTH(exclusions)-CHAR_LENGTH(REPLACE(exclusions,',',''))>=n-1
	WHERE exclusions REGEXP '[0-9]+' )
 ,
CTE3
AS (SELECT exclusions_mod,COUNT(*) AS occurrences
	FROM CTE2
	GROUP BY 1
	ORDER BY 2 DESC
	LIMIT 1)

SELECT topping_name AS most_common_exclusion
FROM pizza_toppings
WHERE topping_id= (SELECT exclusions_mod
                   FROM CTE3)
;

-- SELECT exclusions,
--        CHAR_LENGTH(exclusions),
--        CHAR_LENGTH(REPLACE(exclusions,',','')),
--        CHAR_LENGTH(exclusions)-CHAR_LENGTH(REPLACE(exclusions,',',''))
-- FROM customer_orders
-- WHERE exclusions REGEXP '[0-9]+' 
-- ;





-- 4. Generate an order item for each record in the customers_orders table in the format of one of the following:
--    a. Meat Lovers
--    b. Meat Lovers - Exclude Beef
--    c. Meat Lovers - Extra Bacon
--    d. Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers

SELECT *,
       CASE 
         WHEN pizza_id=1 THEN 'Meat Lovers'
         ELSE 'Vegetarian'
	   END AS pizza_type
FROM customer_orders
;

SELECT *
FROM pizza_toppings
;

SELECT exclusions,
        CAST(exclusions AS FLOAT)
FROM customer_orders
;


-- 5. Generate an alphabetically ordered comma separated ingredient list for each pizza order from the customer_orders table and add a 2x in front of any relevant ingredients
--    For example: "Meat Lovers: 2xBacon, Beef, ... , Salami"




-- 6. What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?


