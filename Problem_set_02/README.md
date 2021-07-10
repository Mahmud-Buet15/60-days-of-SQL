# Problem Set 02

# Schema
![alt text](https://github.com/Mahmud-Buet15/60-days-of-SQL/blob/main/Problem_set_02/dataset/schema.png)

Problem source: [HackerRank](https://www.hackerrank.com/domains/sql?badge_type=sql)

Full Solution: [Notebook](https://github.com/Mahmud-Buet15/60-days-of-SQL/blob/main/Problem_set_02/Problem_set_02.ipynb)

### QUERIES:
1.	Query a list of CITY and STATE from the STATION table.
2.	Query a list of CITY names from STATION for cities that have an even ID number. Print the results in any order, but exclude duplicates from the answer.
3.	Find the difference between the total number of CITY entries in the table and the number of distinct CITY entries in the table.
4.	Query the two cities in STATION with the shortest and longest CITY names, as well as their respective lengths (i.e.: number of characters in the name). If there is more than one smallest or largest city, choose the one that comes first when ordered alphabetically.
5.	Query the list of CITY names starting with vowels (i.e., a, e, i, o, or u) from STATION. Your result cannot contain duplicates.
6.	Query the list of CITY names ending with vowels (a, e, i, o, u) from STATION. Your result cannot contain duplicates.
7.	Query the list of CITY names from STATION which have vowels (i.e., a, e, i, o, and u) as both their first and last characters. Your result cannot contain duplicates.
8.	Query the list of CITY names from STATION that do not start with vowels. Your result cannot contain duplicates.
9.	Query the list of CITY names from STATION that do not end with vowels. Your result cannot contain duplicates.
10.	Query the list of CITY names from STATION that either do not start with vowels or do not end with vowels. Your result cannot contain duplicates.
11.	Query the list of CITY names from STATION that do not start with vowels and do not end with vowels. Your result cannot contain duplicates.

### RDBMS- MySQL

 <br /> 

## Solutions

### **Q1.Query a list of CITY and STATE from the STATION table.**
```sql
select CITY,STATE 
from STATION;
```



### **Q2.Query a list of CITY names from STATION for cities that have an even ID number. Print the results in any order, but exclude duplicates from the answer.**
```sql
select CITY 
from STATION
where ID%2=0
order by CITY;
```



### **Q3. Find the difference between the total number of CITY entries in the table and the number of distinct CITY entries in the table.**
```sql
select count(CITY)-count(distinct CITY) as Difference 
from STATION;
```


### **Q4. Query the two cities in STATION with the shortest and longest CITY names, as well as their respective lengths (i.e.: number of characters in the name). If there is more than one smallest or largest city, choose the one that comes first when ordered alphabetically.**
```sql
select CITY,length(CITY) as "Number Of Character" 
from STATION
order by 2 
limit 1;

select CITY,length(CITY) as "Number Of Character" 
from STATION
order by 2 desc
limit 1;
```


### **Q5. Query the list of CITY names starting with vowels (i.e., a, e, i, o, or u) from STATION. Your result cannot contain duplicates.**
```sql
select distinct(CITY) 
from STATION
where CITY regexp "^[aeiou]";
```


### **Q6.  Query the list of CITY names ending with vowels (a, e, i, o, u) from STATION. Your result cannot contain duplicates.**
```sql
select distinct(CITY) 
from STATION
where CITY regexp "[aeiou]$";
```


### **Q7. Query the list of CITY names from STATION which have vowels (i.e., a, e, i, o, and u) as both their first and last characters. Your result cannot contain duplicates.**
```sql
select distinct(CITY) 
from STATION
where CITY regexp "^[aeiou].*[aeiou]$" ;
```


### **Q8. Query the list of CITY names from STATION that do not start with vowels. Your result cannot contain duplicates.**
```sql
select distinct(CITY) 
from STATION
where CITY regexp "^[^aeiou]";
```


### **Q9. Query the list of CITY names from STATION that do not end with vowels. Your result cannot contain duplicates.**
```sql
select distinct(CITY) 
from STATION
where CITY regexp "[^aeiou]$";
```


### **Q10. Query the list of CITY names from STATION that either do not start with vowels or do not end with vowels. Your result cannot contain duplicates.**
```sql
select distinct(CITY) 
from STATION
where CITY regexp "^[^aeiou]|[^aeiou]$";
```


### **Q11. Query the list of CITY names from STATION that do not start with vowels and do not end with vowels. Your result cannot contain duplicates.**
```sql
select distinct(CITY) 
from STATION
where CITY regexp "^[^aeiou].*[^aeiou]$";
```


