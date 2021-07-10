# Problem Set 07

# Entity Relationship Diagram
![alt text](https://github.com/Mahmud-Buet15/60-days-of-SQL/blob/main/Problem_set_07/dataset/schema.png)

Problem source: [SQLzoo](https://sqlzoo.net/wiki/The_JOIN_operation)

Full Solution: [Notebook](https://github.com/Mahmud-Buet15/60-days-of-SQL/blob/main/Problem_set_07/Problem_set_07.ipynb)


### QUERIES:
1.	Show the matchid and player name for all goals scored by Germany.
2.	Lars Bender's scored a goal in game 1012. What teams were playing in that match?
3.	Show the player, teamid, stadium and mdate for every German goal.
4.	Show the team1, team2 and player for every goal scored by a player called Mario.
5.	Show player, teamid, coach, gtime for all goals scored in the first 10 minutes.
6.	 List the dates of the matches and the name of the team in which 'Fernando Santos' was the team1 coach.
7.	List the player for every goal scored in a game where the stadium was 'National Stadium, Warsaw'.
8.	Show the name of all players who scored a goal against Germany.
9.	Show teamname and the total number of goals scored.
10.	Show the stadium and the number of goals scored in each stadium.
11.	For every match involving 'POL', show the matchid, date and the number of goals scored.
12.	For every match where 'GER' scored, show matchid, match date and the number of goals scored by 'GER'.	

13. List every match with the goals scored by each team as shown.Sort your result by mdate, matchid, team1 and team2.

![alt text](https://github.com/Mahmud-Buet15/60-days-of-SQL/blob/main/Problem_set_07/dataset/Question_2.png)



### RDBMS- MySQL

 <br /> 

## Solutions

### **Q1.Show the matchid and player name for all goals scored by Germany.**
```sql
SELECT matchid,player 
FROM goal 
WHERE teamid='GER';
```



### **Q2.Lars Bender's scored a goal in game 1012. What teams were playing in that match?**
```sql
SELECT Id,stadium,team1,team2
FROM game
WHERE id=1012
LIMIT 1;
```



### **Q3.Show the player, teamid, stadium and mdate for every German goal.**
```sql
SELECT player, teamid, stadium, mdate
FROM game JOIN goal ON game.Id=goal.matchid
WHERE teamid='GER';
```


### **Q4. Show the team1, team2 and player for every goal scored by a player called Mario.**
```sql
SELECT team1,team2,player
FROM game JOIN goal ON game.Id=goal.matchid
WHERE player LIKE 'Mario%';
```


### **Q5. Show player, teamid, coach, gtime for all goals scored in the first 10 minutes.**
```sql
SELECT player, teamid,coach, gtime
FROM goal JOIN eteam ON goal.teamid=eteam.id
WHERE gtime<=10;
```


### **Q6. List the dates of the matches and the name of the team in which 'Fernando Santos' was the team1 coach.**
```sql
SELECT mdate,teamname
FROM game JOIN eteam ON game.team1=eteam.id
WHERE coach='Fernando Santos';
```


### **Q7. List the player for every goal scored in a game where the stadium was 'National Stadium, Warsaw'.**
```sql
SELECT player
FROM game JOIN goal ON game.id=goal.matchid
WHERE stadium='National Stadium, Warsaw';
```


### **Q8. Show the name of all players who scored a goal against Germany.**
```sql
SELECT DISTINCT(player)
FROM game JOIN goal ON matchid =Id
WHERE (team1='GER' OR team2='GER') AND teamid!='GER';
```


### **Q9. Show teamname and the total number of goals scored.**
```sql
SELECT teamname,COUNT(gtime) as "Number of Goals"
FROM eteam JOIN goal ON eteam.id=goal.teamid
GROUP BY teamname
ORDER BY teamname;
```


### **Q10. Show the stadium and the number of goals scored in each stadium.**
```sql
SELECT stadium,COUNT(gtime) AS "Number of Goals"
FROM game JOIN goal ON game.id=goal.matchid
GROUP BY stadium
ORDER BY stadium;
```


### **Q11. For every match involving 'POL', show the matchid, date and the number of goals scored.**
```sql
SELECT matchid,mdate,COUNT(gtime) AS 'Number of Goals'
FROM game JOIN goal ON matchid = id 
WHERE (team1 = 'POL' OR team2 = 'POL')
GROUP BY matchid,mdate;
```


### **Q12. For every match where 'GER' scored, show matchid, match date and the number of goals scored by 'GER'.**
```sql
SELECT matchid,mdate,COUNT(gtime) AS 'Number of Goals'
FROM game JOIN goal ON matchid = id 
WHERE teamid='GER'
GROUP BY matchid,mdate;
```

### **Q13. List every match with the goals scored by each team as shown.Sort your result by mdate, matchid, team1 and team2.**
![alt text](https://github.com/Mahmud-Buet15/60-days-of-SQL/blob/main/Problem_set_07/dataset/Question_2.png)
```sql
SELECT mdate,team1,
SUM(CASE
   WHEN teamid=team1 THEN 1 ELSE 0
END) AS score1,team2,
SUM(CASE
   WHEN teamid=team2 THEN 1 ELSE 0
END) AS score2
FROM game JOIN goal ON matchid = id
GROUP BY mdate,matchid,team1,team2
ORDER BY mdate,matchid,team1,team2;
```



