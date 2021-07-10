# Problem Set 05

# Schema
![alt text](https://github.com/Mahmud-Buet15/60-days-of-SQL/blob/main/Problem_set_05/dataset/schema.png)

Note: **CITY.CountryCode** and **COUNTRY.Code** are matching key columns.

Problem source: [HackerRank](https://www.hackerrank.com/domains/sql?badge_type=sql)

Full Solution: [Notebook](https://github.com/Mahmud-Buet15/60-days-of-SQL/blob/main/Problem_set_05/Problem_set_05.ipynb)

### QUERIES:
1.	Given the CITY and COUNTRY tables, query the sum of the populations of all cities where the CONTINENT is 'Asia'.
              Note: CITY.CountryCode and COUNTRY.Code are matching key columns.
2.	Given the CITY and COUNTRY tables, query the names of all cities where the CONTINENT is 'Africa'.
             Note: CITY.CountryCode and COUNTRY.Code are matching key columns.
3.	Given the CITY and COUNTRY tables, query the names of all the continents (COUNTRY.Continent) and their respective average city populations (CITY.Population) rounded down to the nearest integer.
             Note: CITY.CountryCode and COUNTRY.Code are matching key columns.
4.	Query the NAME, POPULATION and GNP of the country where GNP is maximum.
5.	Query the NAME, POPULATION and GNP of the country where GNP is minimum.
6.	Query the NAME of the country having most LIFEEXPECTANCY.
7.	Query the NAME and GNP of the largest COUNTRY.
8.	Query the NAME and GNP of the most populated COUNTRY.

### RDBMS- MySQL

<br /> 

## Solutions

### **Q1.Given the CITY and COUNTRY tables, query the sum of the populations of all cities where the CONTINENT is 'Asia'.**
   **Note: CITY.CountryCode and COUNTRY.Code are matching key columns.**
```sql
select sum(CITY.POPULATION) as "Population"
from CITY inner join COUNTRY
on CITY.COUNTRYCODE=COUNTRY.CODE
where CONTINENT="Asia";
```



### **Q2.Given the CITY and COUNTRY tables, query the names of all cities where the CONTINENT is 'Africa'.**
  **Note: CITY.CountryCode and COUNTRY.Code are matching key columns.**
```sql
select CITY.NAME 
from CITY inner join COUNTRY
on CITY.COUNTRYCODE=COUNTRY.CODE
where CONTINENT="Africa";
```



### **Q3. Given the CITY and COUNTRY tables, query the names of all the continents (COUNTRY.Continent) and their respective average city populations (CITY.Population) rounded down to the nearest integer.**
  **Note: CITY.CountryCode and COUNTRY.Code are matching key columns.**
```sql
select COUNTRY.CONTINENT,round(avg(CITY.POPULATION)) as "Average Population"
from CITY inner join COUNTRY
on CITY.COUNTRYCODE=COUNTRY.CODE
group by 1;
```


### **Q4.Query the NAME, POPULATION and GNP of the country where GNP is maximum.**
```sql
select NAME,POPULATION,GNP 
from COUNTRY
where GNP=(select max(GNP) 
           from COUNTRY);
```


### **Q5. Query the NAME, POPULATION and GNP of the country where GNP is minimum..**
```sql
select NAME,POPULATION,GNP 
from COUNTRY
where GNP=(select min(GNP) 
            from COUNTRY);
```


### **Q6.  Query the NAME of the country having most LIFEEXPECTANCY.**
```sql
select NAME,LIFEEXPECTANCY
from COUNTRY
order by 2 desc
limit 1;
```


### **Q7. Query the NAME and GNP of the largest COUNTRY.**
```sql
select NAME,GNP 
from COUNTRY
where SURFACEAREA=(select max(SURFACEAREA) 
                    from COUNTRY);
```


### **Q8. Query the NAME and GNP of the most populated COUNTRY.**
```sql
select NAME,GNP 
from COUNTRY   
where POPULATION=(select max(POPULATION) 
                    from COUNTRY);
```
