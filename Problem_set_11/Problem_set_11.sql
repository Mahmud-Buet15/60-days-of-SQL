USE employees;
SET autocommit=0; -- Otherwise each executed line will be committed automatically. And we don't want that.

-- 01. Find the average salary of the male and female employees in each department.

SELECT * FROM employees;
SELECT dept_name,gender,AVG(salary) AS average_salary
FROM dept_emp de 
JOIN employees e ON de.emp_no=e.emp_no
JOIN salaries s ON de.emp_no=s.emp_no
JOIN departments d ON de.dept_no=d.dept_no
GROUP BY dept_name,gender
ORDER BY dept_name
;

-- 02. Find the lowest department number encountered in the 'dept_emp' table. Then, find the highest department number.

SELECT MIN(dept_no)
FROM dept_emp
;

SELECT MAX(dept_no)
FROM dept_emp;


-- 03 . Obtain a table containing the following three fields for all individuals whose employee number is not greater than 10040

SELECT a.emp_no,a.dept_no,
       CASE
         WHEN a.emp_no<= 10020 THEN '110022'
         WHEN a.emp_no BETWEEN 10021 AND 10040 THEN '110039'
	   END AS manager
FROM (SELECT e.emp_no,MIN(dept_no) AS dept_no
		FROM employees e
		JOIN dept_emp de ON e.emp_no=de.emp_no
		GROUP BY e.emp_no) a
WHERE a.emp_no<=10040
;

-- 04. Retrieve a list of all employees that have been hired in 2000.

SELECT emp_no
FROM employees
WHERE YEAR(hire_date)=2000
;

-- 05. Retrieve a list of all employees from the ‘titles’ table who are engineers.
-- Repeat the exercise, this time retrieving a list of all employees from the ‘titles’ table who are senior engineers.
-- After LIKE, you could indicate what you are looking for with or without using parentheses.
-- Both options are correct and will deliver the same output. We think using parentheses is better for legibility and that’s why it is the first option we’ve suggested.

SELECT emp_no 
FROM titles
WHERE title LIKE ("%Engineer")
;
SELECT emp_no
FROM titles
WHERE title LIKE ("%Senior Engineer%")
;

-- 06. Create a procedure that asks you to insert an employee number and that will obtain an output containing the same number,
-- as well as the number and name of the last department the employee has worked in.
-- Finally, call the procedure for employee number 10010.
-- If you've worked correctly, you should see that employee number 10010 has worked for department number 6 - "Quality Management".


DELIMITER $$
CREATE PROCEDURE get_dept(IN p_emp_no INT)
BEGIN 
WITH CTE 
AS
	(SELECT e.emp_no,MAX(de.from_date) AS date
	FROM employees e
	JOIN dept_emp de ON e.emp_no=de.emp_no
	JOIN departments d ON de.dept_no=d.dept_no
	WHERE e.emp_no=p_emp_no                   -- using the input variable
    GROUP BY e.emp_no)
    
SELECT de.emp_no,de.dept_no,d.dept_name
FROM dept_emp de
JOIN departments d ON de.dept_no=d.dept_no
WHERE de.emp_no=(SELECT emp_no FROM CTE)
AND de.from_date=(SELECT date FROM CTE);
END $$
DELIMITER ;

CALL employees.get_dept(10010);


-- 07. How many contracts have been registered in the ‘salaries’ table with duration of more than one year and of value higher than or equal to $100,000?
-- Hint: You may wish to compare the difference between the start and end date of the salaries contracts.

SELECT COUNT(*) AS  number_of_contracts
FROM salaries
WHERE DATEDIFF(to_date,from_date)>365  -- getting difference between two dates
AND salary>=100000
;



-- 08. Create a trigger that checks if the hire date of an employee is higher than the current date. If true, set this date to be the current date. Format the output appropriately (YY-MM-DD).
-- Extra challenge: You may try to declare a new variable called 'today' which stores today's data, and then use it in your trigger!
-- After creating the trigger, execute the following code to see if it's working properly.

DROP TRIGGER IF EXISTS trig_hire_date;

DELIMITER $$
CREATE TRIGGER trig_hire_date
BEFORE INSERT ON employees
FOR EACH ROW
BEGIN 
    DECLARE today date;
    SELECT date_format(sysdate(), '%Y-%m-%d') INTO today;   -- storing today's date
 
	IF NEW.hire_date > today THEN
		SET NEW.hire_date = today;
	END IF;
END $$

DELIMITER ;

COMMIT;   -- Before checking trigger, we must commit so that we can go back to previous situation if anything goes wrong

INSERT employees VALUES ('999904', '1970-01-31', 'John', 'Johnson', 'M', '2025-01-01');  

SELECT 
    *
FROM
    employees
ORDER BY emp_no DESC;

ROLLBACK; -- Going back to previous checkpoint






-- 09. Define a function that retrieves the largest contract salary value of an employee. Apply it to employee number 11356.
-- In addition, what is the lowest contract salary value of the same employee? You may want to create a new function that to obtain the result.
 


-- function for highest salary
DROP FUNCTION IF EXISTS f_largest_contract_salary;

DELIMITER $$

CREATE FUNCTION f_largest_contract_salary(i_emp_no INTEGER) RETURNS INTEGER
DETERMINISTIC
BEGIN
  DECLARE v_highest_sal INTEGER;  -- declaring the variable
  
SELECT MAX(salary) 
INTO v_highest_sal      -- storing the result into the variable
FROM salaries
WHERE emp_no=i_emp_no;
RETURN v_highest_sal;   -- returning the variable
END $$

DELIMITER ;

-- calling function
SELECT f_largest_contract_salary(11356);

-- function for lowest salary

  DROP FUNCTION IF EXISTS f_lowest_contract_salary;

DELIMITER $$

CREATE FUNCTION f_lowest_contract_salary(i_emp_no INTEGER) RETURNS INTEGER
DETERMINISTIC
BEGIN
  DECLARE v_lowest_sal INTEGER;  -- declaring the variable
  
SELECT MIN(salary) 
INTO v_lowest_sal
FROM salaries
WHERE emp_no=i_emp_no;
RETURN v_lowest_sal;
END $$

DELIMITER ;

-- calling function
SELECT f_lowest_contract_salary(11356);



-- 10. Based on the previous exercise, you can now try to create a third function that also accepts a second parameter. Let this parameter be a character sequence. 
-- Evaluate if its value is 'min' or 'max' and based on that retrieve either the lowest or the highest salary, respectively (using the same logic and code structure from Exercise 9). 
-- If the inserted value is any string value different from ‘min’ or ‘max’, let the function return the difference between the highest and the lowest salary of that employee.


-- modified function for salary

DROP FUNCTION IF EXISTS f_salary_mod;

DELIMITER $$

CREATE FUNCTION f_salary_mod(i_emp_no INTEGER,i_char VARCHAR(10)) RETURNS INTEGER
DETERMINISTIC
BEGIN
  DECLARE v_salary_info INTEGER;
  SELECT CASE
            WHEN i_char='max' THEN MAX(salary)
            WHEN i_char='min' THEN MIN(salary)
            ELSE MAX(salary)-MIN(salary)
		 END AS salary_info
  INTO v_salary_info
  FROM salaries
  WHERE emp_no=i_emp_no;
  RETURN v_salary_info;
 
END $$

DELIMITER ;


-- calling function
SELECT f_salary_mod(11356,'max');
SELECT f_salary_mod(11356,'min');
SELECT f_salary_mod(11356,'something');


