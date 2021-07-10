# Problem Set 10

# Table Description
![alt text](https://github.com/Mahmud-Buet15/60-days-of-SQL/blob/main/Problem_set_10/dataset/schema.png)

Note: **stops.id** and **route.stop** are matching key columns.

Problem source: [SQLzoo](https://sqlzoo.net/wiki/Self_join)

Full Solution: [Notebook](https://github.com/Mahmud-Buet15/60-days-of-SQL/blob/main/Problem_set_10/Problem_set_10.ipynb)

### QUERIES:
1. How many stops are in the database?
2. Find the id value for the stop 'Craiglockhart'
3. Give the id and the name for the stops on the '4' 'LRT' service.
4. Show the number of routes that visit either London Road (149) or Craiglockhart (53) and which are greater than 1.
5. Execute the self join so that it shows the services from Craiglockhart (53) to London Road (149).
6. Give a list of all the services which connect stops 115 and 137 ('Haymarket' and 'Leith')
7. Give a list of the services which connect the stops 'Craiglockhart' and 'Tollcross'
8. Give a distinct list of the stops which may be reached from 'Craiglockhart' by taking one bus, including 'Craiglockhart' itself, offered by the LRT company. Include the company and bus no. of the relevant services.
9. Show the services available from Tollcross.

### RDBMS- MySQL

 <br /> 

## Solutions

### **Q1. How many stops are in the database?**
```sql
SELECT COUNT(*)
FROM stops;
```



### **Q2.Find the id value for the stop 'Craiglockhart'**
```sql
SELECT id
FROM stops
WHERE name='Craiglockhart';
```



### **Q3. Give the id and the name for the stops on the '4' 'LRT' service.**
```sql
SELECT * 
FROM stops JOIN route
ON stops.id=route.stop
WHERE company='LRT' AND num='4';
```


### **Q4. Show the number of routes that visit either London Road (149) or Craiglockhart (53) and which are greater than 1.**
```sql
SELECT company,num,COUNT(stop) AS Number_of_routes
FROM route
WHERE stop=149 OR stop=53
GROUP BY company,num
HAVING Number_of_routes>1;
```


### **Q5. Execute the self join so that it shows the services from Craiglockhart (53) to London Road (149).**
```sql
SELECT r1.company,r1.num,r1.stop,r2.stop
FROM route r1 JOIN route r2
ON r1.num=r2.num AND r1.company=r2.company
WHERE r1.stop=53 AND r2.stop=149';
```


### **Q6.  Give a list of all the services which connect stops 115 and 137 ('Haymarket' and 'Leith')**
```sql
SELECT DISTINCT(r1.company),r1.num
FROM route r1 JOIN route r2
ON r1.num=r2.num AND r1.company=r2.company
WHERE r1.stop=115 AND r2.stop=137;
```


### **Q7. Give a list of the services which connect the stops 'Craiglockhart' and 'Tollcross'**
```sql
SELECT r1.company,r1.num
FROM route r1 JOIN route r2 ON (r1.num=r2.num AND r1.company=r2.company)
JOIN stops s1 ON r1.stop=s1.id
JOIN stops s2 ON r2.stop=s2.id
WHERE s1.name='Craiglockhart' AND s2.name='Tollcross';
```


### **Q8. Give a distinct list of the stops which may be reached from 'Craiglockhart' by taking one bus, including 'Craiglockhart' itself, offered by the LRT company. Include the company and bus no. of the relevant services.**
```sql
SELECT s2.name,r1.company,r1.num
FROM route r1 JOIN route r2 ON (r1.num=r2.num AND r1.company=r2.company)
JOIN stops s1 ON r1.stop=s1.id
JOIN stops s2 ON r2.stop=s2.id
WHERE s1.name='Craiglockhart' AND r1.company='LRT';
```


### **Q9. Show the services available from Tollcross.**
```sql
SELECT r1.company,r1.num,s1.name,s2.name
FROM route r1 JOIN route r2 ON (r1.num=r2.num AND r1.company=r2.company)
JOIN stops s1 ON r1.stop=s1.id
JOIN stops s2 ON r2.stop=s2.id
WHERE s1.name='Tollcross';
```
