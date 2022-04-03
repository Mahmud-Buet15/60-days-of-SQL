# Problem Set 16
# Case Study #5 - [Data Mart](https://8weeksqlchallenge.com/case-study-5/)
![text](https://github.com/Mahmud-Buet15/60-days-of-SQL/blob/main/Problem_set_16(%238_week_sql_challenge/dataset/data_mart_cover.png )

# Entity Relationship Diagram
![alt text](https://github.com/Mahmud-Buet15/60-days-of-SQL/blob/main/Problem_set_16(%238_week_sql_challenge/dataset/data_mart_er_diagram.png )

### Problems:
#### Part-01. Data Cleansing Steps
In a single query, perform the following operations and generate a new table in the data_mart schema named clean_weekly_sales:

1. Convert the week_date to a DATE format
2. Add a week_number as the second column for each week_date value, for example any value from the 1st of January to
	7th of January will be 1, 8th to 14th will be 2 etc
3. Add a month_number with the calendar month for each week_date value as the 3rd column
4. Add a calendar_year column as the 4th column containing either 2018, 2019 or 2020 values
5. Add a new column called age_band after the original segment column using the following mapping on the number inside the segment value

|segment    |age_band     |
|-----------|-------------|
|1          |Young Adults |
|2          |Middle Aged  |
|3 or 4     |Retirees	  |


6. Add a new demographic column using the following mapping for the first letter in the segment values:

|segment    |demographic  |
|-----------|-------------|
|1          |YCouples 	  |
|2          |Families     |

7. Ensure all null string values with an "unknown" string value in the original segment column as well as the new age_band and demographic columns
8. Generate a new avg_transaction column as the sales value divided by transactions rounded to 2 decimal places for each record



#### Part-02. Data Exploration
1. What day of the week is used for each week_date value?
2. What range of week numbers are missing from the dataset?
3. How many total transactions were there for each year in the dataset?
4. What is the total sales for each region for each month?
5. What is the total count of transactions for each platform
6. What is the percentage of sales for Retail vs Shopify for each month?
7. What is the percentage of sales by demographic for each year in the dataset?
8. Which age_band and demographic values contribute the most to Retail sales?
9. Can we use the avg_transaction column to find the average transaction size for each year for Retail vs Shopify? 
	If not - how would you calculate it instead?


#### Part-03. Before & After Analysis
This technique is usually used when we inspect an important event and want to inspect the impact before and after a certain point in time.

Taking the week_date value of 2020-06-15 as the baseline week where the Data Mart sustainable packaging changes came into effect.

We would include all week_date values for 2020-06-15 as the start of the period after the change and the previous week_date values would be before

Using this analysis approach - answer the following questions:

1. What is the total sales for the 4 weeks before and after 2020-06-15? What is the growth or reduction rate in actual values and percentage of sales?
2. What about the entire 12 weeks before and after?
3. How do the sale metrics for these 2 periods before and after compare with the previous years in 2018 and 2019?

<br>


# Solutions
### RDBMS- PostgreSQL

### Part-01 . Data Cleansing Steps
In a single query, perform the following operations and generate a new table in the data_mart schema named clean_weekly_sales:

1. Convert the week_date to a DATE format
2. Add a week_number as the second column for each week_date value, for example any value from the 1st of January to
	7th of January will be 1, 8th to 14th will be 2 etc
3. Add a month_number with the calendar month for each week_date value as the 3rd column
4. Add a calendar_year column as the 4th column containing either 2018, 2019 or 2020 values
5. Add a new column called age_band after the original segment column using the following mapping on the number inside the segment value

|segment    |age_band     |
|-----------|-------------|
|1          |Young Adults |
|2          |Middle Aged  |
|3 or 4     |Retirees	  |


6. Add a new demographic column using the following mapping for the first letter in the segment values:

|segment    |demographic  |
|-----------|-------------|
|1          |YCouples 	  |
|2          |Families     |

7. Ensure all null string values with an "unknown" string value in the original segment column as well as the new age_band and demographic columns
8. Generate a new avg_transaction column as the sales value divided by transactions rounded to 2 decimal places for each record


```sql

create table data_mart.clean_weekly_sales as 
select 
	week_date,
	date_part('week',week_date) as week_number,
	date_part('month',week_date) as month_number,
	date_part('year',week_date) as calender_year, 
	region,
	platform,
	segment,
	case 
		when segment ilike '%1' then 'Yound Adults' 
		when segment ilike '%2' then 'Middle Aged'
		when segment ilike '%3' or segment ilike '%4' then 'Retirees'
		else 'unknown'
	end as age_band,
	case 
		when segment ilike 'c%' then 'Couples' 
		when segment ilike 'f%' then 'Families'
		else 'unknown'
	end as demographic,
	customer_type,
	transactions,
	sales,
	round(sales/transactions::numeric,2) as  avg_transaction
from 
	(
	select 
		('20'||split_part(week_date,'/',3)||'-'||split_part(week_date,'/',2)||'-'||split_part(week_date,'/',1))::date as week_date,
		region,
		platform,
		case when segment='null' then 'unknown' else segment end as segment,
		customer_type,
		transactions,
		sales
	from data_mart.weekly_sales
	) tbl1
;
```
#### Solution
![alt_text](https://github.com/Mahmud-Buet15/60-days-of-SQL/blob/main/Problem_set_15(%238_week_sql_challenge/solution/solution%20images/solution_01.png )


### Part-02. Data Exploration
#### **Q1. What day of the week is used for each week_date value?**

```sql
select 
	day_of_week,
	count(1) as occurrence
from
(
select 
	week_date,
	to_char(week_date,'Day') as day_of_week
from data_mart.clean_weekly_sales
) tbl1
group by 1; 
```
#### Solution
![alt_text](https://github.com/Mahmud-Buet15/60-days-of-SQL/blob/main/Problem_set_15(%238_week_sql_challenge/solution/solution%20images/solution_06.png )

It seems Monday is being used for each week_day value

#### **Q2. What range of week numbers are missing from the dataset?**
```sql
select 
	distinct week_number
from data_mart.clean_weekly_sales
group by 1
order by 1;
```
#### Solution
![alt_text](https://github.com/Mahmud-Buet15/60-days-of-SQL/blob/main/Problem_set_15(%238_week_sql_challenge/solution/solution%20images/solution_07.png )

Looks like week number 1-12 and 37-52 are missing

#### **Q3. How many total transactions were there for each year in the dataset?**
```sql

select 
	date_part('year', week_date)::varchar as "Year",
	sum(transactions)/100000 as "Total Transaction (Million)"
from data_mart.clean_weekly_sales
group by 1
order by 1;
```
#### Solution
![alt_text](https://github.com/Mahmud-Buet15/60-days-of-SQL/blob/main/Problem_set_15(%238_week_sql_challenge/solution/solution%20images/solution_08.png )

#### **Q4. What is the total sales for each region for each month?**
```sql
select 
	date_part('year', week_date)::varchar as "Year",
	sum(sales)/100000000 as "Total Transaction (Billion)"
from data_mart.clean_weekly_sales
group by 1
order by 1;
```
#### Solution
![alt_text](https://github.com/Mahmud-Buet15/60-days-of-SQL/blob/main/Problem_set_15(%238_week_sql_challenge/solution/solution%20images/solution_09.png )

#### **Q5. What is the total count of transactions for each platform?**
```sql
select 
	platform as "Platform",
	count(1) as "Total Transaction Count"
from data_mart.clean_weekly_sales
group by 1
;
```
#### Solution
![alt_text](https://github.com/Mahmud-Buet15/60-days-of-SQL/blob/main/Problem_set_15(%238_week_sql_challenge/solution/solution%20images/solution_10.png )


#### **Q6. What is the percentage of sales for Retail vs Shopify for each month?**
```sql
select 
	month_name as "Month",
	round(retail_sale/total_sales::numeric*100 ,2) as "Retail Sale (%)",
	round(shopify_sale/total_sales::numeric*100 ,2) as "Shopify Sale (%)"
from 
	(
	select 
		date_trunc('month', week_date)::date as months,
		to_char(date_trunc('month', week_date),'Mon-yyyy') as month_name,
		sum(case when platform='Retail' then sales end) as retail_sale,
		sum(case when platform='Shopify' then sales end) as shopify_sale,
		sum(sales) as total_sales
	from data_mart.clean_weekly_sales
	group by 1,2
	order by 1
	) tbl1
;
```
#### Solution
![alt_text](https://github.com/Mahmud-Buet15/60-days-of-SQL/blob/main/Problem_set_15(%238_week_sql_challenge/solution/solution%20images/solution_10.png )


#### **Q7. What is the percentage of sales by demographic for each year in the dataset?**
```sql
select 
	"Year",
	round(sale_couples/total_sales::numeric*100 ,2) as "Couples Sale (%)",
	round(sale_families/total_sales::numeric*100 ,2) as "Families Sale (%)",
	round(sale_unknown/total_sales::numeric*100 ,2) as "Unknown Sale (%)"
from 
(
select 
	date_part('year', week_date)::varchar as "Year",
	sum(case when demographic='Couples' then sales end) as sale_couples,
	sum(case when demographic='Families' then sales end) as sale_families,
	sum(case when demographic='unknown' then sales end) as sale_unknown,
	sum(sales) as total_sales
from data_mart.clean_weekly_sales
group by 1
order by 1
) tbl1
;
```
#### Solution
![alt_text](https://github.com/Mahmud-Buet15/60-days-of-SQL/blob/main/Problem_set_15(%238_week_sql_challenge/solution/solution%20images/solution_10.png )

#### **Q8. Which age_band and demographic values contribute the most to Retail sales?**
**Solution for age_band**
```sql
select 
	age_band,
	sum(sales) as total_sales
from data_mart.clean_weekly_sales
where 1=1
and platform='Retail'
and age_band !='unknown'
group by 1
order by 2 desc
;
```
#### Solution
![alt_text](https://github.com/Mahmud-Buet15/60-days-of-SQL/blob/main/Problem_set_15(%238_week_sql_challenge/solution/solution%20images/solution_10.png )

Retirees contribute most From age_band . 

**Solution for demographic**
```sql
select 
	demographic,
	sum(sales) as total_sales
from data_mart.clean_weekly_sales
where 1=1
and platform='Retail'
and demographic !='unknown'
group by 1
order by 2 desc
;
```
#### Solution
![alt_text](https://github.com/Mahmud-Buet15/60-days-of-SQL/blob/main/Problem_set_15(%238_week_sql_challenge/solution/solution%20images/solution_10.png )

Families contribute most From demographic

#### **Q6. Can we use the avg_transaction column to find the average transaction size for each year for Retail vs Shopify? If not - how would you calculate it instead?**
No we cannot use the avg_transaction column to find the average transaction size

```sql
select 
	date_part('year', week_date)::varchar as "Year",
	round(sum(case when platform='Retail' then  sales end)/sum(case when platform='Retail' then  transactions end)::numeric,2) as "Avg. transaction size for Retail",
	round(sum(case when platform='Shopify' then  sales end)/sum(case when platform='Shopify' then  transactions end)::numeric,2) as "Avg. transaction size for Shopify"
from data_mart.clean_weekly_sales
group by 1
order by 1
;
```
#### Solution
![alt_text](https://github.com/Mahmud-Buet15/60-days-of-SQL/blob/main/Problem_set_15(%238_week_sql_challenge/solution/solution%20images/solution_10.png )



