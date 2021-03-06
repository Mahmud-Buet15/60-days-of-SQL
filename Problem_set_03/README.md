# Problem Set 03

# Schema
![alt text](https://github.com/Mahmud-Buet15/60-days-of-SQL/blob/main/Problem_set_03/dataset/schema.png)

Problem source: [HackerRank](https://www.hackerrank.com/domains/sql?badge_type=sql)

Full Solution: [Notebook](https://github.com/Mahmud-Buet15/60-days-of-SQL/blob/main/Problem_set_03/Problem_set_03.ipynb)

### QUERIES:
1.	Query the following two values from the STATION table:
- The sum of all values in LAT_N rounded to a scale of 2  decimal places.
- The sum of all values in LONG_W rounded to a scale of 2  decimal places.

2.	Query the sum of Northern Latitudes (LAT_N) from STATION having values greater than 38.7880 and less than 137.2345. Truncate your answer to 4 decimal places.
3.	Query the greatest value of the Northern Latitudes (LAT_N) from STATION that is less than 137.2345. Truncate your answer to 4 decimal places.
4.	Query the Western Longitude (LONG_W) for the largest Northern Latitude (LAT_N) in STATION that is less than 137.2345 . Round your answer to 4 decimal places.
5.	Query the smallest Northern Latitude (LAT_N) from STATION that is greater than 38.7880  . Round your answer to 4 decimal places.
6.	Query the Western Longitude (LONG_W)where the smallest Northern Latitude (LAT_N) in STATION is greater than 38.7880  . Round your answer to 4 decimal places.
7.	Consider  P1(a,b)  and P2(c,d) to be two points on a 2D plane.
  -	a  happens to equal the minimum value in Northern Latitude (LAT_N in STATION).
  -	b happens to equal the minimum value in Western Longitude (LONG_W in STATION).
  -	c happens to equal the maximum value in Northern Latitude (LAT_N in STATION).
  -	d happens to equal the maximum value in Western Longitude (LONG_W in STATION).
   Query the Manhattan Distance between points P1 and P2 and round it to a scale of 4 decimal places.
8.  Consider  P1(a,c)  and P2(b,d)   to be two points on a 2D plane where (a,b)  are the respective minimum and maximum values of Northern Latitude (LAT_N) and (c,d)  are the respective minimum and maximum values of Western Longitude (LONG_W) in STATION.
Query the Euclidean Distance between points P1 and P2 and format your answer to display 4 decimal digits.


### RDBMS- MySQL

 <br /> 

## Solutions

### **Query the following two values from the STATION table:**
- **The sum of all values in LAT_N rounded to a scale of 2  decimal places.**
- **The sum of all values in LONG_W rounded to a scale of 2  decimal places.**
```sql
select round(sum(LAT_N),2) as lat,round(sum(LONG_W),2) as lon 
from STATION;
```



### **Q2.Query the sum of Northern Latitudes (LAT_N) from STATION having values greater than 38.7880 and less than 137.2345. Truncate your answer to 4 decimal places.**
```sql
select round(sum(LAT_N),4) as SUM 
from STATION
where LAT_N>38.7880 and LAT_N<137.2345;
```



### **Q3. Query the greatest value of the Northern Latitudes (LAT_N) from STATION that is less than 137.2345. Truncate your answer to 4 decimal places.**
```sql
select round(max(LAT_N),4) as "Greatest value" 
from STATION
where LAT_N<137.2345;
```


### **Q4.Query the Western Longitude (LONG_W) for the largest Northern Latitude (LAT_N) in STATION that is less than 137.2345 . Round your answer to 4 decimal places.**
```sql
select round(LONG_W,4) as "Greatest value" 
from STATION 
where LAT_N=(select max(LAT_N) 
             from STATION
             where LAT_N<137.2345)
;             
```


### **Q5. Query the smallest Northern Latitude (LAT_N) from STATION that is greater than 38.7880  . Round your answer to 4 decimal places.**
```sql
select round(min(LAT_N),4) as "Smallest value" 
from STATION
where LAT_N>38.7880;
```


### **Q6.  Query the Western Longitude (LONG_W)where the smallest Northern Latitude (LAT_N) in STATION is greater than 38.7880  . Round your answer to 4 decimal places.**
```sql
select round(LONG_W,4) as "Smallest value" 
from STATION 
where LAT_N=(select min(LAT_N) 
             from STATION
             where LAT_N>38.7880)
;             
```


### **Q7. Consider  P1(a,b)  and P2(c,d) to be two points on a 2D plane.**
  -	**a  happens to equal the minimum value in Northern Latitude (LAT_N in STATION).**
  -	**b happens to equal the minimum value in Western Longitude (LONG_W in STATION).**
  -	**c happens to equal the maximum value in Northern Latitude (LAT_N in STATION).**
  -	**d happens to equal the maximum value in Western Longitude (LONG_W in STATION).**
```sql
select round(abs(min(LAT_N)-max(LAT_N))+abs(min(LONG_W)-max(LONG_W)),4) as "Manhatten Distance"
from STATION;
```


### **Q8. Consider  P1(a,c)  and P2(b,d)   to be two points on a 2D plane where (a,b)  are the respective minimum and maximum values of Northern Latitude (LAT_N) and (c,d)  are the respective minimum and maximum values of Western Longitude (LONG_W) in STATION.**
### **Query the Euclidean Distance between points P1 and P2 and format your answer to display 4 decimal digits.**
```sql
select round(sqrt(pow(min(LAT_N)-max(LAT_N),2)+
                  pow(min(LONG_W)-max(LONG_W),2)),4) as "Euclidean Distance"
from STATION;
```

