USE Parch_and_posey;

-- ################################# PART E - Window Functions ###############################

-- 1. Create a running total of standard_qty.

SELECT standard_qty, 
SUM(standard_qty) OVER(ORDER BY occurred_at) AS running_total
FROM orders
;


-- 2. Create a running total of standard_qty by each month.


SELECT standard_qty, 
DATE_FORMAT(occurred_at, '%y-%m-%01') AS month,
SUM(standard_qty) OVER(PARTITION BY DATE_FORMAT(occurred_at, '%y-%m-%01') ORDER BY occurred_at) AS running_total
FROM orders
;

-- 3.  create a running total of standard_amt_usd (in the orders table) over order time with no date truncation.
-- Your final table should have two columns: one with the amount being added for each new row, and a second with the running total.


SELECT 
    standard_amt_usd,
    SUM(standard_amt_usd) OVER(ORDER BY occurred_at) AS  running_total
    
FROM
    orders
;


-- 4. Create a running total of standard_amt_usd (in the orders table) over order time, but this time, date truncate occurred_at by year and partition by that same year-truncated occurred_at variable.
-- Your final table should have three columns: One with the amount being added for each row, one for the truncated date, and a final column with the running total within each year.

SELECT DATE_FORMAT(occurred_at,'%y-%01-%01') AS year,
standard_amt_usd,
SUM(standard_amt_usd) OVER(PARTITION BY DATE_FORMAT(occurred_at,'%y-%01-%01') ORDER BY occurred_at) AS running_total
FROM orders
;


-- 5. Select the id, account_id, and total variable from the orders table, then create a column called total_rank that ranks this total amount of paper ordered (from highest to lowest) for each account using a partition.
-- Your final table should have these four columns.

SELECT id,account_id,total,
       RANK() OVER(PARTITION BY account_id ORDER BY total DESC) AS  total_rank
FROM orders
;


                                         ###### Window Function Aggregation Experiment #######
										
                                        

SELECT id,
       account_id,
       standard_qty,
       DATE_FORMAT(occurred_at,'%y-%m-%01') AS month,
       DENSE_RANK() OVER (PARTITION BY account_id ORDER BY DATE_FORMAT(occurred_at,'%y-%m-%01')) AS dense_ranking,
       SUM(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_FORMAT(occurred_at,'%y-%m-%01')) AS sum_std_qty,
       COUNT(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_FORMAT(occurred_at,'%y-%m-%01')) AS count_std_qty,
       AVG (standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_FORMAT(occurred_at,'%y-%m-%01')) AS avg_std_qty,
       MIN(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_FORMAT(occurred_at,'%y-%m-%01')) AS min_std_qty,
       MAX(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_FORMAT(occurred_at,'%y-%m-%01')) AS max_std_qty
FROM orders
;

## Note: Values from similar month are grouped together.

## Without ORDER BY
SELECT id,
       account_id,
       standard_qty,
       DATE_FORMAT(occurred_at,'%y-%m-%01') AS month,
       DENSE_RANK() OVER (PARTITION BY account_id ) AS dense_ranking,
       SUM(standard_qty) OVER (PARTITION BY account_id ) AS sum_std_qty,
       COUNT(standard_qty) OVER (PARTITION BY account_id ) AS count_std_qty,
       AVG (standard_qty) OVER (PARTITION BY account_id ) AS avg_std_qty,
       MIN(standard_qty) OVER (PARTITION BY account_id ) AS min_std_qty,
       MAX(standard_qty) OVER (PARTITION BY account_id ) AS max_std_qty
FROM orders
;

## Aliasing for multiple window funtion .  More easiler to read

SELECT id,
       account_id,
       standard_qty,
       DATE_FORMAT(occurred_at,'%y-%m-%01') AS month,
       DENSE_RANK() OVER main_window AS dense_ranking,
       SUM(standard_qty) OVER main_window AS sum_std_qty,
       COUNT(standard_qty) OVER main_window AS count_std_qty,
       AVG (standard_qty) OVER main_window AS avg_std_qty,
       MIN(standard_qty) OVER main_window AS min_std_qty,
       MAX(standard_qty) OVER main_window AS max_std_qty
FROM orders
WINDOW main_window AS (PARTITION BY account_id ORDER BY DATE_FORMAT(occurred_at,'%y-%m-%01'))
;


#### LAG() and LEAD()

WITH CTE
AS (SELECT account_id,SUM(standard_qty) AS standard_sum
		FROM orders
		GROUP BY 1)
        
SELECT account_id,
      LAG(standard_sum) OVER(ORDER BY standard_sum) AS lag_standard_sum,
      standard_sum,
      LEAD(standard_sum) OVER(ORDER BY standard_sum) AS  lead_standard_sum,
      standard_sum-LAG(standard_sum) OVER(ORDER BY standard_sum) AS lag_difference,
      LEAD(standard_sum) OVER(ORDER BY standard_sum)-standard_sum AS  lead_difference
FROM CTE
;



-- 6. Determine how the current order's total revenue ("total" meaning from sales of all types of paper) compares to the next order's total revenue.

WITH CTE 
AS (SELECT occurred_at,SUM(total_amt_usd) AS sum_total
		FROM orders
		GROUP BY 1)
        
SELECT occurred_at,
       sum_total AS current_value,
       LEAD(sum_total) OVER(ORDER BY occurred_at) AS lead_value,
       LEAD(sum_total) OVER(ORDER BY occurred_at)-sum_total AS lead_difference
FROM CTE
;

SELECT occurred_at,SUM(total_amt_usd) AS sum_total
		FROM orders
		GROUP BY 1
;



###### NLITLE() #####

-- NTILE(100) : Percentile. The full dataset will be divided into 100 sections. Lowest value will be in first tile and last value will be in last tile.
-- NTILE(4): Quartile . The full dataset will be divided into 4 sections. Lowest value will be in first quartile and last value will be in last quartile.
-- NTILE(5): Quintile. The full dataset will be divided into 5 sections. Lowest value will be in first quintile and last value will be in last quintile.

SELECT id, 
       account_id,
	   occurred_at,
       standard_qty,
       NTILE(4) OVER(ORDER BY standard_qty) AS  quartile ,
       NTILE(5) OVER(ORDER BY standard_qty) AS  quintile ,
       NTILE(100) OVER(ORDER BY standard_qty) AS percentile
FROM orders
ORDER BY standard_qty DESC
;



-- 7. Use the NTILE functionality to divide the accounts into 4 levels in terms of the amount of standard_qty for their orders.
-- Your resulting table should have the account_id, the occurred_at time for each order, the total amount of standard_qty paper purchased, and one of four levels in a standard_quartile column.

SELECT account_id,
       occurred_at,
       standard_qty,
       NTILE(4) OVER(PARTITION BY account_id ORDER BY standard_qty) AS quartile
FROM orders
ORDER BY account_id
;


-- 8. Use the NTILE functionality to divide the accounts into two levels in terms of the amount of gloss_qty for their orders.
-- Your resulting table should have the account_id, the occurred_at time for each order, the total amount of gloss_qty paper purchased, and one of two levels in a gloss_half column.

SELECT account_id,
	   occurred_at,
       gloss_qty,
       NTILE(2) OVER(PARTITION BY account_id ORDER BY gloss_qty) AS gloss_half
FROM orders
ORDER BY account_id
;

-- 9. Use the NTILE functionality to divide the orders for each account into 100 levels in terms of the amount of total_amt_usd for their orders.
-- Your resulting table should have the account_id, the occurred_at time for each order, the total amount of total_amt_usd paper purchased, and one of 100 levels in a total_percentile column.


SELECT account_id,
       occurred_at,
       total_amt_usd,
       NTILE(100) OVER(PARTITION BY account_id ORDER BY total_amt_usd) AS percentile
FROM orders
ORDER BY account_id DESC
;

-- Note: For percentile, if any account_id doesn't have 100 rows then rows will by divided by the number of rows it has. 



