# Entity Relationship Diagram
![alt text](https://github.com/Mahmud-Buet15/60-days-of-SQL/blob/main/Problem_set_12/dataset/schema.png)


# Part D Solutions - SQL Data Cleaning

#### **Q1. In the accounts table, there is a column holding the website for each company. The last three digits specify what type of web address they are using. A list of extensions (and pricing) is provided here. Pull these extensions and provide how many of each website type exist in the accounts table.**
```sql
SELECT RIGHT(website,3) AS website_type,COUNT(*) AS numbers
FROM accounts
GROUP BY 1
;
```

#### **Q2. There is much debate about how much the name (or even the first letter of a company name) matters. Use the accounts table to pull the first letter of each company name to see the distribution of company names that begin with each letter (or number).**

```sql
SELECT LEFT(name,1) AS first_letter,COUNT(*) AS occurrences
FROM accounts
GROUP BY 1
ORDER BY 2 DESC
;
```

#### **Q3. Use the accounts table and a CASE statement to create two groups: one group of company names that start with a number and a second group of those company names that start with a letter. What proportion of company names start with a letter?**

```sql
## Use Regex

SELECT 
    CASE
        WHEN name REGEXP '^[0-9]' THEN 'number'
        ELSE 'letter'
    END AS starts_with,
    COUNT(*) AS occurrences
FROM
    accounts
GROUP BY 1
;

## method-2


WITH CTE
AS (SELECT 
		CASE
			WHEN name REGEXP '^[0-9]' THEN 1
			ELSE 0
		END AS numbers,
		CASE
			WHEN name REGEXP '^[a-z]' THEN 1
			ELSE 0
		END AS letters
	FROM
		accounts)

SELECT SUM(numbers) AS number,SUM(letters) AS  letter
FROM CTE
;
```

#### **Q4. Consider vowels as a, e, i, o, and u. What proportion of company names start with a vowel, and what percent start with anything else?**
```sql
SELECT 
        CASE 
          WHEN name REGEXP '^[aeiou]' THEN 'vowel'
          ELSE 'others'
		END AS starts_with,
        COUNT(*) AS occurrences
FROM accounts 
GROUP BY 1
;

## method-2

WITH CTE
AS (SELECT 
		CASE
			WHEN name REGEXP '^[aeiou]' THEN 1
			ELSE 0
		END AS vowels,
		CASE
			WHEN name REGEXP '^[^aeiou]' THEN 1
			ELSE 0
		END AS others
	FROM
		accounts)
        
SELECT SUM(vowels) AS vowels, SUM(others) AS others
FROM CTE
;
```

#### **Q5. Use the accounts table to create first and last name columns that hold the first and last names for the primary_poc.**
```sql
#step-1. Find the space position using POSITION() and length using LENGTH()
#step-2. Use LEFT() to extract first name and RIGHT()

SELECT 
    primary_poc,
    LEFT(primary_poc,
        POSITION(' ' IN primary_poc)-1) AS first_name,
    RIGHT(primary_poc,
        LENGTH(primary_poc) - POSITION(' ' IN primary_poc)) AS last_name
FROM
    accounts
;
```

#### **Q6. Now see if you can do the same thing for every rep name in the sales_reps table. Again provide first and last name columns.**

```sql
SELECT 
    name,
    LEFT(name,
        POSITION(' ' IN name)-1) AS first_name,
    RIGHT(name,
        LENGTH(name) - POSITION(' ' IN name)) AS last_name
FROM
    sales_reps
;
```


#### **Q7.  Each company in the accounts table wants to create an email address for each primary_poc. The email address should be the first name of the primary_poc . last name primary_poc @ company name .com.**

```sql
WITH CTE
AS (SELECT 
		name,
		LEFT(primary_poc,
			POSITION(' ' IN primary_poc)-1) AS first_name,
		RIGHT(primary_poc,
			LENGTH(primary_poc) - POSITION(' ' IN primary_poc)) AS last_name
	FROM
		accounts)
        
SELECT *,CONCAT(first_name,'.',last_name,'@',name,'.com') AS email
FROM CTE
;
```

#### **Q8.  You may have noticed that in the previous solution some of the company names include spaces, which will certainly not work in an email address. See if you can create an email address that will work by removing all of the spaces in the account name, but otherwise your solution should be just as in question 7.**

```sql
## use REPLACE() 

WITH CTE
AS (SELECT 
		REPLACE(name, ' ', '') AS accounts,
		LEFT(primary_poc,
			POSITION(' ' IN primary_poc) - 1) AS first_name,
		RIGHT(primary_poc,
			LENGTH(primary_poc) - POSITION(' ' IN primary_poc)) AS last_name
	FROM
		accounts)

SELECT *,CONCAT(first_name,'.',last_name,'@',accounts,'.com') AS  email
FROM CTE
;
```

#### **Q9. We would also like to create an initial password, which they will change after their first log in. The first password will be the first letter of the primary_poc's first name (lowercase), then the last letter of their first name (lowercase), the first letter of their last name (lowercase), the last letter of their last name (lowercase), the number of letters in their first name, the number of letters in their last name, and then the name of the company they are working with, all capitalized with no spaces.**

```sql
WITH CTE
AS (SELECT 
		REPLACE(name, ' ', '') AS accounts,
		LEFT(primary_poc,
			POSITION(' ' IN primary_poc) - 1) AS first_name,
		RIGHT(primary_poc,
			LENGTH(primary_poc) - POSITION(' ' IN primary_poc)) AS last_name
	FROM
		accounts)

SELECT 
CONCAT(first_name,'.',last_name,'@',accounts,'.com') AS email,
UPPER(CONCAT(LEFT(first_name,1),RIGHT(first_name,1),LEFT(last_name,1),RIGHT(last_name,1),LENGTH(first_name),LENGTH(last_name),accounts)) AS password
FROM CTE
;
```

#### **Q10. Write a query to show tha rows with NULL values. a. Use COALESCE to fill in the orders.account_id column with the accounts.id for the NULL value. b. Use COALESCE to fill in each of the 'qty' and 'usd' column with 0 .** 

```sql
SELECT a.id,a.name,a.website,a.lat,a.lon,a.primary_poc,a.sales_rep_id,
      COALESCE(o.account_id,a.id) AS account_id,
      o.occurred_at,
      COALESCE(o.standard_qty,0) AS standard_qty,
      COALESCE(o.gloss_qty,0) AS gloss_qty,
      COALESCE(o.poster_qty,0) AS poster_qty,
      COALESCE(o.total,0) AS total,
      COALESCE(o.standard_amt_usd,0) AS standard_amt_usd,
      COALESCE(o.gloss_amt_usd,0) AS gloss_amt_usd,
      COALESCE(o.poster_amt_usd,0) AS poster_amt_usd,
      COALESCE(o.total_amt_usd,0) AS total_amt_usd
      
FROM accounts a
LEFT JOIN orders o
ON a.id = o.account_id
WHERE o.total IS NULL
;
```

