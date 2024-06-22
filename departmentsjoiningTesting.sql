--

Use employees;

Drop Table if exists
	departments_dup;
Create Table
	departments_dup
(
	dept_no char(4) null,
	dept_name varchar(40) null
);
Insert Into departments_dup
(
	dept_no,
	dept_name
)
Select
	*
from
	departments;
Insert Into departments_dup (dept_name)
Values
	('Public Relations');
Delete From departments_dup

Where
	dept_no = 'd002';
Insert Into departments_dup(dept_no) 
Values ('d010'), ('d011');
--
DROP TABLE IF EXISTS dept_manager_dup;
CREATE TABLE dept_manager_dup (
  emp_no int(11) NOT NULL,
  dept_no char(4) NULL,
  from_date date NOT NULL,
  to_date date NULL
  );
INSERT INTO dept_manager_dup
select * from dept_manager;
INSERT INTO dept_manager_dup (emp_no, from_date)
VALUES 
(999904, '2017-01-01'),
(999905, '2017-01-01'),
(999906, '2017-01-01'),
(999907, '2017-01-01');
DELETE FROM dept_manager_dup
WHERE
    dept_no = 'd001';
--
Select
	*
From
	dept_manager_dup
Order by dept_no;
--
Select
	*
From
	departments_dup
Order by dept_no;
--
Select
	m.dept_no, m.emp_no, d.dept_name
From
	 dept_manager_dup m 
inner Join
	departments_dup d on m.dept_no = d.dept_no
Order by
	m.dept_no;
--
Select
	e.emp_no,
    e.first_name,
    e.last_name,
    dm.dept_no,
    e.hire_date
From 
	employees e
Join
	dept_manager dm on e.emp_no = dm.emp_no;
--
Select
	m.dept_no, m.emp_no, m.from_date, m.to_date, d.dept_name
From
	 dept_manager_dup m 
Join
	departments_dup d on m.dept_no = d.dept_no
Order by
	m.dept_no;
--
Insert Into dept_manager_dup
Values ('110228', 'd003', '1992-03-21', '9999-01-01');
Insert Into departments_dup
Values ('d009', 'Customer Service');
Select
	*
From
	dept_manager_dup
Order by
	dept_no asc;
Select
	*
From
	departments_dup
Order by
	dept_no asc;
--
Select
	m.dept_no, m.emp_no, d.dept_name
From
	 dept_manager_dup m 
Join
	departments_dup d on m.dept_no = d.dept_no
Group by m.emp_no, m.dept_no, d.dept_name -- Error -- 
Order by
	dept_no;
--
Delete From 
	dept_manager_dup
Where
	emp_no = '110228';
Delete From
	departments_dup
Where
	dept_no = 'd009';
Insert Into
	dept_manager_dup
Values ('110228', 'd003', '1992-03-21', '9999-01-01');
Insert Into
	departments_dup
Values
	('d009', 'Customer Service');
--
Select
	m.dept_no, m.emp_no, d.dept_name
From
	 dept_manager_dup m 
Left Join
	departments_dup d on m.dept_no = d.dept_no
Group by m.emp_no, m.dept_no, d.dept_name
Order by
	d.dept_no;
--
Select
	d.dept_no, m.emp_no, d.dept_name
From
	 departments_dup d
Left Outer Join -- interchangeable with Left Join --
	dept_manager_dup m on m.dept_no = d.dept_no
Order by
	d.dept_no;
--
Select
	d.dept_no, m.emp_no, d.dept_name
From
	 dept_manager_dup m
Left Outer Join -- interchangeable with Left Join --
	departments_dup d on m.dept_no = d.dept_no
Where dept_name is null
Order by
	d.dept_no;
--
Select
	e.emp_no, e.first_name, e.last_name, dm.dept_no, dm.from_date
From
	employees e
Left Join
	dept_manager dm on e.emp_no = dm.emp_no
Where
	e.last_name = 'Markovitch'
Order by dm.dept_no desc, e.emp_no;
--
Select
	d.dept_no, m.emp_no, d.dept_name
From
	 dept_manager_dup m
Right Join -- interchangeable with Left Join --
	departments_dup d on m.dept_no = d.dept_no
Order by
	d.dept_no;
--
Select
	d.dept_no, m.emp_no, d.dept_name
From
	 departments_dup d
Left Join -- Right Joins seldom applied, Matching Column = Linking Column--
	dept_manager_dup m on m.dept_no = d.dept_no
Order by
	d.dept_no;
--
Select
	m.dept_no, m.emp_no, d.dept_name
From
	 dept_manager_dup m
Inner Join -- Connection Points--
	departments_dup d on m.dept_no = d.dept_no
Order by
	m.dept_no;
--
Select
	m.dept_no, m.emp_no, d.dept_name
From
	 dept_manager_dup m,
     departments_dup d
Where -- Old Syntax --
	m.dept_no = d.dept_no
Order by
	m.dept_no;
--
Select -- Old Syntax --
	e.first_name, e.last_name, e.emp_no, m.dept_no, m.from_date
From
	 dept_manager_dup m,
     employees e
Where 
	m.emp_no = e.emp_no
Order by
	m.emp_no;
--
SELECT -- New Syntax --
    e.emp_no,
    e.first_name,
    e.last_name,
    dm.dept_no,
    e.hire_date
FROM
    employees e
JOIN
    dept_manager dm ON e.emp_no = dm.emp_no; 
--
-- Using Join and Where together --
Select
	e.emp_no, e.first_name, e.last_name, s.salary
From
	employees e
Join
	salaries s on e.emp_no = s.emp_no
Where
	s.salary > 145000;
--
Select
	e.emp_no, e.first_name, e.last_name, e.hire_date, t.title
From
	employees e
Join
	titles t on e.emp_no = t.emp_no
Where
	e.first_name = 'Margareta' and e.last_name = 'Markovitch';
--
-- Cross Join --
-- Cartesian product of two or more sets, useful in tables not well connected--
Select
	dm.*, d.*
From
	dept_manager dm
Cross Join
	departments d
Order By
	dm.emp_no, d.dept_no;
--
Select
	dm.*, d.*
From
	dept_manager dm,
	departments d
Order By
	dm.emp_no, d.dept_no;
--
Select
	dm.*, d.*
From
	dept_manager dm
Join -- Same as Cross Join --
	departments d
Order By
	dm.emp_no, d.dept_no;
--
Select
	dm.*, d.*
From
	dept_manager dm
Cross Join
	departments d
Where
	d.dept_no != dm.dept_no
Order By
	dm.emp_no, d.dept_no;
--
Select
	e.*, d.*
From
	departments d
Cross Join
	dept_manager dm
Join
	employees e on dm.emp_no = e.emp_no
Where
	d.dept_no != dm.dept_no
Order By
	dm.emp_no, d.dept_no;
--
Select
	dm.*, d.*
From
	departments d
Cross Join
	dept_manager dm
Where
	d.dept_no = 'd009'
Order By
	d.dept_name;
--
Select
	e.*, d.*
From
	employees e
Cross Join
	departments d
Where
	e.emp_no < 10011
Order By
	e.emp_no, d.dept_name;
--
Select
	e.gender, avg(s.salary) as average_salary
From
	employees e
Join
	salaries s on e.emp_no = s.emp_no
Group by gender;
--
-- Join more than two tables --
Select
	e.first_name,
    e.last_name,
    e.hire_date,
    m.from_date,
    d.dept_name
From
	employees e
Join -- Inner Join --
	dept_manager m on e.emp_no = m.emp_no
Join -- Inner Join --
	departments d on m.dept_no = d.dept_no;
--
Select
	e.first_name,
    e.last_name,
    e.hire_date,
    t.title,
    dm.from_date,
    d.dept_name
From
	employees e
Join -- Inner Join --
	titles t on e.emp_no = t.emp_no
Join -- Inner Join --
	dept_manager dm on t.emp_no = dm.emp_no
Join
	departments d on dm.dept_no = d.dept_no
Where t.title = 'Manager'
;
--
Select
	d.dept_no, d.dept_name, avg(salary) as average_salary
From
	departments d
Join
	dept_manager m on d.dept_no = m.dept_no
Join
	salaries s on m.emp_no = s.emp_no
Group by d.dept_name
Order by average_salary desc;
--
Select
	 e.gender, count(m.emp_no) as number_employees
From
	employees e 
Join
	dept_manager m on e.emp_no = m.emp_no	
Group by gender;
--
-- Difference between Union / Union All --
Drop Table if exists employees_dup;
Create Table employees_dup (
	emp_no int(11),
    birth_date date,
    first_name varchar(14),
    last_name varchar(16),
    gender enum('m', 'f'),
    hire_date date);

Insert into employees_dup
select
	e.*
From
	employees e
Limit 20;
--
Select
 *
From
	employees_dup;
--
Insert into employees_dup
Values 
	('10001', '1953-09-02', 'Georgi', 'Facello', 'M', '1986-06-26');
--
-- Union All select n columns from table 1, Union all select n columns, from table 2, Union only distinct, Union all gives duplicates--
Select
	e.emp_no,
    e.first_name,
    e.last_name,
    null as dept_no,
    null as from_date
From
	employees_dup e
Where
	e.emp_no = 10001
Union select
	null as emp_no,
    null as first_name,
    null as last_name,
	m.dept_no,
    m.from_date
From
	dept_manager m;
-- Optimize performance = union all --
SELECT
    *
FROM
(SELECT
	e.emp_no,
	e.first_name,
	e.last_name,
	NULL AS dept_no,
	NULL AS from_date
FROM
	employees e
WHERE
	last_name = 'Denis' UNION SELECT
	NULL AS emp_no,
	NULL AS first_name,
	NULL AS last_name,
	dm.dept_no,
	dm.from_date
FROM 
	dept_manager dm) as a
ORDER BY -a.emp_no DESC;
--
-- Subqueries = inner select/outer select --
Select  -- Outer Query --
	e.first_name,
	e.last_name
From
	employees e
Where
	e.emp_no in (   -- Inner Query --
			select dm.emp_no
	From
		dept_manager dm);
--
-- Innermost query active first --
--
Select  -- Outer Query --
	*
From
	dept_manager
Where
	emp_no in (   -- Inner Query --
			select emp_no
	From
		employees
	Where
		hire_date between '1990-01-01' and '1995-01-01');
-- Subqueries with exists-not exists inside where --
-- Exists boolean t/f --
Select
	e.first_name, e.last_name
From
	employees e
Where
	exists ( select *
		From dept_manager dm
		Where
			dm.emp_no = e.emp_no);
--
-- Exists / In --
Select
	e.first_name, e.last_name
From
	employees e
Where
	exists ( select *
		From dept_manager dm
		Where
			dm.emp_no = e.emp_no)
Order by emp_no;
-- subqueries can be more intensive, allow for better structuring of outer query --
-- SQL Structured Queried Language for a reason --
Select
	*
From
	employees e
Where
	exists ( select *
		From titles t
        Where
			t.emp_no = e.emp_no
		And title = 'Assistant Engineer' );
--
-- Subqueries nested in Select & From --
-- Two subsets --
-- Subsets connected through union --
-- Subset A Union subset B--
Select 
	A.*
From
	(Select
	e.emp_no as employee_ID,
	min(de.dept_no) as department_code,
	(Select
		emp_no
	From
		dept_manager
	Where
		emp_no = 110022) As manager_ID
From
	employees e
Join
	dept_emp de on e.emp_no = de.emp_no
Where
	e.emp_no <= 10020
Group by e.emp_no
Order by e.emp_no) As A
Union Select 
	B.*
From
	(Select
	e.emp_no as employee_ID,
	min(de.dept_no) as department_code,
	(Select
		emp_no
	From
		dept_manager
	Where
		emp_no = 110039) As manager_ID
From
	employees e
Join
	dept_emp de on e.emp_no = de.emp_no
Where
	e.emp_no > 10020
Group by e.emp_no
Order by e.emp_no
Limit 20) as B;
--
DROP TABLE IF EXISTS emp_manager;
CREATE TABLE emp_manager (
   emp_no INT(11) NOT NULL,
   dept_no CHAR(4) NULL,
   manager_no INT(11) NOT NULL
);
--
Insert Into emp_manager 	
Select 
	U.*
From
	(Select
		A.*
	From
		(Select
			e.emp_no as employee_ID,
			de.dept_no as department_code,
		(Select
			emp_no
		From
			dept_manager
		Where
			emp_no = 110022) As manager_ID
		From
			employees e
		Join
			dept_emp de on e.emp_no = de.emp_no
		Where
			e.emp_no <= 10020
Group by e.emp_no
Order by e.emp_no) As A Union Select 
	B.*
From
	(Select
	e.emp_no as employee_ID,
	min(de.dept_no) as department_code,
	(Select
		emp_no
	From
		dept_manager
	Where
		emp_no = 110039) As manager_ID
From
	employees e
Join
	dept_emp de on e.emp_no = de.emp_no
Where
	e.emp_no > 10020
Group by e.emp_no
Order by e.emp_no
Limit 20) as b Union Select
	C.*
From
	(Select
	e.emp_no as employee_ID,
	min(de.dept_no) as department_code,
	(Select
		emp_no
	From
		dept_manager
	Where
		emp_no = 110039) As manager_ID
From
	employees e
Join
	dept_emp de on e.emp_no = de.emp_no
Where
	e.emp_no = 110022
Group by e.emp_no) As c Union Select
	D.*
	From
		(Select
			e.emp_no as employee_ID,
			min(de.dept_no) as department_code,
		(Select
			emp_no
		From
			dept_manager
		Where
			emp_no = 110022) As manager_ID
		From
			employees e
		Join
			dept_emp de on e.emp_no = de.emp_no
		Where
			e.emp_no = 110039
Group by e.emp_no) as D) as U;

--
Select
	*
From 
	emp_manager;

-- Inner Join like a venn diagram, only what emcompasses both tables --
-- Left Join emcompasses what's in both tables, and info in left table --

-- drop table if exists employees_dup; --
-- Testing below --
drop table if exists salaries_dup;
create table salaries_dup (
	emp_no int(4),
    salary int(11),
    from_date date not null,
    to_date date null
);
Insert Into salaries_dup()
Select
	*
From
	salaries
Where
	to_date like ('%9999%');
Select
	*
From
	Salaries_dup;
--
Select
	sum(salary) as total_salary_paid
From
	salaries_dup;
--
Select
	sd.emp_no, e.first_name, e.last_name, sd.salary as current_salary_paid
From
	employees e
Join
	salaries_dup sd on e.emp_no = sd.emp_no;

Select
	emp_no, round((salary),2) as current_salary
From
	salaries_dup;
Select
	count(emp_no)
From
	Salaries_dup;
--
