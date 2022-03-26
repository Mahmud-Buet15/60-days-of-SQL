# Problem Set 15
# Case Study #4 - [Data Bank](https://8weeksqlchallenge.com/case-study-4/)
![text](https://github.com/Mahmud-Buet15/60-days-of-SQL/blob/main/Problem_set_15(%238_week_sql_challenge)/dataset/data_bank.png)

# Entity Relationship Diagram
![alt text](https://github.com/Mahmud-Buet15/60-days-of-SQL/blob/main/Problem_set_15(%238_week_sql_challenge)/dataset/er_diagram.png)

### Problems:
#### Part-01 . Customer Nodes Exploration
1. How many unique nodes are there on the Data Bank system?
2. What is the number of nodes per region?
3. How many customers are allocated to each region?
4. How many days on average are customers reallocated to a different node?
5. What is the median, 80th and 95th percentile for this same reallocation days metric for each region?


#### Part-02. Customer Transactions
1. What is the unique count and total amount for each transaction type?
2. What is the average total historical deposit counts and amounts for all customers?
3. For each month - how many Data Bank customers make more than 1 deposit and either 1 purchase or 1 withdrawal in a single month?
4. What is the closing balance for each customer at the end of the month?
5. What is the percentage of customers who increase their closing balance by more than 5%?

# Solutions
### RDBMS- PostgreSQL

### Part-01 . Data Analysis Questions
#### **Q1. How many unique nodes are there on the Data Bank system?**
```sql
select 
	count(distinct node_id) as total_unique_nodes
from data_bank.customer_nodes;
```
#### Solution
![alt_text](https://github.com/Mahmud-Buet15/60-days-of-SQL/blob/main/Problem_set_15(%238_week_sql_challenge)/solution/solution%20images/solution_01.png)

#### **Q2.What is the number of nodes per region?**
```sql
select 
	region_name,
	count(distinct node_id) as total_nodes
from data_bank.customer_nodes tbl1
inner join data_bank.regions tbl2 on tbl1.region_id =tbl2.region_id 
group by 1
;
;
```
#### Solution
![alt_text](https://github.com/Mahmud-Buet15/60-days-of-SQL/blob/main/Problem_set_15(%238_week_sql_challenge)/solution/solution%20images/solution_02.png)

#### **Q3. How many customers are allocated to each region?**
```sql
select 
	tbl3.region_name,
	count(distinct tbl2.customer_id) as total_customers
from data_bank.customer_transactions tbl1
inner join data_bank.customer_nodes tbl2 on tbl1.customer_id =tbl2.customer_id 
inner join data_bank.regions tbl3 on tbl2.region_id =tbl3.region_id 
group by 1
;
```
#### Solution
![alt_text](https://github.com/Mahmud-Buet15/60-days-of-SQL/blob/main/Problem_set_15(%238_week_sql_challenge)/solution/solution%20images/solution_03.png)

#### **Q4. How many days on average are customers reallocated to a different node?**
```sql
select 	
	floor(avg(reallocation_day_gap)) as avg_reallocation_day_gap
from 
(
select 
	*,
	end_date-start_date  as reallocation_day_gap
from data_bank.customer_nodes
) tbl1
where reallocation_day_gap<100
;
```
#### Solution
![alt_text](https://github.com/Mahmud-Buet15/60-days-of-SQL/blob/main/Problem_set_15(%238_week_sql_challenge)/solution/solution%20images/solution_04.png)

#### **Q5. What is the median, 80th and 95th percentile for this same reallocation days metric for each region?**
```sql
--creating a temp table 
create table data_bank.region_wise_reallocation_days as 
select 
	region_name,
	reallocation_day_gap,
	occurrence,
	sum(occurrence) over(order by reallocation_day_gap) as cumulative_occurrence,
--	occurrence/(sum(occurrence) over(order by reallocation_day_gap))
	sum(occurrence) over() as total_occurrence,
	(sum(occurrence) over(order by reallocation_day_gap))/(sum(occurrence) over()) as occurrence_pct
from 
(
select 
	tbl2.region_name,
	end_date-start_date  as reallocation_day_gap,
	count(1) as occurrence
from data_bank.customer_nodes tbl1
inner join data_bank.regions tbl2 on tbl1.region_id =tbl2.region_id 
where 1=1
	and end_date-start_date<100
group by 1,2
) tbl3
;
select * from data_bank.region_wise_reallocation_days;

--getting median ,80th percentile and 95th percentile

select 
	tbl2.*,
	tbl3."80th_percentile_reallocation_day_gap",
	tbl4."95th_percentile_reallocation_day_gap"
from 
	(
	select 
		region_name,
		reallocation_day_gap as median_reallocation_day_gap
	from 
		(
		select 
			region_name,
			reallocation_day_gap,
			occurrence_pct,
			min(occurrence_pct) over(partition by region_name) as min_val
		from data_bank.region_wise_reallocation_days
		where occurrence_pct>=0.5
		) tbl1
	where occurrence_pct=min_val
	) tbl2
inner join
	(
	select 
		region_name,
		reallocation_day_gap as "80th_percentile_reallocation_day_gap"
	from 
		(
		select 
			region_name,
			reallocation_day_gap,
			occurrence_pct,
			min(occurrence_pct) over(partition by region_name) as min_val
		from data_bank.region_wise_reallocation_days
		where occurrence_pct>=0.8
		) tbl1
	where occurrence_pct=min_val
	) tbl3 on tbl2.region_name=tbl3.region_name
inner join 
	(
	select 
		region_name,
		reallocation_day_gap as "95th_percentile_reallocation_day_gap"
	from 
		(
		select 
			region_name,
			reallocation_day_gap,
			occurrence_pct,
			min(occurrence_pct) over(partition by region_name) as min_val
		from data_bank.region_wise_reallocation_days
		where occurrence_pct>=0.95
		) tbl1
	where occurrence_pct=min_val
	) tbl4 on tbl3.region_name=tbl4.region_name
;
```
#### Solution
![alt_text](https://github.com/Mahmud-Buet15/60-days-of-SQL/blob/main/Problem_set_15(%238_week_sql_challenge)/solution/solution%20images/solution_05.png)


### Part-02. Customer Transactions
#### **Q1. What is the unique count and total amount for each transaction type?**

```sql
select 
	txn_type ,
	count(distinct customer_id) as unique_customer,
	sum(txn_amount) as total_amount
from data_bank.customer_transactions
group by 1;  
```
#### Solution
![alt_text](https://github.com/Mahmud-Buet15/60-days-of-SQL/blob/main/Problem_set_15(%238_week_sql_challenge)/solution/solution%20images/solution_06.png)

#### **Q2. What is the average total historical deposit counts and amounts for all customers?**
```sql
select 
	floor(avg(historical_diposit_count)) as avg_historical_diposit_count,
	round(avg(diposit_amout),0) as avg_diposit_amount
from 
(
select 
	customer_id,
	count(txn_date) as historical_diposit_count,
	sum(txn_amount) as diposit_amout 
from data_bank.customer_transactions
where txn_type ='deposit'
group by 1
) tbl1;
```
#### Solution
![alt_text](https://github.com/Mahmud-Buet15/60-days-of-SQL/blob/main/Problem_set_15(%238_week_sql_challenge)/solution/solution%20images/solution_07.png)

#### **Q3. For each month - how many Data Bank customers make more than 1 deposit and either 1 purchase or 1 withdrawal in a single month?**
```sql

select 
	txn_month,
	count(customer_id) as total_customers
from 
	(
	select 
		date_trunc('month', txn_date )::date as txn_month,
		customer_id ,
		count(case when txn_type='deposit' then 1 end) as total_number_of_diposit,
		count(case when txn_type='purchase' then 1 end) as total_number_of_purchase,
		count(case when txn_type='withdrawal' then 1 end) as total_number_of_withdrawal
	from data_bank.customer_transactions
	group by 1,2
	) tbl1
where 1=1
and total_number_of_diposit>1 
and (total_number_of_purchase>=1 or total_number_of_withdrawal>=1)
group by 1
order by 1
;
```
#### Solution
![alt_text](https://github.com/Mahmud-Buet15/60-days-of-SQL/blob/main/Problem_set_15(%238_week_sql_challenge)/solution/solution%20images/solution_08.png)

#### **Q4. What is the closing balance for each customer at the end of the month?**
```sql
drop table if exists data_bank.month_end_balance_temp;
create table data_bank.month_end_balance_temp as 
select 
	customer_id,
	year_month,
	total_diposit_till_last_day-total_expense_till_last_day as closing_balance
from 
	(
	select 
		customer_id ,
		date_trunc('month', txn_date)::date as year_month,
		max(cumulative_deposit) as total_diposit_till_last_day,
		max(cumulative_purchase_or_withdrawal) as total_expense_till_last_day
	from 
		(
		select
			customer_id ,
			txn_date ,
			coalesce(sum( case when txn_type='deposit' then txn_amount end) over(partition by customer_id order by txn_date),0) as cumulative_deposit,
			coalesce(sum(case when txn_type in ('purchase','withdrawal') then txn_amount end) over(partition by customer_id order by txn_date),0) as cumulative_purchase_or_withdrawal
		from data_bank.customer_transactions
		where 1=1
		--	and customer_id =1
		) tbl1
	group by 1,2
) tbl2
order by 1,2
;

select * from data_bank.month_end_balance_temp;


create table data_bank.month_end_balance as 
select 
	tbl2.customer_id,
	tbl2.year_month,
	coalesce(tbl3.closing_balance,lag(closing_balance) over(partition by tbl2.customer_id order by tbl2.year_month)) as closing_balance
from 
(
select 
	*,
	generate_series(first_month,last_month,'1 Month')::date as year_month 
from
	(
	select 
		customer_id,
		min(year_month) as first_month ,
		max(year_month) as last_month
	from data_bank.month_end_balance_temp
	group by 1
	) tbl1
) tbl2
left join 
data_bank.month_end_balance_temp tbl3 on tbl2.customer_id=tbl3.customer_id and tbl2.year_month=tbl3.year_month
;

select * from data_bank.month_end_balance;
```
#### Solution
![alt_text](https://github.com/Mahmud-Buet15/60-days-of-SQL/blob/main/Problem_set_15(%238_week_sql_challenge)/solution/solution%20images/solution_09.png)

#### **Q5. What is the percentage of customers who increase their closing balance by more than 5%?**
```sql
--let's consider first month and last month's closing balance for analysis. Need to find the percentage of users who increased their last months closing balance 
-- by 5% with respect to first month's closing balance

select 
	count(distinct customer_id)/(select count(distinct customer_id) from data_bank.customer_transactions)::numeric*100 as pct_of_total
from 
(
select 
	tbl3.customer_id,
	tbl3.year_month as first_month ,
	initial_closing_balance,
	tbl4.year_month as last_month,
	final_closing_balance,
	(final_closing_balance-initial_closing_balance)/initial_closing_balance*100 as pct_increase
from 
	(--getting initial closing balance (first month's closing balance)
		select 
			customer_id,
			year_month,
			closing_balance as initial_closing_balance
		from 
		(
		select 
			*,
			min(seq) over(partition by customer_id)  as min_month,
			max(seq) over(partition by customer_id) as max_month
		from 
			(
			select 
				*,
				row_number() over(partition by customer_id order by year_month) as seq
			from data_bank.month_end_balance 
			) tbl1
		) tbl2
		where seq=min_month
	) tbl3
inner join 
	(--getting final closing balance (last month's closing balance)
	select 
		customer_id,
		year_month,
		closing_balance as final_closing_balance
	from 
	(
	select 
		*,
		min(seq) over(partition by customer_id)  as min_month,
		max(seq) over(partition by customer_id) as max_month
	from 
		(
		select 
			*,
			row_number() over(partition by customer_id order by year_month) as seq
		from data_bank.month_end_balance 
		) tbl1
	) tbl2
	where seq=max_month
	) tbl4 on tbl3.customer_id=tbl4.customer_id
where final_closing_balance>0
) tbl5
where pct_increase>5
;
```
#### Solution
![alt_text](https://github.com/Mahmud-Buet15/60-days-of-SQL/blob/main/Problem_set_15(%238_week_sql_challenge)/solution/solution%20images/solution_10.png)
