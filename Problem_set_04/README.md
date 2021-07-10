# Problem Set 04

# Schema
![alt text](https://github.com/Mahmud-Buet15/60-days-of-SQL/blob/main/Problem_set_04/dataset/schema.png)

Problem source: [HackerRank](https://www.hackerrank.com/domains/sql?badge_type=sql)

Full Solution: [Notebook](https://github.com/Mahmud-Buet15/60-days-of-SQL/blob/main/Problem_set_04/Problem_set_04.ipynb)

### QUERIES:
1.	Write a query that prints a list of employee names (i.e.: the name attribute) from the Employee table in alphabetical order.
2.	Write a query that prints a list of employee names (i.e.: the name attribute) for employees in Employee having a salary greater than $2000 per month who have been employees for less than 10 months. Sort your result by ascending employee_id.
3.	Find the number of most Senior Employees.
4.	We define an employee's total earnings to be their monthly salary x months worked, and the maximum total earnings to be the maximum total earnings for any employee in the Employee table. Write a query to find the maximum total earnings for all employees as well as the total number of employees who have maximum total earnings. Then print these values as 2 space-separated integers.

### RDBMS- MySQL

<br /> 

## Solutions

### **Q1.Write a query that prints a list of employee names (i.e.: the name attribute) from the Employee table in alphabetical order.**
```sql
SELECT name 
FROM Employee
ORDER BY name;
```



### **Q2.Write a query that prints a list of employee names (i.e.: the name attribute) for employees in Employee having a salary greater than $2000 per month who have been employees for less than 10 months. Sort your result by ascending employee_id.**
```sql
SELECT name 
FROM Employee
WHERE salary>2000 AND months<10
ORDER BY employee_id;
```



### **Q3. Find the number of most Senior Employees.**
```sql
SELECT COUNT(*) as "Number of Senior Employees" 
FROM Employee
GROUP BY months 
ORDER BY months DESC
LIMIT 1;
```


### **Q4. We define an employee's total earnings to be their monthly salary x months worked, and the maximum total earnings to be the maximum total earnings for any employee in the Employee table. Write a query to find the maximum total earnings for all employees as well as the total number of employees who have maximum total earnings. Then print these values as 2 space-separated integers.**
```sql
SELECT months*salary as Earnings ,COUNT(*) as "Top Earners" 
FROM Employee
GROUP BY 1
ORDER BY 1 DESC
LIMIT 1;
```
