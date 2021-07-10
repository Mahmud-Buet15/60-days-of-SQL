# Problem Set 03

# Schema
![alt text](https://github.com/Mahmud-Buet15/60-days-of-SQL/blob/main/Problem_set_03/dataset/schema.png)

Problem source: [HackerRank](https://www.hackerrank.com/domains/sql?badge_type=sql)

Full Solution: [Notebook](https://github.com/Mahmud-Buet15/60-days-of-SQL/blob/main/Problem_set_02/Problem_set_02.ipynb)

### QUERIES:
1.	Query the following two values from the STATION table:
     o	The sum of all values in LAT_N rounded to a scale of 2  decimal places.
     o	The sum of all values in LONG_W rounded to a scale of 2  decimal places.

2.	Query the sum of Northern Latitudes (LAT_N) from STATION having values greater than 38.7880 and less than 137.2345. Truncate your answer to 4 decimal places.
3.	Query the greatest value of the Northern Latitudes (LAT_N) from STATION that is less than 137.2345. Truncate your answer to 4 decimal places.
4.	Query the Western Longitude (LONG_W) for the largest Northern Latitude (LAT_N) in STATION that is less than 137.2345 . Round your answer to 4 decimal places.
5.	Query the smallest Northern Latitude (LAT_N) from STATION that is greater than 38.7880  . Round your answer to 4 decimal places.
6.	Query the Western Longitude (LONG_W)where the smallest Northern Latitude (LAT_N) in STATION is greater than 38.7880  . Round your answer to 4 decimal places.
7.	Consider  P1(a,b)  and P2(c,d) to be two points on a 2D plane.
   •	a  happens to equal the minimum value in Northern Latitude (LAT_N in STATION).
   •	 b happens to equal the minimum value in Western Longitude (LONG_W in STATION).
   •	 c happens to equal the maximum value in Northern Latitude (LAT_N in STATION).
   •	 d happens to equal the maximum value in Western Longitude (LONG_W in STATION).
   Query the Manhattan Distance between points P1 and P2 and round it to a scale of 4 decimal places.
8.	Consider  P1(a,c)  and P2(b,d)   to be two points on a 2D plane where (a,b)  are the respective minimum and maximum values of Northern Latitude (LAT_N) and (c,d)  are the respective minimum and maximum values of Western Longitude (LONG_W) in STATION.
Query the Euclidean Distance between points P1 and P2 and format your answer to display 4 decimal digits.


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
