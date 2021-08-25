# Entity Relationship Diagram
![alt text](https://github.com/Mahmud-Buet15/60-days-of-SQL/blob/main/Problem_set_12/dataset/schema.png)


# Part E Solutions - SQL Window Functions

#### **Q1. Create a running total of standard_qty.**
```sql
SELECT standard_qty, 
SUM(standard_qty) OVER(ORDER BY occurred_at) AS running_total
FROM orders
;
```

#### **Q2. Create a running total of standard_qty by each month.**

```sql
SELECT standard_qty, 
DATE_FORMAT(occurred_at, '%y-%m-%01') AS month,
SUM(standard_qty) OVER(PARTITION BY DATE_FORMAT(occurred_at, '%y-%m-%01') ORDER BY occurred_at) AS running_total
FROM orders
;
```

#### **Q3. create a running total of standard_amt_usd (in the orders table) over order time with no date truncation. Your final table should have two columns: one with the amount being added for each new row, and a second with the running total.**

```sql
SELECT 
    standard_amt_usd,
    SUM(standard_amt_usd) OVER(ORDER BY occurred_at) AS  running_total
    
FROM
    orders
;
```

#### **Q4. Create a running total of standard_amt_usd (in the orders table) over order time, but this time, date truncate occurred_at by year and partition by that same year-truncated occurred_at variable. Your final table should have three columns: One with the amount being added for each row, one for the truncated date, and a final column with the running total within each year.**

```sql
SELECT DATE_FORMAT(occurred_at,'%y-%01-%01') AS year,
standard_amt_usd,
SUM(standard_amt_usd) OVER(PARTITION BY DATE_FORMAT(occurred_at,'%y-%01-%01') ORDER BY occurred_at) AS running_total
FROM orders
;
```

#### **Q5. Select the id, account_id, and total variable from the orders table, then create a column called total_rank that ranks this total amount of paper ordered (from highest to lowest) for each account using a partition. Your final table should have these four columns.**
```sql
SELECT id,account_id,total,
       RANK() OVER(PARTITION BY account_id ORDER BY total DESC) AS  total_rank
FROM orders
;
```

#### **Q6. Determine how the current order's total revenue ("total" meaning from sales of all types of paper) compares to the next order's total revenue.**

```sql
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
```


#### **Q7. Use the NTILE functionality to divide the accounts into 4 levels in terms of the amount of standard_qty for their orders. Your resulting table should have the account_id, the occurred_at time for each order, the total amount of standard_qty paper purchased, and one of four levels in a standard_quartile column.**

```sql
SELECT account_id,
       occurred_at,
       standard_qty,
       NTILE(4) OVER(PARTITION BY account_id ORDER BY standard_qty) AS quartile
FROM orders
ORDER BY account_id
;
```

#### **Q8. Use the NTILE functionality to divide the accounts into two levels in terms of the amount of gloss_qty for their orders. Your resulting table should have the account_id, the occurred_at time for each order, the total amount of gloss_qty paper purchased, and one of two levels in a gloss_half column.**

```sql
SELECT account_id,
	   occurred_at,
       gloss_qty,
       NTILE(2) OVER(PARTITION BY account_id ORDER BY gloss_qty) AS gloss_half
FROM orders
ORDER BY account_id
;
```

#### **Q9. Use the NTILE functionality to divide the orders for each account into 100 levels in terms of the amount of total_amt_usd for their orders. Your resulting table should have the account_id, the occurred_at time for each order, the total amount of total_amt_usd paper purchased, and one of 100 levels in a total_percentile column.**
```sql
SELECT account_id,
       occurred_at,
       total_amt_usd,
       NTILE(100) OVER(PARTITION BY account_id ORDER BY total_amt_usd) AS percentile
FROM orders
ORDER BY account_id DESC
;

-- Note: For percentile, if any account_id doesn't have 100 rows then rows will by divided by the number of rows it has. 
```
