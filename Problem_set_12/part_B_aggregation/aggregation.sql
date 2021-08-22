USE Parch_and_posey;

-- ################################# PART B - Aggregation ###############################

-- 1. Which account (by name) placed the earliest order? Your solution should have the account name and the date of the order.

SELECT 
    a.name AS account_name, occurred_at
FROM
    accounts a
        JOIN
    orders o ON a.id = o.account_id
ORDER BY occurred_at
LIMIT 1
;

-- 2. Find the total sales in usd for each account. You should include two columns - the total sales for each company's orders in usd and the company name.

SELECT 
    a.name AS company_name, SUM(total_amt_usd) AS total_sales
FROM
    accounts a
        JOIN
    orders o ON a.id = o.account_id
GROUP BY company_name
ORDER BY total_sales DESC
;

-- 3. Via what channel did the most recent (latest) web_event occur, which account was associated with this web_event? Your query should return only three values - the date, channel, and account name.

SELECT 
    occurred_at, channel, a.name AS account_name
FROM
    web_events w
        JOIN
    accounts a ON w.account_id = a.id
ORDER BY occurred_at DESC
LIMIT 1
;

-- 4. Find the total number of times each type of channel from the web_events was used. Your final table should have two columns - the channel and the number of times the channel was used.

SELECT 
    channel, COUNT(id) AS number_of_time_used
FROM
    web_events
GROUP BY channel
;

-- 5. Who was the primary contact associated with the earliest web_event?

SELECT 
    primary_poc
FROM
    web_events w
        JOIN
    accounts a ON w.account_id = a.id
ORDER BY occurred_at
LIMIT 1
;


-- 6. What was the smallest order placed by each account in terms of total usd. Provide only two columns - the account name and the total usd. Order from smallest dollar amounts to largest.

SELECT 
    a.name AS account_name, MIN(total_amt_usd) AS smallest_order
FROM
    accounts a
        JOIN
    orders o ON a.id = o.account_id
GROUP BY account_name
ORDER BY smallest_order
;

-- 7. Find the number of sales reps in each region. Your final table should have two columns - the region and the number of sales_reps. Order from fewest reps to most reps.

SELECT 
    r.name AS region, COUNT(s.id) AS number_of_sales_reps
FROM
    region r
        JOIN
    sales_reps s ON r.id = s.region_id
GROUP BY region
ORDER BY number_of_sales_reps
;


-- 8. For each account, determine the average amount of each type of paper they purchased across their orders.
--  Your result should have four columns - one for the account name and one for the average quantity purchased for each of the paper types for each account.

SELECT 
    a.name AS account_name,
    AVG(standard_qty) AS avg_standard_qty,
    AVG(gloss_qty) AS avg_gloss_qty,
    AVG(poster_qty) AS poster_qty
FROM
    accounts a
        JOIN
    orders o ON a.id = o.account_id
GROUP BY account_name
ORDER BY account_name
;


-- 9. For each account, determine the average amount spent per order on each paper type. 
-- Your result should have four columns - one for the account name and one for the average amount spent on each paper type.

SELECT 
    a.name AS account_name,
    AVG(standard_amt_usd) AS avg_standard_spent,
    AVG(gloss_amt_usd) AS avg_gloss_spent,
    AVG(poster_amt_usd) AS poster_spent
FROM
    accounts a
        JOIN
    orders o ON a.id = o.account_id
GROUP BY account_name
ORDER BY account_name
;

-- 10. Determine the number of times a particular channel was used in the web_events table for each sales rep.
-- Your final table should have three columns - the name of the sales rep, the channel, and the number of occurrences. Order your table with the highest number of occurrences first.

SELECT 
    s.name AS sales_rep,
    channel,
    COUNT(channel) AS number_of_occurences
FROM
    web_events w
        JOIN
    accounts a ON w.account_id = a.id
        JOIN
    sales_reps s ON s.id = a.sales_rep_id
GROUP BY sales_rep , channel
ORDER BY number_of_occurences DESC
;



-- 11. Determine the number of times a particular channel was used in the web_events table for each region.
-- Your final table should have three columns - the region name, the channel, and the number of occurrences. Order your table with the highest number of occurrences first.

SELECT 
    r.name AS region,
    channel,
    COUNT(channel) AS number_of_occurences
FROM
    web_events w
        JOIN
    accounts a ON w.account_id = a.id
        JOIN
    sales_reps s ON s.id = a.sales_rep_id
        JOIN
    region r ON r.id = s.region_id
GROUP BY region , channel
ORDER BY number_of_occurences DESC
;

-- 12. How many of the sales reps have more than 5 accounts that they manage?

SELECT 
    COUNT(id) AS number_of_sales_reps
FROM
    (SELECT 
        s.id, COUNT(a.id) AS number_of_accounts
    FROM
        accounts a
    JOIN sales_reps s ON a.sales_rep_id = s.id
    GROUP BY s.id
    HAVING COUNT(a.id) > 5) AS temp
;

-- 13. How many accounts have more than 20 orders?

SELECT 
    COUNT(id) AS number_of_accounts
FROM
    (SELECT 
        a.id, COUNT(o.id) AS orders
    FROM
        accounts a
    JOIN orders o ON a.id = o.account_id
    GROUP BY a.id
    HAVING orders > 20) AS temp
;

-- 14. Which account has the most orders?
SELECT 
    a.name, COUNT(o.id) AS orders
FROM
    accounts a
        JOIN
    orders o ON a.id = o.account_id
GROUP BY a.name
ORDER BY orders DESC
LIMIT 1
;


-- 15. Which accounts spent more than 30,000 usd total across all orders?

SELECT 
    a.name AS accounts, SUM(total_amt_usd) AS total_spent
FROM
    accounts a
        JOIN
    orders o ON a.id = o.account_id
GROUP BY accounts
HAVING total_spent > 30000
;

-- 16. Which accounts spent less than 1,000 usd total across all orders?

SELECT 
    a.name AS accounts, SUM(total_amt_usd) AS total_spent
FROM
    accounts a
        JOIN
    orders o ON a.id = o.account_id
GROUP BY accounts
HAVING total_spent < 1000
;

-- 17. Which account has spent the most with us?

SELECT 
    a.name AS accounts, SUM(total_amt_usd) AS total_spent
FROM
    accounts a
        JOIN
    orders o ON a.id = o.account_id
GROUP BY accounts
ORDER BY total_spent DESC
LIMIT 1
;


-- 18. Which account has spent the least with us?

SELECT 
    a.name AS accounts, SUM(total_amt_usd) AS total_spent
FROM
    accounts a
        JOIN
    orders o ON a.id = o.account_id
GROUP BY accounts
ORDER BY total_spent
LIMIT 1
;

-- 19. Which accounts used facebook as a channel to contact customers more than 6 times?

SELECT 
    a.name AS accounts, COUNT(channel) AS number_of_fb_contact
FROM
    accounts a
        JOIN
    web_events w ON w.account_id = a.id
WHERE
    channel = 'facebook'
GROUP BY accounts
HAVING number_of_fb_contact > 6
ORDER BY number_of_fb_contact DESC
;

-- 20. Which account used facebook most as a channel?

SELECT 
    a.name AS accounts, COUNT(channel) AS number_of_fb_contact
FROM
    accounts a
        JOIN
    web_events w ON w.account_id = a.id
WHERE
    channel = 'facebook'
GROUP BY accounts
ORDER BY number_of_fb_contact DESC
LIMIT 1
;

-- 21. Which channel was most frequently used by most accounts?

SELECT 
    a.name AS accounts,
    channel,
    COUNT(channel) AS frequency_of_usage
FROM
    accounts a
        JOIN
    web_events w ON w.account_id = a.id
GROUP BY accounts , channel
ORDER BY frequency_of_usage DESC
LIMIT 10
;

-- 22. Find the sales in terms of total dollars for all orders in each year, ordered from greatest to least. Do you notice any trends in the yearly sales totals?


SELECT 
    YEAR(occurred_at) AS year, SUM(total_amt_usd) AS total_sales
FROM
    orders
WHERE
    occurred_at BETWEEN '2014-01-01' AND '2017-01-01'
GROUP BY year
ORDER BY total_sales DESC
;
-- ## Note: Total sales increased from 2014 to 2016 . There is only 2 day's data for 2017 and 1 month's data for 2013. So year 2013 and 2017 shouldn't be considered while analyzing yearly trend.

-- 23. Which month did Parch & Posey have the greatest sales in terms of total dollars? Are all months evenly represented by the dataset?

SELECT 
    MONTH(occurred_at) AS month,
    SUM(total_amt_usd) AS total_spent
FROM
    orders
WHERE
    occurred_at BETWEEN '2014-01-01' AND '2017-01-01'
GROUP BY month
ORDER BY total_spent DESC
LIMIT 1
;


-- 24. Which year did Parch & Posey have the greatest sales in terms of total number of orders? Are all years evenly represented by the dataset?

SELECT 
    YEAR(occurred_at) AS year,
    SUM(total) AS total_number_of_orders
FROM
    orders
GROUP BY year
ORDER BY total_number_of_orders DESC
LIMIT 1
;


-- 25. Which month did Parch & Posey have the greatest sales in terms of total number of orders? Are all months evenly represented by the dataset?

SELECT 
    MONTH(occurred_at) AS month,
    SUM(total) AS total_number_of_orders
FROM
    orders
WHERE
    occurred_at BETWEEN '2014-01-01' AND '2017-01-01'
GROUP BY month
ORDER BY total_number_of_orders DESC
LIMIT 1
;


-- 26. In which month of which year did Walmart spend the most on gloss paper in terms of dollars? 

SELECT 
    a.name AS account,
    YEAR(occurred_at) AS year,
    MONTH(occurred_at) AS month,
    SUM(gloss_amt_usd) AS spent_gloss_paper
FROM
    orders o
        JOIN
    accounts a ON a.id = o.account_id
WHERE
    a.name = 'Walmart'
GROUP BY 1 , 2 , 3
ORDER BY 4 DESC
LIMIT 1
;



-- ### CASE ###

-- 27. Write a query to display for each order, the account ID, total amount of the order, and the level of the order - ‘Large’ or ’Small’ - 
-- depending on if the order is $3000 or more, or smaller than $3000.

SELECT 
    o.id AS orders,
    a.id AS accounts,
    total_amt_usd,
    CASE
        WHEN total_amt_usd > 3000 THEN 'Large'
        ELSE 'Small'
    END AS level_of_order
FROM
    accounts a
        JOIN
    orders o ON a.id = o.account_id
;


-- 28. Write a query to display the number of orders in each of three categories, based on the total number of items in each order. The three categories are: 'At Least 2000', 
-- 'Between 1000 and 2000' and 'Less than 1000'.

SELECT 
    CASE
        WHEN total > 2000 THEN 'At Least 2000'
        WHEN total BETWEEN 1000 AND 2000 THEN 'Between 1000 and 2000'
        ELSE 'Less then 1000'
    END AS categories,
    COUNT(o.id) AS number_of_orders
FROM
    accounts a
        JOIN
    orders o ON a.id = o.account_id
GROUP BY categories
;


-- 29. We would like to understand 3 different levels of customers based on the amount associated with their purchases. 
-- The top level includes anyone with a Lifetime Value (total sales of all orders) greater than 200,000 usd.
-- The second level is between 200,000 and 100,000 usd. The lowest level is anyone under 100,000 usd. Provide a table that includes the level associated with each account. 
-- You should provide the account name, the total sales of all orders for the customer, and the level. Order with the top spending customers listed first.

SELECT 
    a.name AS accounts, 
    SUM(total_amt_usd) AS total_sales,
    CASE 
      WHEN SUM(total_amt_usd)>200000 THEN 'Top Level'
      WHEN SUM(total_amt_usd) BETWEEN 100000 AND 200000 THEN 'Second Level'
      ELSE 'Lowest Level'
	END AS levels
FROM
    accounts a
        JOIN
    orders o ON a.id = o.account_id
GROUP BY accounts
ORDER BY total_sales DESC
;

-- 30. We would now like to perform a similar calculation to the first, but we want to obtain the total amount spent by customers only in 2016 and 2017. 
-- Keep the same levels as in the previous question. Order with the top spending customers listed first.

SELECT 
    a.name AS accounts, 
    SUM(total_amt_usd) AS total_sales,
    CASE 
      WHEN SUM(total_amt_usd)>200000 THEN 'Top Level'
      WHEN SUM(total_amt_usd) BETWEEN 100000 AND 200000 THEN 'Second Level'
      ELSE 'Lowest Level'
	END AS levels
FROM
    accounts a
        JOIN
    orders o ON a.id = o.account_id
WHERE YEAR(occurred_at) BETWEEN 2016 AND 2017
GROUP BY accounts
ORDER BY total_sales DESC
;


-- 31. We would like to identify top performing sales reps, which are sales reps associated with more than 200 orders.
-- Create a table with the sales rep name, the total number of orders, and a column with top or not depending on if they have more than 200 orders.
-- Place the top sales people first in your final table.

SELECT 
    s.name AS sales_reps,COUNT(o.id) AS number_of_orders,
    CASE 
      WHEN COUNT(o.id)>200 THEN 'Yes'
      ELSE 'No'
	END AS 'top performing?'
FROM
    accounts a
        JOIN
    orders o ON a.id = o.account_id
        JOIN
    sales_reps s ON s.id = a.sales_rep_id
GROUP BY sales_reps
ORDER BY number_of_orders DESC
;



-- 32. The previous didn't account for the middle, nor the dollar amount associated with the sales. Management decides they want to see these characteristics represented as well.
-- We would like to identify top performing sales reps, which are sales reps associated with more than 200 orders or more than 750000 in total sales.
-- The middle group has any rep with more than 150 orders or 500000 in sales. Create a table with the sales rep name, the total number of orders, total sales across all orders,
-- and a column with top, middle, or low depending on this criteria. Place the top sales people based on dollar amount of sales first in your final table.
-- You might see a few upset sales people by this criteria!



SELECT 
    s.name AS sales_reps,
    COUNT(o.id) AS total_orders,
    SUM(total_amt_usd) AS  total_sales,
    CASE
        WHEN COUNT(o.id) > 200 OR SUM(total_amt_usd)>750000 THEN 'Top'
        WHEN COUNT(o.id) > 150 OR SUM(total_amt_usd)>500000 THEN 'Middle'
        ELSE 'Low'
    END AS performance
FROM
    accounts a
        JOIN
    orders o ON a.id = o.account_id
        JOIN
    sales_reps s ON s.id = a.sales_rep_id
GROUP BY sales_reps
ORDER BY total_sales DESC
;










