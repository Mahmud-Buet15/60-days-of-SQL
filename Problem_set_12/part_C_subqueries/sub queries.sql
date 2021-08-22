USE Parch_and_posey;

-- ################################# PART C - Sub Queries and Temporary Table ###############################

-- 1. Find the average number of events for each day for each channel. 

SELECT channel,
      AVG(number_of_events) AS avg_num_of_events
FROM (SELECT DATE_FORMAT(occurred_at,'%y-%m-%d') AS dates,channel,COUNT(id) AS number_of_events
	FROM web_events
	GROUP BY dates,channel) temp
GROUP BY channel
ORDER BY avg_num_of_events DESC
;

-- 2. Find the orders that took place in the same month and year as the first order. Then pull the average for each type of paper qty and total amount spent in this month.

SELECT AVG(standard_qty) AS avg_standard_qty,
	   AVG(gloss_qty) AS avg_gloss_qty,
       AVG(poster_qty) AS avg_poster_qty,
       SUM(total_amt_usd) AS  total_spent
FROM orders
WHERE DATE_FORMAT(occurred_at,'%y-%m') = 
	(SELECT DATE_FORMAT(MIN(occurred_at),'%y-%m') AS min_date
       FROM orders)

;

-- 3. Provide the name of the sales_rep in each region with the largest amount of total_amt_usd sales.

## step-1. Create a table showing regions,sales_reps,total_sales for sales_rep in each region and make it a temporary table
## step-2. Use the temp_table 1 to get maximum sales by each region and make it another temporary table
## step-3. Join the tables


SELECT t1.regions,t1.sales_reps,total_sales

FROM (SELECT r.name AS regions, s.name AS sales_reps, SUM(total_amt_usd) AS  total_sales
				FROM region r
				JOIN sales_reps s ON r.id=s.region_id
				JOIN accounts a ON s.id=a.sales_rep_id
				JOIN orders o ON a.id=o.account_id
				GROUP BY 1,2) AS  t1        
JOIN 

(SELECT regions,MAX(total_sales) AS max_sales
FROM (SELECT r.name AS regions, s.name AS sales_reps, SUM(total_amt_usd) AS  total_sales
		FROM region r
		JOIN sales_reps s ON r.id=s.region_id
		JOIN accounts a ON s.id=a.sales_rep_id
		JOIN orders o ON a.id=o.account_id
		GROUP BY 1,2) AS temp2
GROUP BY 1) AS  t2       

ON t1.regions=t2.regions AND t1.total_sales=t2.max_sales
;


                                                #### Using CTE ####

WITH CTE1
AS (SELECT r.name AS  region, s.name AS  sales_reps, SUM(total_amt_usd) AS  total_sales
	FROM region r
	JOIN sales_reps s ON r.id=s.region_id
	JOIN accounts a ON s.id=a.sales_rep_id
	JOIN orders o ON a.id=o.account_id
	GROUP BY 1,2),
    
CTE2 AS (SELECT region,MAX(total_sales) AS max_sales
			FROM CTE1
			GROUP BY 1)

SELECT t1.region,t1.sales_reps,total_sales
FROM CTE1 t1
JOIN CTE2 t2 ON t1.total_sales=t2.max_sales

;





-- 4. For the region with the largest (sum) of sales total_amt_usd, how many total (count) orders were placed?

## step-1. Create a temporary table showing total sales and total orders by each region and 
## step-2. Find the region name with largest sales
## step-3. Find the total orders for that region. Use WHERE clause.

SELECT regions,total_orders
FROM (SELECT r.name AS regions,COUNT(total) AS total_orders, SUM(total_amt_usd) AS  total_sales
		FROM region r
		JOIN sales_reps s ON r.id=s.region_id
		JOIN accounts a ON s.id=a.sales_rep_id
		JOIN orders o ON a.id=o.account_id
		GROUP BY regions) temp

WHERE regions = 
       (SELECT r.name AS regions
		FROM region r
		JOIN sales_reps s ON r.id=s.region_id
		JOIN accounts a ON s.id=a.sales_rep_id
		JOIN orders o ON a.id=o.account_id
		GROUP BY regions
        ORDER BY SUM(total_amt_usd) DESC
        LIMIT 1)
;


                                                #### Using CTE ####
                                                
   
 WITH CTE  
 AS (SELECT r.name AS  regions, SUM(total_amt_usd) AS  total_sales, COUNT(o.id) AS total_orders
	FROM region r
	JOIN sales_reps s ON r.id=s.region_id
	JOIN accounts a ON s.id=a.sales_rep_id
	JOIN orders o ON a.id=o.account_id  
    GROUP BY 1)

SELECT regions,total_orders
FROM CTE
WHERE regions= (SELECT regions
				FROM CTE
				ORDER BY total_sales DESC
				LIMIT 1)
;    

        

-- 5. How many accounts had more total purchases than the account name which has bought the most standard_qty paper throughout their lifetime as a customer?

## step-1. Create temporary table showing total_purchases and total_standard_qty_paper for each account name.
## step-2. Find the total_purchases of the account which has the most total_standard_qty_paper.
## step-3. Find the accounts which has more total_purchases than the purchase value . Use HAVING clause.
## step-4. Count the number of accounts.


SELECT COUNT(*) AS number_of_accounts
FROM ( SELECT a.name AS accounts,SUM(total) AS total_purchases
		FROM accounts a
		JOIN orders o ON a.id=o.account_id
		GROUP BY 1
		HAVING total_purchases>
			  ( SELECT SUM(total) AS total_purchases
				FROM accounts a
				JOIN orders o ON a.id=o.account_id
				GROUP BY a.name
				ORDER BY SUM(standard_qty) DESC
				LIMIT 1)) temp
;

                                                #### Using CTE ####

WITH CTE                                                
AS (SELECT a.name AS  accounts,SUM(total) AS  total_purchase , SUM(standard_qty) AS total_std_qty_purchase
	FROM accounts a
	JOIN orders o ON a.id=o.account_id
	GROUP BY 1)
 
SELECT COUNT(*) AS number_of_accounts
FROM CTE
WHERE total_purchase> ( SELECT total_purchase
						FROM CTE
						ORDER BY total_std_qty_purchase DESC
						LIMIT 1)
;											
					


-- 6. For the customer that spent the most (in total over their lifetime as a customer) total_amt_usd, how many web_events did they have for each channel?

## step-1. Find the customer who spent most.
## step-2. Use it as a sub query to get the number of web_events for each channel for that customer.


SELECT a.name AS accounts,channel,COUNT(w.id) AS  events
FROM web_events w
JOIN accounts a ON a.id=w.account_id
WHERE a.name = (SELECT a.name AS  accounts      
					FROM accounts a
					JOIN orders o ON a.id=o.account_id
					GROUP BY 1
					ORDER BY SUM(total_amt_usd) DESC
					LIMIT 1)
GROUP BY 1,2
ORDER BY 3 DESC
;

                                                #### Using CTE ####
                                                
 WITH CTE                                               
 AS (SELECT a.name AS accounts,SUM(total_amt_usd) AS  total_spent
	 FROM accounts a
	 JOIN orders o ON a.id=o.account_id
	 GROUP BY 1
	 ORDER BY 2 DESC)
     
SELECT a.name as  accounts,channel,COUNT(w.id) AS  web_events
FROM accounts a
JOIN web_events w ON a.id=w.account_id
WHERE a.name = (SELECT accounts
                   FROM CTE
                   LIMIT 1)
GROUP BY 1,2
ORDER BY 3 DESC
 ;
                                                

-- 7. What is the lifetime average amount spent in terms of total_amt_usd for the top 10 total spending accounts?

## Step-1. Find the top 10 total spending accounts with their spendings.
## step-2. Using it as a subquery ,find the average amount spent by all those accounts.

SELECT AVG(total_spent) AS avg_spent    
FROM (SELECT a.name AS  accounts,SUM(total_amt_usd) AS  total_spent    
		FROM accounts a
		JOIN orders o ON a.id=o.account_id
		GROUP BY 1
		ORDER BY 2 DESC
		LIMIT 10) temp
;


                                                #### Using CTE ####

WITH CTE
AS (SELECT a.name AS  accounts,SUM(total_amt_usd) AS total_spent                                               
		FROM accounts a
		JOIN orders o ON a.id=o.account_id                          
		GROUP BY 1
		ORDER BY 2 DESC
		LIMIT 10 )
        
SELECT AVG(total_spent) AS  avg_spent
FROM CTE
 ;                                               
                                                


-- 8. What is the lifetime average amount spent in terms of total_amt_usd, including only the companies that spent more per order, on average, than the average of all orders.

## step-1. Find the average total_amt_usd group by company.
## step-2. Find the average total_amt_usd for all orders.
## step-3. Using the the value from step-2 as a sub-query, find the companies that spent more on average than the total average.
## step-4. Find the average for those companies by using table from step-3 as a sub-query

SELECT AVG(avg_spent) AS final_avg
FROM (SELECT a.name AS  accounts,AVG(total_amt_usd) AS avg_spent
		FROM accounts a
		JOIN orders o ON a.id=o.account_id
		GROUP BY 1
		HAVING avg_spent> (SELECT AVG(total_amt_usd) AS avg_spent
							FROM orders)
                            ) temp
;




                                                #### Using CTE ####

WITH CTE                                                
AS (SELECT a.name AS accounts, AVG(total_amt_usd) AS avg_spent
		FROM accounts a
		JOIN orders o ON a.id=o.account_id  
		GROUP BY 1)

SELECT AVG(avg_spent) AS  final_avg
FROM CTE
WHERE avg_spent> (SELECT AVG(total_amt_usd) AS total_avg_spent
					FROM orders)
					    
;     
  
											












