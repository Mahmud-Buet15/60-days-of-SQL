# Problem Set 14 
# Case Study #3 - [Foodie-Fi](https://8weeksqlchallenge.com/case-study-3/)
![text](https://github.com/Mahmud-Buet15/60-days-of-SQL/blob/main/Problem_set_14(%238_week_sql_challenge)/dataset/foodie.PNG)

# Entity Relationship Diagram
![alt text](https://github.com/Mahmud-Buet15/60-days-of-SQL/blob/main/Problem_set_14(%238_week_sql_challenge)/dataset/ER_diagram.png)

### Problems:
#### Part-01 . Data Analysis Questions
1. How many customers has Foodie-Fi ever had?
2. What is the monthly distribution of trial plan start_date values for our dataset - use the start of the month as the group by value
3. What plan start_date values occur after the year 2020 for our dataset? Show the breakdown by count of events for each plan_name
4. What is the customer count and percentage of customers who have churned rounded to 1 decimal place?
5. How many customers have churned straight after their initial free trial - what percentage is this rounded to the nearest whole number?
6. What is the number and percentage of customer plans after their initial free trial?
7. What is the customer count and percentage breakdown of all 5 plan_name values at 2020-12-31?
8. How many customers have upgraded to an annual plan in 2020?
9. How many days on average does it take for a customer to an annual plan from the day they join Foodie-Fi?
10. Can you further breakdown this average value into 30 day periods (i.e. 0-30 days, 31-60 days etc)
11. How many customers downgraded from a pro monthly to a basic monthly plan in 2020?


#### Part-02. Challenge Payment Question
The Foodie-Fi team wants you to create a new payments table for the year 2020 that includes amounts paid by each customer in the 
subscriptions table with the following requirements:

1. monthly payments always occur on the same day of month as the original start_date of any monthly paid plan
2. upgrades from basic to monthly or pro plans are reduced by the current paid amount in that month and start immediately
3. upgrades from pro monthly to pro annual are paid at the end of the current billing period and also starts at the end of the month period
4. once a customer churns they will no longer make payments

Example outputs for this table might look like the following:
![alt_text](https://github.com/Mahmud-Buet15/60-days-of-SQL/blob/main/Problem_set_14(%238_week_sql_challenge)/dataset/foodie-fi.PNG)


# Solutions
### RDBMS- PostgreSQL

### Part-01 . Data Analysis Questions
#### **Q1. How many customers has Foodie-Fi ever had?**
```sql
select 
	count(distinct customer_id) as total_customer
from foodie_fi.subscriptions;
```
#### Solution
![alt_text](https://github.com/Mahmud-Buet15/60-days-of-SQL/blob/main/Problem_set_14(%238_week_sql_challenge)/dataset/solution%20images/solution_01.png)

#### **Q2.What is the monthly distribution of trial plan start_date values for our dataset - use the start of the month as the group by value**
```sql
select 
	date_trunc('month', tbl2.start_date)::date as start_month,
	count(tbl1.plan_id) as total_trial_plans
from foodie_fi."plans" tbl1
inner join foodie_fi.subscriptions tbl2 on tbl1.plan_id =tbl2.plan_id 
where tbl1.plan_id=0
group by 1
order by 1
;
```
#### Solution
![alt_text](https://github.com/Mahmud-Buet15/60-days-of-SQL/blob/main/Problem_set_14(%238_week_sql_challenge)/dataset/solution%20images/solution_02.png)

#### **Q3. What plan start_date values occur after the year 2020 for our dataset? Show the breakdown by count of events for each plan_name**
```sql
select 
	tbl1.plan_name ,
	count(tbl1.plan_id) as total_events
from foodie_fi."plans" tbl1
inner join foodie_fi.subscriptions tbl2 on tbl1.plan_id =tbl2.plan_id
where tbl2.start_date >='2021-01-01'
group by 1
;
```
#### Solution
![alt_text](https://github.com/Mahmud-Buet15/60-days-of-SQL/blob/main/Problem_set_14(%238_week_sql_challenge)/dataset/solution%20images/solution_03.png)

#### **Q4. What is the customer count and percentage of customers who have churned rounded to 1 decimal place?**
```sql
select 
	count(distinct tbl2.customer_id) as total_customer,
	count(distinct case when tbl1.plan_id =4 then tbl2.customer_id end) as total_churned_customer,
	round(count(distinct case when tbl1.plan_id =4 then tbl2.customer_id end)/count(distinct tbl2.customer_id)::numeric*100,3) as churned_customer_pct
from foodie_fi."plans" tbl1
inner join foodie_fi.subscriptions tbl2 on tbl1.plan_id =tbl2.plan_id
;
```
#### Solution
![alt_text](https://github.com/Mahmud-Buet15/60-days-of-SQL/blob/main/Problem_set_14(%238_week_sql_challenge)/dataset/solution%20images/solution_04.png)

#### **Q5. How many customers have churned straight after their initial free trial - what percentage is this rounded to the nearest whole number?**
```sql
select 
	count(distinct customer_id) as total_customer,
	count(case when plan_id=0 and next_plan_id=4 then customer_id end) as customer_churned_after_free_trial,
	round(count(case when plan_id=0 and next_plan_id=4 then customer_id end)/count(distinct customer_id)::numeric*100,0) as customer_churned_after_free_trial_pct
from 
(
	select 
		tbl2.customer_id ,
		tbl1.plan_id ,
		lead(tbl1.plan_id) over(partition by tbl2.customer_id) as next_plan_id
	from foodie_fi."plans" tbl1
	inner join foodie_fi.subscriptions tbl2 on tbl1.plan_id =tbl2.plan_id
) tbl3
;
```
#### Solution
![alt_text](https://github.com/Mahmud-Buet15/60-days-of-SQL/blob/main/Problem_set_14(%238_week_sql_challenge)/dataset/solution%20images/solution_05.png)

#### **Q6.  What is the number and percentage of customer plans after their initial free trial?**
```sql
select 
	count(distinct customer_id) as total_customer,
	count(case when plan_id=0 and next_plan_id=1 then customer_id end) as trial_to_basic_monthly,
	round(count(case when plan_id=0 and next_plan_id=1 then customer_id end)/count(distinct customer_id)::numeric*100,3) as trial_to_basic_monthly_pct,
	count(case when plan_id=0 and next_plan_id=2 then customer_id end) as trial_to_pro_monthly,
	round(count(case when plan_id=0 and next_plan_id=2 then customer_id end)/count(distinct customer_id)::numeric*100,3) as trial_to_pro_monthly_pct,
	count(case when plan_id=0 and next_plan_id=3 then customer_id end) as trial_to_pro_annual,
	round(count(case when plan_id=0 and next_plan_id=3 then customer_id end)/count(distinct customer_id)::numeric*100,3) as trial_to_pro_annual_pct,
	count(case when plan_id=0 and next_plan_id=4 then customer_id end) as trial_to_churn,
	round(count(case when plan_id=0 and next_plan_id=4 then customer_id end)/count(distinct customer_id)::numeric*100,3) as trial_to_churn_pct
from 
(
	select 
		tbl2.customer_id ,
		tbl1.plan_id ,
		lead(tbl1.plan_id) over(partition by tbl2.customer_id) as next_plan_id
	from foodie_fi."plans" tbl1
	inner join foodie_fi.subscriptions tbl2 on tbl1.plan_id =tbl2.plan_id
) tbl3
;
```
#### Solution
![alt_text](https://github.com/Mahmud-Buet15/60-days-of-SQL/blob/main/Problem_set_14(%238_week_sql_challenge)/dataset/solution%20images/solution_06.png)

#### **Q7. What is the customer count and percentage breakdown of all 5 plan_name values at 2020-12-31?**
```sql
select 
	'2020-12-31'::date as report_date,
	customer_plan_status,
	count(customer_id) as total_customer,
	(count(customer_id)/1000::numeric)*100 as pct_of_total_customer
from 
	(
		select 
			*,
			case when end_date>='2020-12-31' and plan_name='basic monthly' then 'basic monthly'
				when end_date>='2020-12-31' and plan_name='pro monthly' then 'pro monthly'
				when end_date>='2020-12-31' and plan_name='pro annual' then 'pro annual'
				when end_date>='2020-12-31' and plan_name='trial' then 'trial'
				when (end_date='2020-12-31' and plan_name='churn') or end_date<'2020-12-31'  then 'churn'
			end as customer_plan_status
		from 
			(
      select 
        *,
        case when plan_name='basic monthly' then start_date+30
          when  plan_name='pro monthly' then start_date+30
          when  plan_name='pro annual' then start_date+365
          when  plan_name='churn' then start_date
          when plan_name='trial' then start_date+7
        end as end_date
      from 
        (-- taking the plans which start on or before 2020-12-31
        select 
          tbl1.plan_id ,
          tbl1.plan_name ,
          tbl2.customer_id ,
          tbl2.start_date ,
          max(tbl2.start_date) over(partition by tbl2.customer_id) as latest_plan_start_date
        from foodie_fi."plans" tbl1
        inner join foodie_fi.subscriptions tbl2 on tbl1.plan_id =tbl2.plan_id
        where tbl2.start_date <='2020-12-31'
        ) tbl3
      where start_date=latest_plan_start_date --taking last plan for each customer
			) tbl4
	) tbl5
group by 1,2
;
```
#### Solution
![alt_text](https://github.com/Mahmud-Buet15/60-days-of-SQL/blob/main/Problem_set_14(%238_week_sql_challenge)/dataset/solution%20images/solution_07.png)

#### **Q8. How many customers have upgraded to an annual plan in 2020?**
```sql
select 
	count(distinct tbl2.customer_id)
from foodie_fi."plans" tbl1
inner join foodie_fi.subscriptions tbl2 on tbl1.plan_id =tbl2.plan_id
where tbl1.plan_id =3
and start_date<='2020-12-31'
;
```
#### Solution
![alt_text](https://github.com/Mahmud-Buet15/60-days-of-SQL/blob/main/Problem_set_14(%238_week_sql_challenge)/dataset/solution%20images/solution_08.png)

#### **Q9. How many days on average does it take for a customer to an annual plan from the day they join Foodie-Fi?**
```sql
select
	floor(avg(day_gap)) as avg_day_gap
from 
	(
		select
			tbl3.customer_id,
			tbl3.join_date,
			tbl4.annual_plan_start_date,
			tbl4.annual_plan_start_date-tbl3.join_date as day_gap
		from 
			(--only taking trial plans
				select 
					tbl2.customer_id,
					tbl1.plan_id ,
					tbl2.start_date as join_date
				from foodie_fi."plans" tbl1
				inner join foodie_fi.subscriptions tbl2 on tbl1.plan_id =tbl2.plan_id
				where tbl1.plan_id =0
			) tbl3
		inner join 
			(--only taking annual plans
				select 
					tbl2.customer_id,
					tbl1.plan_id ,
					tbl2.start_date as annual_plan_start_date
				from foodie_fi."plans" tbl1
				inner join foodie_fi.subscriptions tbl2 on tbl1.plan_id =tbl2.plan_id
				where tbl1.plan_id =3
			) tbl4 on tbl3.customer_id=tbl4.customer_id
	) tbl5
;
```
#### Solution
![alt_text](https://github.com/Mahmud-Buet15/60-days-of-SQL/blob/main/Problem_set_14(%238_week_sql_challenge)/dataset/solution%20images/solution_09.png)

#### **Q10. Can you further breakdown this average value into 30 day periods (i.e. 0-30 days, 31-60 days etc)**
```sql
select 
	days,
	count(customer_id)
from 
(
select
	customer_id,
	case when day_gap>=0 and day_gap<=30 then '0-30 days'
		when day_gap>=31and day_gap<=60 then '31- 60 days'
		when day_gap>=61 and day_gap<=90 then '61-90 days'
		when day_gap>90 then '>90 days'
	end as days
from 
	(
		select
			tbl3.customer_id,
			tbl3.join_date,
			tbl4.annual_plan_start_date,
			tbl4.annual_plan_start_date-tbl3.join_date as day_gap
		from 
			(--only taking trial plans
				select 
					tbl2.customer_id,
					tbl1.plan_id ,
					tbl2.start_date as join_date
				from foodie_fi."plans" tbl1
				inner join foodie_fi.subscriptions tbl2 on tbl1.plan_id =tbl2.plan_id
				where tbl1.plan_id =0
			) tbl3
		inner join 
			(--only taking annual plans
				select 
					tbl2.customer_id,
					tbl1.plan_id ,
					tbl2.start_date as annual_plan_start_date
				from foodie_fi."plans" tbl1
				inner join foodie_fi.subscriptions tbl2 on tbl1.plan_id =tbl2.plan_id
				where tbl1.plan_id =3
			) tbl4 on tbl3.customer_id=tbl4.customer_id
	) tbl5
) tbl6
group by 1
;
```
#### Solution
![alt_text](https://github.com/Mahmud-Buet15/60-days-of-SQL/blob/main/Problem_set_14(%238_week_sql_challenge)/dataset/solution%20images/solution_10.png)

#### **Q11. How many customers downgraded from a pro monthly to a basic monthly plan in 2020?**
```sql
select 
	count(distinct customer_id) as total_customer_downgraded
from 
(
select 
	tbl2.customer_id ,
	tbl2.plan_id ,
	lead(tbl2.plan_id ) over(partition by tbl2.customer_id) as next_plan_id
from foodie_fi."plans" tbl1
inner join foodie_fi.subscriptions tbl2 on tbl1.plan_id =tbl2.plan_id
where tbl2.start_date<='2020-12-31'
) tbl3
where plan_id=2 and next_plan_id=1
;
```
#### Solution
![alt_text](https://github.com/Mahmud-Buet15/60-days-of-SQL/blob/main/Problem_set_14(%238_week_sql_challenge)/dataset/solution%20images/solution_11.png)

### Part-02. Challenge Payment Question
The Foodie-Fi team wants you to create a new payments table for the year 2020 that includes amounts paid by each customer in the 
subscriptions table with the following requirements:

1. monthly payments always occur on the same day of month as the original start_date of any monthly paid plan
2. upgrades from basic to monthly or pro plans are reduced by the current paid amount in that month and start immediately
3. upgrades from pro monthly to pro annual are paid at the end of the current billing period and also starts at the end of the month period
4. once a customer churns they will no longer make payments

#### **Using CTE (Common Table Expression)**
```sql
create table foodie_fi.payment_table_method_1 as 
with cte as 
	( 
	select 
		tbl2.customer_id,
		tbl1.plan_id ,
		tbl1.plan_name ,
		tbl2.start_date,
		tbl1.price ,
		lead(tbl2.start_date) over(partition by tbl2.customer_id order by tbl2.start_date)  as plan_end_date,
		lead(tbl1.plan_name) over(partition by tbl2.customer_id order by tbl2.start_date) as next_plan,
		coalesce(lead(tbl2.start_date) over(partition by tbl2.customer_id order by tbl2.start_date), '2020-12-31'::date) as till_date    --in case users didn't changed their plan
	from foodie_fi."plans" tbl1
	inner join foodie_fi.subscriptions tbl2 on tbl1.plan_id =tbl2.plan_id
	where 1=1
	and start_date<='2020-12-31'
	and tbl1.plan_id!=0  -- ignoring trial plans (as it's not related to payment)
	order by 1,2
	) ,
	
cte2 as 
	(
	select 
		*,
		generate_series(start_date,till_date,'1 Month')::date as payment_date
	from cte
	where plan_name in ('basic monthly','pro monthly')
	
	union all 
	
	select 
		*,
		generate_series(start_date,till_date,'1 Year')::date as payment_date
	from cte
	where plan_name in ('pro annual')
	order by customer_id,payment_date
	) 
	
select 
	customer_id,
	plan_id,
	plan_name,
	payment_date,
	price,
	row_number() over(partition by customer_id order by payment_date) as payment_order
from cte2
;

select * from foodie_fi.payment_table_method_1; --4,526 rows
```
#### Solution
![alt_text](https://github.com/Mahmud-Buet15/60-days-of-SQL/blob/main/Problem_set_14(%238_week_sql_challenge)/dataset/solution%20images/solution_part_2.png)

## Alternative Solution
#### **Using Sub-queries**
```sql

create table foodie_fi.payment_table_method_2 as 
select 
	customer_id,
	plan_id,
	plan_name,
	payment_date,
	price,
	row_number() over(partition by customer_id order by payment_date) as payment_order
from 
	(
	select 
		*,
		generate_series(start_date,till_date,'1 Month')::date as payment_date
	from 
		(
		select 
			tbl2.customer_id,
			tbl1.plan_id ,
			tbl1.plan_name ,
			tbl2.start_date,
			tbl1.price ,
			lead(tbl2.start_date) over(partition by tbl2.customer_id order by tbl2.start_date)  as plan_end_date,
			lead(tbl1.plan_name) over(partition by tbl2.customer_id order by tbl2.start_date) as next_plan,
			coalesce(lead(tbl2.start_date) over(partition by tbl2.customer_id order by tbl2.start_date), '2020-12-31'::date) as till_date  --in case users didn't changed their plan
		from foodie_fi."plans" tbl1
		inner join foodie_fi.subscriptions tbl2 on tbl1.plan_id =tbl2.plan_id
		where 1=1
		and start_date<='2020-12-31'
		and tbl1.plan_id!=0 -- ignoring trial plans (as it's not related to payment)
		order by 1,2
		) tbl3
	where plan_name in ('basic monthly','pro monthly')
	
	union all 
	
	select 
		*,
		generate_series(start_date,till_date,'1 Year')::date as payment_date
	from 
		(
		select 
			tbl2.customer_id,
			tbl1.plan_id ,
			tbl1.plan_name ,
			tbl2.start_date,
			tbl1.price ,
			lead(tbl2.start_date) over(partition by tbl2.customer_id order by tbl2.start_date)  as plan_end_date,
			lead(tbl1.plan_name) over(partition by tbl2.customer_id order by tbl2.start_date) as next_plan,
			coalesce(lead(tbl2.start_date) over(partition by tbl2.customer_id order by tbl2.start_date), '2020-12-31'::date) as till_date  --in case users didn't changed their plan
		from foodie_fi."plans" tbl1
		inner join foodie_fi.subscriptions tbl2 on tbl1.plan_id =tbl2.plan_id
		where 1=1
		and start_date<='2020-12-31'
		and tbl1.plan_id!=0   -- ignoring trial plans (as it's not related to payment)
		order by 1,2
		) tbl4
	where plan_name in ('pro annual')
	) tbl5
order by customer_id,payment_date
;

select * from foodie_fi.payment_table_method_2; --4,526 rows
```
