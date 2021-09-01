USE pizza_runner;

############ Part B. Runner and Customer Experience ######

-- 1. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)

# TIMESTAMPDIFF() can measure diffence between two timestamps in minutes,hours,weeks,months etc.

SELECT TIMESTAMPDIFF(WEEK,'2021-01-01',registration_date)+1 AS week, COUNT(*) AS registration_count
FROM runners
GROUP BY 1
;
-- 2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?

# TIMESTAMPDIFF() can measure diffence between two timestamps in minutes,hours,weeks,months etc.

SELECT runner_id,CONCAT(CAST(ROUND(AVG(TIMESTAMPDIFF(MINUTE,order_time,pickup_time)),2) AS CHAR),' minutes') AS  average_time_to_arrive
FROM customer_orders c 
JOIN runner_orders ro ON c.order_id=ro.order_id
WHERE pickup_time <> 'null'
GROUP BY 1
;



-- 3. Is there any relationship between the number of pizzas and how long the order takes to prepare?

## Assuming difference between order_time and pickup_time as order preparation time. 
SELECT c.order_id,
       COUNT(*) AS order_count, 
       CONCAT(CAST(ROUND(AVG(TIMESTAMPDIFF(MINUTE,order_time,pickup_time)),0) AS CHAR),' minutes') AS order_preparation_time
		
FROM customer_orders c
JOIN runner_orders ro ON c.order_id= ro.order_id
WHERE pickup_time <> 'null' 
GROUP BY 1
ORDER BY 2
;

## Conclusions:  * 10 minutes needed for 4 single order and 20 minutes needed for 1 single order.
##               * 21 minutes needed for 1 double order and 15 minutes needed for 1 double order.
##               * 29 minutes needed for 1 tripple order.
##       So we can conclude that preparation time increases with the number of pizzas


 
-- 4. What was the average distance travelled for each customer?

# step-1. The 'distance' is in string format. Extract the numbers (Use REGEX_SUBSTR() ) and then convert it in a number (FLOAT or DECIMAL) format.
# step-2. Calculate average distance for each customer.


SELECT customer_id,
       CONCAT(CAST(ROUND(AVG(CAST(REGEXP_SUBSTR(distance,"[0-9.]+") AS FLOAT)),2) AS CHAR),' km') AS avg_distance          -- VARCHAR shows error while converting from float to string
       
FROM customer_orders c 
JOIN runner_orders ro ON c.order_id=ro.order_id
WHERE pickup_time <> 'null'
GROUP BY 1
;



-- 5. What was the difference between the longest and shortest delivery times for all orders?

# step-1. The 'duration' is in string format. Extract the numbers (Use REGEX_SUBSTR() ) and then convert it in a number (FLOAT or DECIMAL) format.
# step-2. Calculate the difference between maximum and minimum time.

WITH CTE
AS (SELECT c.order_id,
		   CAST(REGEXP_SUBSTR(duration,'[0-9]+') AS FLOAT) AS duration_mod
	FROM customer_orders c 
	JOIN runner_orders ro ON c.order_id=ro.order_id
	WHERE pickup_time <> 'null')
    
SELECT CONCAT(CAST(MAX(duration_mod)-MIN(duration_mod) AS CHAR),' minutes') AS diff_bitween_longest_and_shortest_delivery_time
FROM CTE
;

-- 6. What was the average speed for each runner for each delivery and do you notice any trend for these values?


WITH CTE
AS (SELECT runner_id,
		   ro.order_id,
		   CAST(REGEXP_SUBSTR(distance,"[0-9.]+") AS FLOAT)*1000 AS distance_mod,
		   CAST(REGEXP_SUBSTR(duration,'[0-9]+') AS FLOAT)*60 AS duration_mod
	    FROM customer_orders c 
		JOIN runner_orders ro ON c.order_id=ro.order_id
		WHERE pickup_time <> 'null')
        
SELECT runner_id,order_id,CONCAT(CAST(ROUND(AVG(distance_mod/duration_mod),2) AS CHAR),' m/s')  AS  avg_speed
FROM CTE
GROUP BY 1,2
ORDER BY 1
;

# Note: A trend can be noticed. For each runner, their average speed increases with respect to previous order.



-- 7. What is the successful delivery percentage for each runner?

WITH CTE1
AS (SELECT runner_id,COUNT(*) AS total_orders
	FROM customer_orders c 
	JOIN runner_orders ro ON c.order_id=ro.order_id
	GROUP BY 1)
,
CTE2
AS (SELECT runner_id,COUNT(*) AS delivered_orders
	FROM customer_orders c 
	JOIN runner_orders ro ON c.order_id=ro.order_id
	WHERE pickup_time <> 'null'
	GROUP BY 1)

SELECT c1.runner_id,total_orders,delivered_orders,ROUND((delivered_orders/total_orders)*100,2) AS success_percentage
FROM CTE1 c1
JOIN CTE2 c2 ON c1.runner_id=c2.runner_id
;

