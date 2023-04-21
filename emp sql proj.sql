create database project;
create database employee;
use project;
use employee;


select EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT
from emp_record_table;

## 1) Write a query to fetch EMP_ID, FIRST_NAME, LAST_NAME, GENDER, and DEPARTMENT from the employee record table, and make a list of employees and details of their department
SELECT emp_id, first_name, last_name, gender, dept 
FROM emp_record_table ORDER BY emp_id ASC;

## 2) Write a query to fetch EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPARTMENT, and EMP_RATING if the EMP_RATING is Less than 2
SELECT emp_id, first_name, last_name, gender, dept, emp_rating 
from emp_record_table WHERE emp_rating < 2;

## Greater than 2
select emp_id, first_name, last_name, gender, dept, emp_rating 
from emp_record_table where emp_rating > 4;

## Between 2 & 4
select emp_id, first_name, last_name, gender, dept, emp_rating 
from emp_record_table where emp_rating > 2 and emp_rating < 4;

## 3) Write a query to concatenate the FIRST_NAME and the LAST_NAME of employees in the Finance department from the employee table and then give the resultant column alias as NAME
SELECT concat(first_name, ' ', last_name) AS NAME 
FROM emp_record_table WHERE dept = 'Finance';


ALTER TABLE `emp_record_table` CHANGE `MANAGER ID` `manager_id` VARCHAR(40);

## 5) Write a query to list down all the employees from the healthcare and finance departments using union. Take data from the employee record table
SELECT * FROM emp_record_table WHERE dept = 'healthcare'
UNION
SELECT * FROM emp_record_table WHERE dept = 'finance';

## 6) Write a query to list down employee details such as EMP_ID, FIRST_NAME, LAST_NAME, ROLE, DEPARTMENT, and EMP_RATING grouped by dept
select EMP_ID, FIRST_NAME, LAST_NAME, ROLE, DEPT, EMP_RATING
from emp_record_table
group by dept;

## 7) Write a query to list down all the employees from the healthcare and finance domain using union.
select * from emp_record_table where dept = 'healthcare'
union
select * from emp_record_table where dept = 'finance';

## 8) Write a query to list down employee details such as EMP_ID, FIRST_NAME, LAST_NAME, ROLE, DEPARTMENT, and EMP_RATING grouped by dept. 
# Also include the respective employee rating along with the max emp rating for the department.
select EMP_ID,FIRST_NAME,LAST_NAME,EXP,dept,rank() over(order by EXP desc) as 'RANK' 
from emp_record_table
group by DEPT ;

## 9) Write a query to calculate the minimum and the maximum salary of the employees in each role
select EMP_ID,ROLE,salary,min(SALARY),max(SALARY)
from emp_record_table
group by role;

## 10)Write a query to create a view that displays employees in various countries whose salary is more than six thousand.
create view EMP as select emp_id,first_name,last_name,country,salary 
from emp_record_table
where salary > 6000;

select * from EMP;

## 11)Write a nested query to find employees with experience of more than ten years.
SELECT * FROM (SELECT * FROM emp_record_table WHERE exp>10) as Emp;

## 12)Write a query to create a stored procedure to retrieve the details of the employees whose experience is more than three years.
delimiter $$
create procedure employee()
begin
select * from emp_record_table where exp > 3;
end $$
delimiter ;

call employee();

## 13) Create an index to improve the cost and performance of the query to find the employee whose FIRST_NAME is ‘Eric’ in the employee table after checking the execution plan.
CREATE INDEX FirstName ON emp_record_table (FIRST_NAME(10));

show indexes from emp_record_table;

## 14)Write a query to calculate the bonus for all the employees, based on their ratings and salaries (Use the formula: 5% of salary * employee rating).
select EMP_ID,first_name,last_name,role,dept,salary,emp_rating,exp, ((0.05*salary) * (emp_rating)) as bonus 
from emp_record_table
ORDER BY emp_id ASC;

## 15) Write a query to calculate the average salary distribution based on the continent and country.
select country,avg(salary)
from emp_record_table
group by country;

select continent,avg(salary)
from emp_record_table
group by continent;