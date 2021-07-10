# Problem Set 09

# Entity Relationship Diagram
![alt text](https://github.com/Mahmud-Buet15/60-days-of-SQL/blob/main/Problem_set_09/dataset/schema.png)

Note: **teacher.dept** and **dept.id** are matching key columns.

Problem source: [SQLzoo](https://sqlzoo.net/wiki/Using_Null)

Full Solution: [Notebook](https://github.com/Mahmud-Buet15/60-days-of-SQL/blob/main/Problem_set_09/Problem_set_09.ipynb)

### QUERIES:
1. List the teachers who have NULL for their department.
2. INNER JOIN misses the teachers with no department and the departments with no teacher. Use a different JOIN so that all teachers are listed.
3. Use a different JOIN so that all departments are listed.
4. Show teacher name and mobile number .Use the number '07986 444 2266' if there is no number given.
5. Use the COALESCE function and a LEFT JOIN to print the teacher name and department name. Use the string 'None' where there is no department.
6. Use COUNT to show the number of teachers and the number of mobile phones.
7. Use COUNT and GROUP BY dept.name to show each department and the number of staff. Use a RIGHT JOIN to ensure that the Engineering department is listed.
8. Use CASE to show the name of each teacher followed by 'Sci' if the teacher is in dept 1 or 2 and 'Art' otherwise.
9. Use CASE to show the name of each teacher followed by 'Sci' if the teacher is in dept 1 or 2, show 'Art' if the teacher's dept is 3 and 'None' otherwise.
10. Obtained from the following result.

![alt text](https://github.com/Mahmud-Buet15/60-days-of-SQL/blob/main/Problem_set_09/dataset/question_2.png)



### RDBMS- MySQL
<br /> 

## Solutions

### **Q1.List the teachers who have NULL for their department.**
```sql
SELECT name
FROM teacher
WHERE dept IS NULL;
```



### **Q2.INNER JOIN misses the teachers with no department and the departments with no teacher. Use a different JOIN so that all teachers are listed.**
```sql
SELECT t.name,d.name AS dept
FROM teacher t LEFT JOIN dept d
ON t.dept=d.id;
```



### **Q3.Use a different JOIN so that all departments are listed.**
```sql
SELECT t.name,d.name AS  dept
FROM teacher t RIGHT JOIN dept d
ON t.dept=d.id;
```


### **Q4. Show teacher name and mobile number .Use the number '07986 444 2266' if there is no number given.**
```sql
SELECT name,COALESCE(mobile,'07986 444 2266') AS mobile
FROM teacher;
```


### **Q5.Use the COALESCE function and a LEFT JOIN to print the teacher name and department name. Use the string 'None' where there is no department.**
```sql
SELECT t.name,COALESCE(d.name,'None') AS  dept
FROM teacher t LEFT JOIN dept d
ON t.dept=d.id;
```


### **Q6.  Use COUNT to show the number of teachers and the number of mobile phones.**
```sql
SELECT COUNT(name) AS 'Number of teachers',COUNT(mobile) AS 'Number of mobiles'
FROM teacher;
```


### **Q7.  Use COUNT and GROUP BY dept.name to show each department and the number of staff. Use a RIGHT JOIN to ensure that the Engineering department is listed.**
```sql
SELECT d.name,COUNT(t.name) AS 'Number of staff'
FROM teacher t RIGHT JOIN dept d
ON t.dept=d.id
GROUP BY d.name;
```


### **Q8. Use CASE to show the name of each teacher followed by 'Sci' if the teacher is in dept 1 or 2 and 'Art' otherwise.**
```sql
SELECT t.name,
CASE
    WHEN d.id IN (1,2) THEN 'Sci'
    ELSE 'Art'
END AS 'group'
FROM teacher t LEFT JOIN dept d
ON t.dept=d.id;
```


### **Q9. Use CASE to show the name of each teacher followed by 'Sci' if the teacher is in dept 1 or 2, show 'Art' if the teacher's dept is 3 and 'None' otherwise.**
```sql
SELECT t.name,
CASE
    WHEN d.id IN (1,2) THEN 'Sci'
    WHEN d.id=3 THEN 'Art'
    ELSE 'None'
END AS 'group'
FROM teacher t LEFT JOIN dept d
ON t.dept=d.id;
```


### **Q10. Obtained from the following result.**
![alt text](https://github.com/Mahmud-Buet15/60-days-of-SQL/blob/main/Problem_set_09/dataset/question_2.png)
```sql
SELECT name, 
        CASE 
          WHEN dept IN (1) THEN 'Computing' 
          ELSE 'Other' 
        END AS dept
FROM teacher;
```
