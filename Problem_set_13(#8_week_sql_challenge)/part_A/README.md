# Entity Relationship Diagram
![alt text](https://github.com/Mahmud-Buet15/60-days-of-SQL/blob/main/Problem_set_13(%238_week_sql_challenge)/dataset/pizza_runner.png)


# Part A Solutions - SQL Joins

#### **Q1. How many pizzas were ordered?**
```sql
SELECT COUNT(*) AS  pizza_ordered
FROM customer_orders
;


```

#### **Q2. How many unique customer orders were made?**

```sql
SELECT COUNT(DISTINCT order_id) AS unique_customer_orders
FROM customer_orders
;
```

#### **Q3. How many successful orders were delivered by each runner?**

```sql
SELECT runner_id,COUNT(*) AS successfull_orders
FROM customer_orders c
JOIN runner_orders ro ON c.order_id=ro.order_id
WHERE pickup_time <> 'null'      -- As the datatype is VARCHAR, IS NOT NULL shouldn't be used.
GROUP BY 1
;
```

#### **Q4. How many of each type of pizza was delivered?**
```sql
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
```

#### **Q5. How many Vegetarian and Meatlovers were ordered by each customer?**

```sql
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
```

#### **Q6. What was the maximum number of pizzas delivered in a single order?**

```sql
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
```


#### **Q7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?**

```sql
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
```

#### **Q8. How many pizzas were delivered that had both exclusions and extras?**
```sql
SELECT COUNT(*) AS pizzas_with_exclusions_and_extras
FROM
    customer_orders c
        JOIN
    runner_orders ro ON c.order_id = ro.order_id
WHERE
    pickup_time <> 'null'
    AND exclusions REGEXP '[0-9]' AND extras REGEXP '[0-9]'
;
```

#### **Q9. What was the total volume of pizzas ordered for each hour of the day?**

```sql
SELECT 
       HOUR(CAST(order_time AS DATETIME)) AS hour,
       COUNT(*) AS order_count
FROM customer_orders
GROUP BY 1
;
```
#### **Q10. What was the volume of orders for each day of the week?**

```sql
SELECT 
       DAYNAME(CAST(order_time AS DATETIME)) AS day_of_week,
       COUNT(*) order_count
       
FROM customer_orders
GROUP BY 1
ORDER BY 2 DESC
;
```
