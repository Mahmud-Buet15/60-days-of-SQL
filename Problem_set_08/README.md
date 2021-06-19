# Problem Set 08

# Entity Relationship Diagram
![alt text](https://github.com/Mahmud-Buet15/60-days-of-SQL/blob/main/Problem_set_08/dataset/schema.png)


## More details about the tables
![alt text](https://github.com/Mahmud-Buet15/60-days-of-SQL/blob/main/Problem_set_08/dataset/details_1.png)
![alt text](https://github.com/Mahmud-Buet15/60-days-of-SQL/blob/main/Problem_set_08/dataset/details_2.png)
![alt text](https://github.com/Mahmud-Buet15/60-days-of-SQL/blob/main/Problem_set_08/dataset/details_3.png)

### QUERIES:
1.	List the films where the yr is 1962
2.	When was Citizen Kane released?
3.	List all of the Star Trek movies, include the id, title and yr. Order results by year.
4.	What id number does the actor 'Glenn Close' have?
5.	What is the id of the film 'Casablanca'
6.	Obtain the cast list for 'Casablanca' (The cast list is the names of the actors who were in the movie.)
7.	Obtain the cast list for the film 'Alien'
8.	List the films in which 'Harrison Ford' has appeared
9.	List the films where 'Harrison Ford' has appeared - but not in the starring role.  [Note: the ord field of casting gives the position of the actor. If ord=1 then this actor is in the starring role]
10.	List the films together with the leading star for all 1962 films.
11.	Which were the busiest years for 'Rock Hudson', show the year and the number of movies he made each year for any year in which he made more than 2 movies.
12.	List the film title and the leading actor for all of the films 'Julie Andrews' played in.
13.	Obtain a list, in alphabetical order, of actors who've had at least 15 starring roles.
14.	List the films released in the year 1978 ordered by the number of actors in the cast, then by title.
15.	List all the people who have worked with 'Art Garfunkel'.



### RDBMS- MySQL


 <br /> 

## Solutions

### **Q1. List the films where the yr is 1962**
```sql
SELECT id, title
FROM movie
WHERE yr=1962;
```



### **Q2. When was Citizen Kane released?**
```sql
SELECT yr 
FROM movie
WHERE title='Citizen Kane';
```



### **Q3. List all of the Star Trek movies, include the id, title and yr. Order results by year.**
```sql
SELECT id,title,yr
FROM movie
WHERE title LIKE '%Star Trek%'
ORDER BY yr;
```


### **Q4. What id number does the actor 'Glenn Close' have?**
```sql
SELECT id 
FROM actor
WHERE name='Glenn Close';
```


### **Q5. What is the id of the film 'Casablanca'**
```sql
SELECT id 
FROM movie
WHERE title='Casablanca';
```


### **Q6. Obtain the cast list for 'Casablanca' (The cast list is the names of the actors who were in the movie.)**
```sql
SELECT name
FROM casting INNER JOIN actor
ON casting.actorid=actor.id
WHERE movieid=(SELECT id 
			   FROM movie
			   WHERE title='Casablanca');
```


### **Q7. Obtain the cast list for the film 'Alien'**
```sql
SELECT name
FROM movie m,casting c,actor a
WHERE m.id=c.movieid 
     AND c.actorid=a.id
     AND m.title=(SELECT title
                  FROM movie
                  WHERE title='Alien');
```


### **Q8. List the films in which 'Harrison Ford' has appeared**
```sql
SELECT title
FROM movie m,casting c,actor a
WHERE m.id=c.movieid 
     AND c.actorid=a.id
     AND a.name='Harrison Ford';
```


### **Q9. List the films where 'Harrison Ford' has appeared - but not in the starring role.  [Note: the ord field of casting gives the position of the actor. If ord=1 then this actor is in the starring role]**
```sql
SELECT title
FROM movie m,casting c,actor a
WHERE m.id=c.movieid 
     AND c.actorid=a.id
     AND a.name='Harrison Ford'
     AND c.ord!=1;
```



### **Q10. List the films together with the leading star for all 1962 films.**
```sql
SELECT title,name
FROM movie m,casting c,actor a
WHERE m.id=c.movieid 
     AND c.actorid=a.id
     AND m.yr=1962
     AND c.ord=1;
```



### **Q11. Which were the busiest years for 'Rock Hudson', show the year and the number of movies he made each year for any year in which he made more than 2 movies.**
```sql
SELECT yr,COUNT(title) AS "Number of Movies" 
FROM movie JOIN casting ON movie.id=movieid
        JOIN actor   ON actorid=actor.id
WHERE name='Rock Hudson'
GROUP BY yr
HAVING COUNT(title) > 2;
```



### **Q12. List the film title and the leading actor for all of the films 'Julie Andrews' played in.**
```sql
SELECT title,name
FROM movie m,casting c,actor a
WHERE m.id=c.movieid 
     AND c.actorid=a.id
     AND m.Id IN (SELECT movieid FROM casting
                  WHERE actorid IN (SELECT id FROM actor
                                    WHERE name='Julie Andrews'))
     AND c.ord=1;
```



### **Q13. Obtain a list, in alphabetical order, of actors who've had at least 15 starring roles.**
```sql
SELECT a.name
FROM casting c,actor a
WHERE c.actorid=a.id
      AND c.ord=1
GROUP BY a.name
HAVING COUNT(*)>=15
ORDER BY a.name;
```



### **Q14. List the films released in the year 1978 ordered by the number of actors in the cast, then by title.**
```sql
SELECT title,COUNT(actorid) AS "Number of Actors"
FROM movie m,casting c
WHERE m.id=c.movieid
      AND m.yr=1978
GROUP BY title
ORDER BY COUNT(actorid) DESC,title;
```



### **Q15. List all the people who have worked with 'Art Garfunkel'.**
```sql
SELECT name
FROM movie m,casting c,actor a
WHERE m.id=c.movieid 
     AND c.actorid=a.id
     AND m.id IN (SELECT movieid
                  FROM casting
                  WHERE actorid=(SELECT id
                                 FROM actor
                                 WHERE name='Art Garfunkel'))
     AND name!='Art Garfunkel';
```
