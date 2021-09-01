USE pizza_runner;

############ Part D. Pricing and Ratings ######

-- 1. If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes - how much money has Pizza Runner made so far if there are no delivery fees?

SELECT runner_id,
		  SUM(CASE
			 WHEN pizza_id=1 THEN 12
			 ELSE 10
		   END) AS income
	FROM customer_orders c
	JOIN  runner_orders ro ON c.order_id=ro.order_id
	WHERE pickup_time <> 'null'
GROUP BY 1
;


-- 2. What if there was an additional $1 charge for any pizza extras?
-- a) Add cheese is $1 extra


WITH CTE
AS (SELECT c.order_id,
		   ro.runner_id,
		   CASE
			 WHEN pizza_id=1 THEN 12
			 ELSE 10
		   END AS pizza_cost,
		   CHAR_LENGTH(REPLACE(REPLACE(COALESCE(extras,''),'null',''),', ','')) AS extra_cost       -- 1. NULL values are filled with ''(no character) 2. 'null' strings are replaced with '' 3. ', ' are replace by '' 4. Character length is measured
	FROM customer_orders c
	JOIN  runner_orders ro ON c.order_id=ro.order_id
	WHERE pickup_time <> 'null')
    
SELECT runner_id,SUM(pizza_cost+extra_cost) AS total_income
FROM CTE
GROUP BY 1
;


-- 3. The Pizza Runner team now wants to add an additional ratings system that allows customers to rate their runner, 
-- how would you design an additional table for this new dataset -  generate a schema for this new table and insert your own data for ratings for each successful customer order between 1 to 5.

DROP TABLE IF EXISTS runner_ratings;
CREATE TABLE runner_ratings (
			 runner_id INTEGER,
             rating INTEGER
             );
             
DESC runner_ratings;

INSERT INTO runner_ratings
        (runner_id,rating)
VALUES 
       (1,5),
       (2,4),
       (3,4),
       (4,NULL);
       
SELECT *
FROM runner_ratings
;



-- 4. Using your newly generated table - can you join all of the information together to form a table which has the following information for successful deliveries?
-- a) customer_id
-- b) order_id
-- c) runner_id
-- d) rating
-- e) order_time
-- f) pickup_time
-- g) Time between order and pickup
-- h) Delivery duration
-- i) Average speed
-- j) Total number of pizzas

SELECT customer_id,
	   c.order_id,
       ro.runner_id,
       rating,
       order_time,
       pickup_time,
       CONCAT(CAST(TIMESTAMPDIFF(MINUTE,order_time,pickup_time) AS CHAR),' minutes')  AS time_between_order_and_pickup,
       CONCAT(REGEXP_SUBSTR(duration,'[0-9]+'),' minutes') AS delivery_duration,
       CONCAT(CAST(ROUND(CAST(REGEXP_SUBSTR(distance,'[0-9.]+') AS FLOAT)/CAST(REGEXP_SUBSTR(duration,'[0-9]+') AS FLOAT),2) AS CHAR),' km/min') AS speed
FROM customer_orders c
JOIN runner_orders ro ON c.order_id=ro.order_id
JOIN runner_ratings rr ON ro.runner_id=rr.runner_id
WHERE pickup_time <> 'null'
;


-- 5) If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras and each runner is paid $0.30 per kilometre traveled - how much money does Pizza Runner have left over after these deliveries?


WITH CTE
AS (SELECT runner_id,
			   SUM(CASE
				 WHEN pizza_id=1 THEN 12
				 ELSE 10
			   END) AS pizza_cost,
			  SUM(CAST(REGEXP_SUBSTR(distance,'[0-9.]+') AS FLOAT) *0.3) AS delivery_cost
		   
	FROM customer_orders c
	JOIN  runner_orders ro ON c.order_id=ro.order_id
	WHERE pickup_time <> 'null'
	GROUP BY 1)
    
    
SELECT runner_id,CONCAT(CAST(ROUND(pizza_cost+delivery_cost,2) AS CHAR),' $') AS total_income
FROM CTE
;
