# Problem Set 01

# Schema
![alt text](https://github.com/Mahmud-Buet15/60-days-of-SQL/blob/main/Problem_set_01/images/Problem_set_01.png)

Problem source: [HackerRank](https://www.hackerrank.com/domains/sql?badge_type=sql)

Full Solution: [Notebook](https://github.com/Mahmud-Buet15/60-days-of-SQL/blob/main/Problem_set_01/Problem_set_01.ipynb)

### QUERIES:
1.	Query all columns for all American cities in the CITY table with populations larger than 100000. The CountryCode for America is USA.
2.	Query the NAME field for all American cities in the CITY table with populations larger than 120000. The CountryCode for America is USA.
3.	Query all columns for a city in CITY with the ID 1661.
4.	Query all attributes of every Japanese city in the CITY table. The COUNTRYCODE for Japan is JPN.
5.	Query the names and populations of all the Japanese cities in the CITY table. The COUNTRYCODE for Japan is JPN.
6.	Query a count of the number of cities in CITY having a Population larger than 100,000.
7.	Query the total population of all cities in CITY where District is California.
8.	Query the average population of all cities in CITY where District is California.
9.	Query the average population for all cities in CITY, rounded down to the nearest integer.
10.	Query the sum of the populations for all Japanese cities in CITY. The COUNTRYCODE for Japan is JPN.
11.	Query the difference between the maximum and minimum populations in CITY.

### RDBMS- MySQL

 <br /> 

## Solutions

### **Q1. Query all columns for all American cities in the CITY table with populations larger than 100000. The CountryCode for America is USA.**
```sql
select * 
from CITY
where COUNTRYCODE="USA" && POPULATION>100000;
```



### **Q2.Query the NAME field for all American cities in the CITY table with populations larger than 120000. The CountryCode for America is USA.**
```sql
select NAME 
from CITY
where COUNTRYCODE="USA" and POPULATION>120000;
```



### **Q3. Query all columns for a city in CITY with the ID 1661.**
```sql
select * 
from CITY
where ID=1661;
```


### **Q4. Query all attributes of every Japanese city in the CITY table. The COUNTRYCODE for Japan is JPN.**
```sql
select * 
from CITY
where COUNTRYCODE="JPN";
```


### **Q5. Query the names and populations of all the Japanese cities in the CITY table. The COUNTRYCODE for Japan is JPN.**
```sql
select NAME,POPULATION 
from CITY
where COUNTRYCODE="JPN";
```


### **Q6.  Query a count of the number of cities in CITY having a Population larger than 100,000.**
```sql
select count(distinct(ID)) as "NUMBER OF CITIES" 
from CITY
where POPULATION>100000;
```


### **Q7. Query the total population of all cities in CITY where District is California.'**
```sql
select sum(POPULATION) as "POPULATION OF CALIFORNIA"
from CITY
where DISTRICT="California";
```


### **Q8. Query the average population of all cities in CITY where District is California.**
```sql
select avg(POPULATION) as "AVERAGE POPULATION OF CALIFORNIA"
from CITY
where DISTRICT="California";
```


### **Q9. Query the average population for all cities in CITY, rounded down to the nearest integer.**
```sql
select round(avg(POPULATION)) as "AVERAGE POPULATION"
from CITY;
```


### **Q10. Query the sum of the populations for all Japanese cities in CITY. The COUNTRYCODE for Japan is JPN.**
```sql
select sum(POPULATION) as "POPULATION OF JAPAN"
from CITY
where COUNTRYCODE="JPN";
```


### **Q11. Query the difference between the maximum and minimum populations in CITY.**
```sql
select max(POPULATION)-min(POPULATION) as "DIFFERENCE"
from CITY;
```

