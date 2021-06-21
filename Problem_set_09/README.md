# Problem Set 09

# Entity Relationship Diagram
![alt text](https://github.com/Mahmud-Buet15/60-days-of-SQL/blob/main/Problem_set_09/dataset/schema.png)

Note: **teacher.dept** and **dept.id** are matching key columns.

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
