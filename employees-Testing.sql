SELECT 
    first_name, last_name
FROM
    employees;
--
SELECT 
    *
FROM
    employees;
--
SELECT 
    dept_no
FROM
    departments;
--    
SELECT
	*
from 
	departments;
--
Select
	*
From employees
Where first_name = 'Denis';
--
SELECT 
    *
FROM
    employees
WHERE
    first_name = 'Elvis';
--
Select
	*
From 
	employees
Where
	first_name = 'Denis' and gender = 'm';
--
Select
	*
From
	employees
Where
	first_name = 'Kellie' and gender = 'F';
--
Select
	*
From
	employees
Where 
	first_name = 'Kellie' or first_name = 'Aruna';
--
Select
	*
From
	employees
Where
	last_name = 'denis' and (gender = 'm' or gender = 'f');
--
Select
	*
From
	employees
Where
	gender = 'f' and (first_name = 'Kellie' or first_name = 'Aruna');
--
Select
	*
From
	employees
Where
	first_name = 'Cathie'
		or first_name = 'Mark'
		or first_name = 'Nathan';
--
Select
	*
From
	employees
Where
	first_name not in ('Cathie', 'Mark', 'Nathan');
--
Select
	*
From
	employees
Where
	first_name in ('Denis', 'Elvis');
--
Select
	*
From
	employees
Where
	first_name not in ('John', 'Mark', 'Jacob');
--
Select
	*
From
	employees
Where
	first_name not like ('Mar_');
--
Select
	*
From
	employees
Where
	first_name like ('Mark%');
--
Select
	*
From
	employees
Where
	hire_date like ('%2000%');
--
Select
	*
From
	employees
Where
	emp_no like ('1000_');
--
Select
	*
From
	employees
Where
	first_name like ('%Jack%');
--
Select
	*
From
	employees
Where
	first_name not like ('%Jack%');
--
Select
	*
From
	employees
Where
	hire_date between '1990-01-01' and '2000-01-01';
--
Select
	*
From
	salaries
Where
	salary between '66000' and '70000';
--
Select
	*
From
	employees
Where
	emp_no not between '10004' and '10012';
--
Select
	*
From
	departments
Where
	dept_no between 'd003' and 'd006';
--
Select
	*
From
	employees
Where
	first_name is not null;
--
Select
	dept_name -- or * for more info --
From
	departments
Where
	dept_no is not null;
--
Select
	*
From
	employees
Where
	hire_date <= '1985-02-01';
--
Select
	*
From
	employees
Where
	gender = 'f' and hire_date > '2000-01-01';
--
Select
	*
From
	salaries
Where
	salary > '150000';
--
Select distinct
	gender
From
	employees
;
--
Select
	hire_date
From
	employees
;
--
SELECT 
    COUNT(Distinct first_name)
FROM
    employees
;
--
Select
	Count(*)
From
	salaries
where
	salary >= '100000';
--
Select
	*
From
	dept_manager
Order by emp_no desc;
--
Select
	*
From
	employees
Order by hire_date desc;
--
Select
	first_name, count(first_name)
From
	employees
Group By first_name  -- same variable as in select for group by --
Order By first_name; 
--
Select
	first_name, count(first_name) as names_count -- in order to clarify column name --
From
	employees
Group By first_name  -- same variable as in select for group by --
Order By first_name;
-- 
Select
	salary, count(emp_no) as emps_with_same_salary
From
	salaries
Where 
	salary > '80000'
Group By salary  -- same variable as in select for group by --
Order By salary asc; 
--
Select
	first_name, count(first_name) as names_count
From
	employees
Group By first_name  -- same variable as in select for group by --
Having count(first_name) > 250
Order By first_name; 
--
Select
	emp_no, avg(salary) as count_of_average_salary
From
	salaries
Where
	salary > 120000
Group By emp_no
Order By emp_no;
--
Select
	emp_no,avg(salary)
From
	salaries
group by emp_no
Having avg(salary) > 120000;
--
Select
	first_name, count(first_name) as names_count
From
	employees
Where hire_date > '1999-01-01'
Group by first_name
having count(first_name) < 200
order by first_name desc;
--
SELECT 
    emp_no
FROM
    dept_emp
WHERE
    from_date > '2000-01-01'
GROUP BY emp_no
HAVING COUNT(from_date) > 1
ORDER BY emp_no DESC;
--
Select
	*
From 
	salaries
Order by emp_no desc
Limit 10;
--
Select
	*
From
	dept_emp
Limit 100;
--
Select
	*
From
	salaries
Order by salary desc
Limit 10;
--
Select
	count(*)
From
	salaries;
--
Select
	count(distinct dept_no)
From
	dept_emp;
--
Select
	sum(salary)
From
	salaries
Where 
	from_date > '1997-01-01';
--
Select
	max(salary)
From
	salaries;
--
Select
	min(emp_no) -- max(emp_no) for max number--
From
	employees;
--
Select
	avg(salary)
From
	salaries;
--
Select
	avg(salary)
From
	salaries
Where 
	from_date > '1997-01-01';
--
Select
	round(avg(salary), 2)
From
	salaries;
--
Select
	round(avg(salary),2)
From
	salaries
Where 
	from_date > '1997-01-01';
