USE Parch_and_posey;

-- ################################# PART A - JOINS ###############################

-- 1. Provide a table for all web_events associated with account name of Walmart. 
-- There should be three columns. Be sure to include the primary_poc, time of the event, and the channel for each event. 
-- Additionally, you might choose to add a fourth column to assure only Walmart events were chosen.

SELECT  a.name,primary_poc,occurred_at,channel
FROM accounts a
JOIN web_events w ON a.id=w.account_id
WHERE name="Walmart"
;

-- 2. Provide a table that provides the region for each sales_rep along with their associated accounts. 
-- Your final table should include three columns: the region name, the sales rep name, and the account name. 
-- Sort the accounts alphabetically (A-Z) according to account name.

SELECT r.name AS region_name,s.name AS sales_rep_name,a.name AS account_name
FROM accounts a
JOIN sales_reps s ON a.sales_rep_id=s.id
JOIN region r ON r.id=s.region_id
ORDER BY account_name
;


-- 3. Provide the name for each region for every order, as well as the account name and the unit price they paid (total_amt_usd/total) for the order. 
-- Your final table should have 3 columns: region name, account name, and unit price.
--  A few accounts have 0 for total, so I divided by (total + 0.01) to assure not dividing by zero.

SELECT r.name AS region_name,a.name AS account_name,(o.total_amt_usd/(o.total+0.01)) AS unit_price
FROM region r
JOIN sales_reps s ON r.id=s.region_id
JOIN accounts a ON s.id=a.sales_rep_id
JOIN orders o ON a.id=o.account_id
;


-- 4. Provide a table that provides the region for each sales_rep along with their associated accounts. This time only for the Midwest region. 
-- Your final table should include three columns: the region name, the sales rep name, and the account name. Sort the accounts alphabetically (A-Z) according to account name.

SELECT r.name AS  region_name,s.name AS sales_rep_name,a.name AS account_name
FROM sales_reps s 
LEFT JOIN accounts a ON s.id=a.sales_rep_id
LEFT JOIN region r ON s.region_id=r.id
WHERE r.name='Midwest'
ORDER BY account_name
;


-- 5. Provide a table that provides the region for each sales_rep along with their associated accounts. This time only for accounts where the sales rep has a first name starting with S and in the Midwest region.
-- Your final table should include three columns: the region name, the sales rep name, and the account name. Sort the accounts alphabetically (A-Z) according to account name.

SELECT r.name AS  region_name,s.name AS sales_rep_name,a.name AS account_name
FROM sales_reps s 
LEFT JOIN accounts a ON s.id=a.sales_rep_id
LEFT JOIN region r ON s.region_id=r.id
WHERE r.name='Midwest' AND s.name LIKE 'S%'  -- pattern: S+some_letters
ORDER BY account_name
;


-- 6. Provide a table that provides the region for each sales_rep along with their associated accounts. This time only for accounts where the sales rep has a last name starting with K and in the Midwest region. 
-- Your final table should include three columns: the region name, the sales rep name, and the account name. Sort the accounts alphabetically (A-Z) according to account name.

SELECT r.name AS  region_name,s.name AS sales_rep_name,a.name AS account_name
FROM sales_reps s 
LEFT JOIN accounts a ON s.id=a.sales_rep_id
LEFT JOIN region r ON s.region_id=r.id
WHERE r.name='Midwest' AND s.name LIKE '% K%'    -- pattern: some_letters+space+K+some_letters
ORDER BY account_name
;


-- 7. Provide the name for each region for every order, as well as the account name and the unit price they paid (total_amt_usd/total) for the order. 
-- However, you should only provide the results if the standard order quantity exceeds 100. Your final table should have 3 columns: region name, account name, and unit price. 
-- In order to avoid a division by zero error, adding .01 to the denominator here is helpful total_amt_usd/(total+0.01).


SELECT r.name AS region_name,a.name AS account_name,(o.total_amt_usd/(o.total+0.01)) AS unit_price
FROM region r
JOIN sales_reps s ON r.id=s.region_id
JOIN accounts a ON s.id=a.sales_rep_id
JOIN orders o ON a.id=o.account_id
WHERE standard_qty>100
;


-- 8. Provide the name for each region for every order, as well as the account name and the unit price they paid (total_amt_usd/total) for the order. 
-- However, you should only provide the results if the standard order quantity exceeds 100 and the poster order quantity exceeds 50. Your final table should have 3 columns: region name, account name, and unit price. 
-- Sort for the smallest unit price first. In order to avoid a division by zero error, adding .01 to the denominator here is helpful (total_amt_usd/(total+0.01).

SELECT r.name AS region_name,a.name AS account_name,(o.total_amt_usd/(o.total+0.01)) AS unit_price
FROM region r
JOIN sales_reps s ON r.id=s.region_id
JOIN accounts a ON s.id=a.sales_rep_id
JOIN orders o ON a.id=o.account_id
WHERE standard_qty>100 AND poster_qty>50
ORDER BY unit_price
;

-- 9. Provide the name for each region for every order, as well as the account name and the unit price they paid (total_amt_usd/total) for the order. 
-- However, you should only provide the results if the standard order quantity exceeds 100 and the poster order quantity exceeds 50. Your final table should have 3 columns: region name, account name, and unit price. 
-- Sort for the largest unit price first. In order to avoid a division by zero error, adding .01 to the denominator here is helpful (total_amt_usd/(total+0.01).

SELECT r.name AS region_name,a.name AS account_name,(o.total_amt_usd/(o.total+0.01)) AS unit_price
FROM region r
JOIN sales_reps s ON r.id=s.region_id
JOIN accounts a ON s.id=a.sales_rep_id
JOIN orders o ON a.id=o.account_id
WHERE standard_qty>100 AND poster_qty>50
ORDER BY unit_price DESC
;

-- 10. What are the different channels used by account id 1001? Your final table should have only 2 columns: account name and the different channels. 
-- You can try SELECT DISTINCT to narrow down the results to only the unique values.

SELECT DISTINCT a.name AS  account_name, w.channel
FROM web_events w
JOIN accounts a ON w.account_id=a.id
WHERE a.id=1001
;


-- 11. Find all the orders that occurred in 2015. Your final table should have 4 columns: occurred_at, account name, order total, and order total_amt_usd.

SELECT o.occurred_at, a.name AS  account_name, o.total AS order_total, o.total_amt_usd AS order_total_amt_usd
FROM accounts a
JOIN orders o ON a.id=o.account_id
WHERE YEAR(o.occurred_at)=2015
;


