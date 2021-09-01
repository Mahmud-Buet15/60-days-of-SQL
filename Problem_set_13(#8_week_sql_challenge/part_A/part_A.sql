USE pizza_runner;

############ Part A - Pizza Metrics ######

-- 1. How many pizzas were ordered?

SELECT COUNT(*) AS  pizza_ordered
FROM customer_orders
;


-- 2. How many unique customer orders were made?

SELECT COUNT(DISTINCT order_id) AS unique_customer_orders
FROM customer_orders
;


-- 3. How many successful orders were delivered by each runner?

SELECT runner_id,COUNT(*) AS successfull_orders
FROM customer_orders c
JOIN runner_orders ro ON c.order_id=ro.order_id
WHERE pickup_time <> 'null'      -- As the datatype is VARCHAR, IS NOT NULL shouldn't be used.
GROUP BY 1
;


-- 4. How many of each type of pizza was delivered?

#method- 1

SELECT 
    CASE
        WHEN pizza_id = 1 THEN 'Meat Lovers'
        ELSE 'Vegetarian'
    END AS pizza_types,
    COUNT(*) AS order_count
FROM
    customer_orders c
        JOIN
    runner_orders ro ON c.order_id = ro.order_id
WHERE
    pickup_time <> 'null'
GROUP BY 1
;

#method- 2

SELECT 
    SUM(CASE
        WHEN pizza_id = 1 THEN 1
        ELSE 0
    END) AS 'Meat Lovers',
    SUM(CASE
        WHEN pizza_id = 2 THEN 1
        ELSE 0
    END) AS 'Vegetarian'
FROM
    customer_orders c
        JOIN
    runner_orders ro ON c.order_id = ro.order_id
WHERE
    pickup_time <> 'null'
;


-- 5. How many Vegetarian and Meatlovers were ordered by each customer?

SELECT 
    customer_id,
    SUM(CASE
        WHEN pizza_id = 1 THEN 1
        ELSE 0
    END) AS 'Meat Lovers',
    SUM(CASE
        WHEN pizza_id = 2 THEN 1
        ELSE 0
    END) AS 'Vegetarian'
FROM
    customer_orders
GROUP BY 1
;


-- 6. What was the maximum number of pizzas delivered in a single order?

SELECT COUNT(*) AS max_num_of_delivery
FROM
    customer_orders c
        JOIN
    runner_orders ro ON c.order_id = ro.order_id
WHERE
    pickup_time <> 'null'
GROUP BY c.order_id
ORDER BY max_num_of_delivery DESC
LIMIT 1
;


-- 7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?


WITH CTE
AS (SELECT customer_id,
		   exclusions,
		   extras,
		   CASE
			 WHEN exclusions REGEXP '[0-9]' OR extras REGEXP '[0-9]' THEN 1 ELSE 0
		   END AS changes
	FROM
		customer_orders c
			JOIN
		runner_orders ro ON c.order_id = ro.order_id
	WHERE
		pickup_time <> 'null'
		AND extras <> 'null' )

SELECT customer_id,
       SUM(changes) AS  has_changes,
       SUM(CASE
		 WHEN changes = 0 THEN 1 ELSE 0
	   END) AS no_changes
FROM CTE
GROUP BY 1
;


-- 8. How many pizzas were delivered that had both exclusions and extras?

SELECT COUNT(*) AS pizzas_with_exclusions_and_extras
FROM
    customer_orders c
        JOIN
    runner_orders ro ON c.order_id = ro.order_id
WHERE
    pickup_time <> 'null'
    AND exclusions REGEXP '[0-9]' AND extras REGEXP '[0-9]'
;


-- 9. What was the total volume of pizzas ordered for each hour of the day?

SELECT 
       HOUR(CAST(order_time AS DATETIME)) AS hour,
       COUNT(*) AS order_count
FROM customer_orders
GROUP BY 1
;


-- 10. What was the volume of orders for each day of the week?

SELECT 
       DAYNAME(CAST(order_time AS DATETIME)) AS day_of_week,
       COUNT(*) order_count
       
FROM customer_orders
GROUP BY 1
ORDER BY 2 DESC
;