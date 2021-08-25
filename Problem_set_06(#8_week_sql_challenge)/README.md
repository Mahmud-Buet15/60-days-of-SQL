# Problem Set 06 
# Case Study #1 - [Danny's Diner](https://8weeksqlchallenge.com/case-study-1/)
# Entity Relationship Diagram
![alt text](https://github.com/Mahmud-Buet15/60-days-of-SQL/blob/main/Problem_set_06(%238_week_sql_challenge)/dataset/schema.png)

Full Solution: [Notebook](https://github.com/Mahmud-Buet15/60-days-of-SQL/blob/main/Problem_set_06(%238_week_sql_challenge)/Problem_set_06.ipynb)


### QUERIES:
1.	What is the total amount each customer spent at the restaurant?
2.	How many days has each customer visited the restaurant?
3.	What was the first item from the menu purchased by each customer?
4.	What is the most purchased item on the menu and how many times was it purchased by all customers?
5.	Which item was the most popular for each customer?
6.	Which item was purchased first by the customer after they became a member?
7.	Which item was purchased just before the customer became a member?
8.	What is the total items and amount spent for each member before they became a member?
9.	If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
10.	In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?
11.
![alt text](https://github.com/Mahmud-Buet15/60-days-of-SQL/blob/main/Problem_set_06(%238_week_sql_challenge)/dataset/Question_2.png)

### RDBMS- MySQL

 <br /> 

## Solutions

### **Q1.What is the total amount each customer spent at the restaurant?**
```sql
SELECT customer_id,SUM(price) as "Total Spent"
FROM sales INNER JOIN menu
ON sales.product_id=menu.product_id
GROUP BY customer_id;
```



### **Q2.How many days has each customer visited the restaurant?**
```sql
SELECT customer_id,COUNT(order_date) as "Number of visit"
FROM sales
GROUP BY 1;
```



### **Q3. What was the first item from the menu purchased by each customer?**
```sql
SELECT customer_id,product_name 
FROM sales INNER JOIN menu
ON sales.product_id=menu.product_id
GROUP BY 1;
```


### **Q4. What is the most purchased item on the menu and how many times was it purchased by all customers?**
```sql
SELECT product_name as "Most Purchased Product",COUNT(customer_id) as "Total number of purchase"
FROM sales INNER JOIN menu
ON sales.product_id=menu.product_id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;

SELECT customer_id,COUNT(product_name) as "Number of Purchase" 
FROM sales INNER JOIN menu
ON sales.product_id=menu.product_id
WHERE product_name="ramen"
GROUP BY 1;
```


### **Q5. Which item was the most popular for each customer?**
```sql
SELECT Temp.customer_id,Temp.product_name
FROM (SELECT customer_id,product_name,COUNT(product_name) as val
      FROM sales INNER JOIN menu
      ON sales.product_id=menu.product_id
      GROUP BY 1,2
      ORDER BY val DESC) AS Temp
GROUP BY 1
ORDER BY 1
```
**Notes:** 1. Joining 2 tables. Adding 1 extra column which will contain number of purchase for each food. Then aliasing the whole table as "Temp".

 2. Extracting necessary information from "Temp".


### **Q6.  Which item was purchased first by the customer after they became a member?**
```sql
SELECT sales.customer_id,menu.product_name
FROM sales,members,menu
WHERE sales.customer_id=members.customer_id 
      AND sales.product_id=menu.product_id 
      AND sales.order_date>=members.join_date
GROUP BY 1
ORDER BY 1,sales.order_date;
```


### **Q7. Which item was purchased just before the customer became a member?**
```sql
SELECT sales.customer_id,menu.product_name
FROM sales,members,menu
WHERE sales.customer_id=members.customer_id 
      AND sales.product_id=menu.product_id 
      AND sales.order_date<members.join_date
GROUP BY 1
ORDER BY 1,sales.order_date DESC ;
```


### **Q8. What is the total items and amount spent for each member before they became a member?**
```sql
SELECT sales.customer_id,COUNT(menu.product_name) AS "Total Item",SUM(menu.price) AS "Total Cost"
FROM sales,members,menu
WHERE sales.customer_id=members.customer_id 
      AND sales.product_id=menu.product_id 
      AND sales.order_date<members.join_date
GROUP BY 1
ORDER BY 1;
```


### **Q9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?**
```sql
SELECT Temp.customer_id,SUM(Temp.point) as "Total Points"
FROM (SELECT customer_id,product_name,price,
                                          CASE
                                              WHEN Product_name="sushi" THEN price*20
                                              ELSE price*10
                                           END AS point
      FROM sales,menu
      WHERE sales.product_id=menu.product_id) AS Temp
GROUP BY 1;
```
**Notes:** 1. Joining 2 tables. Adding 1 extra column which will contain points. Then aliasing the whole table as "Temp".
           
  2. Extracting necessary information from "Temp".


### **Q10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?**
```sql
SELECT Temp.customer_id,SUM(Temp.points) AS "Total Points"
FROM (SELECT sales.customer_id,sales.order_date,members.join_date,DATE_ADD(join_date, INTERVAL 1 WEEK),menu.product_name,menu.price,
                        CASE
                            WHEN menu.product_name="sushi" THEN menu.price*20
                            WHEN order_date 
                                      BETWEEN members.join_date 
                                         AND DATE_ADD(join_date, INTERVAL 1 WEEK) 
                                           THEN menu.price*20
                            ELSE menu.price*10
                        END AS points
    FROM sales,members,menu
    WHERE sales.customer_id=members.customer_id 
          AND sales.product_id=menu.product_id
          AND order_date<'2021-02-01'           -- Calculating for dates before february
    ORDER BY 1,sales.order_date) AS Temp

GROUP BY 1
ORDER BY 1;
```
**Notes:**  1. Joining 3 tables. Adding 2 extra columns, one will contain dates after 1 week interval and another one will contain points. Then aliasing the whole table as                      "Temp".
           
2. Extracting necessary information from "Temp".


### **Q11.**
![alt text](https://github.com/Mahmud-Buet15/60-days-of-SQL/blob/main/Problem_set_06(%238_week_sql_challenge)/dataset/Question_2.png)
```sql
SELECT Temp.customer_id,Temp.order_date,menu.product_name,menu.price,
    CASE
        WHEN Temp.order_date>=Temp.join_date THEN "Y"
        ELSE "N"
    END AS member
FROM (SELECT sales.customer_id,sales.order_date,members.join_date,sales.product_id
    FROM sales LEFT JOIN members
    ON sales.customer_id=members.customer_id) AS Temp,menu
WHERE Temp.product_id=menu.product_id
ORDER BY 1,Temp.order_date,menu.price DESC;
```
**Notes:** 1. Joining two tables using LEFT JOIN and aliasing the table as "Temp".
          
2. Joing the third table with "Temp" and adding a column to it named "member"
