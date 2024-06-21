-- My SQL Window functions, advanced tool for calc of every record in data set --
-- Using other records associated with specified one from table, record is current row --
-- Window is other records which function evaluation is performed --
-- Similar but not identical to aggregate functions --
-- two main types of window functions --
-- Aggregate and non-aggregate --
-- Non-Aggregate; Ranking/Value Window functions --
-- Row_Number() --
-- Over clause -> Window specification --
-- none = empty over clause --
-- Partition by -> organized into partitions --
-- can be like ranking --
-- Partioning != data partioning, can be data management, data storage, programming, etc --
-- containing order by -> arranges values in desc/asc order --

Use employees;
--
Select
	emp_no,
    salary
From
	salaries;
--
Select
	emp_no,
    salary,
    Row_Number() over (partition by emp_no) as row_num
From
	salaries;
--
Select
	emp_no,
    salary,
    Row_Number() over (partition by emp_no) as row_num
From
	salaries;
--
Select
	emp_no,
    salary,
    Row_Number() over (partition by emp_no order by salary desc) as row_num
From
	salaries;
-- Limit 10 --; -- quick check --
--
Select
	emp_no,
    dept_no,
    Row_Number() over (order by emp_no asc) as row_num
From
	dept_manager;
--
Select
	emp_no,
    first_name,
    last_name,
    Row_Number() over (partition by first_name order by last_name asc) as row_num
From
	employees;
--
-- Can use several window functions in query --
-- Example --
Select
	emp_no,
    salary,
    -- Row_Number() over () as row_num1,
    Row_Number() over (partition by emp_no) as row_num2,
    Row_Number() over (partition by emp_no order by salary desc) as row_num3
    -- Row_Number() over (order by salary desc) as row_num4
From
	salaries
Order by emp_no, salary;
--
-- #1 --
Select
	dm.emp_no,
    salary,
    Row_Number() over () as row_num1,
    Row_Number() over (partition by emp_no order by salary asc) as row_num2
From
	dept_manager dm
Join
	salaries s on dm.emp_no = s.emp_no
	
Order by row_num1, emp_no, salary asc;
-- #2 --
Select
	dm.emp_no,
    salary,
    Row_Number() over (partition by emp_no order by salary asc) as row_num1,
    Row_Number() over (partition by emp_no order by salary desc) as row_num2
From
	dept_manager dm
Join
	salaries s on dm.emp_no = s.emp_no
	
Order by salary asc;
-- 
Select
	emp_no,
    salary,
    Row_Number() over test as row_num
From
	salaries
Window test as (partition by emp_no order by salary desc);
-- Window alias as () --
-- Window clause can be redundent --
-- Best practice, when query employs several window function, --
-- Or referring to same window specification multiple times in query --
-- Distiction between window name and window function name --
--
Select
	emp_no,
    first_name,
    Row_Number() over row_num as row_number_employee
From
	employees
Window row_num as (partition by first_name order by emp_no asc);
--
-- Partition By Clause vs Group By Clause --
-- Group by reduces records returned --
-- Partition affects how result will be obtained --
-- Partition preserves records amount --
-- Partitions unlike group by can only be used within contect of apply window functions --
--
-- First method --
Select
	a.emp_no,
	max(salary) as max_salary 
    from (
		Select
			emp_no, salary, row_number() over test as row_num
		From
			salaries
		Window test as (Partition by emp_no order by salary desc)) a
	Group by emp_no;
-- Second Method --
Select
	a.emp_no,
	max(salary) as max_salary 
    from (
		Select
			emp_no, salary, row_number() over (Partition by emp_no order by salary desc) 
            as row_num
		From
			salaries) a
	Group by emp_no;
-- Identical results --
-- Another method --
Select
	a.emp_no,
	a.salary as max_salary
    from (
		Select
			emp_no, salary, row_number() over test as row_num
		From
			salaries
		Window test as (Partition by emp_no order by salary desc)) a
Where row_num = 1; -- or 2, 3, etc, 1 gets the highest salary of employee --
--
-- With window specification/keyword --
Select
    a.emp_no,
	a.salary as min_salary
    from (
		Select -- Subquery --
			emp_no, salary, row_number() over test as row_num
		From
			salaries
		Window test as (Partition by emp_no order by salary asc)) a
Where a.row_num = 1;
--
-- With window specification in field list --
Select
    a.emp_no,
	min(salary) as min_salary 
    from (
		Select -- subquery --
			emp_no, salary, row_number() over (Partition by emp_no order by salary asc) 
            as row_num
		From
			salaries) a
	Group by emp_no;
--
-- Without window function, using an aggregate function and subquery --
Select
	a.emp_no,
    min(salary) as min_salary
From -- Subquery below --
	(Select
		emp_no,
		salary
			From salaries) a
Group by
	emp_no;
--
-- Window keyword, without group by clause in outer query, using subquery --
Select
    a.emp_no,
	a.salary as min_salary
    from ( -- Subquery below --
		Select
			emp_no, salary, row_number() over test as row_num
		From
			salaries
		Window test as (Partition by emp_no order by salary asc)) a
Where a.row_num = 1;    
--
-- Finding second lowest salary, without group by and with window keyword --
Select
    a.emp_no,
	a.salary as min_salary
    from (
		Select
			emp_no, salary, row_number() over test as row_num
		From
			salaries
		Window test as (Partition by emp_no order by salary asc)) a
Where a.row_num = 2;   
--
-- Rank and dense rank testing below --
Select Distinct
	emp_no, salary, row_number() over test as row_num
From
	salaries
Where emp_no = 10001
Window test as (Partition by emp_no order by salary desc);
--
Select
	emp_no, (count(salary) - count(distinct salary)) as diff_salary
From
	salaries
group by
	emp_no
Having 
	diff_salary > 0
order by 
	emp_no;
--
-- Rank () --
Select
	emp_no, salary, rank() over test as rank_num
From
	salaries
Where emp_no = 11839
Window test as (Partition by emp_no order by salary desc);	
-- Rank() focuses on # of values in input --
-- dense_rank() ranking of values itself --
-- Dense_Rank() --
Select
	emp_no, salary, dense_rank() over test as rank_num
From
	salaries
Where emp_no = 11839
Window test as (Partition by emp_no order by salary desc);
-- Window Function in SQL --
-- All require use of over clause --
-- Rank values provided assigned sequentially --
-- First rank = integer 1, subsequent rank values grow incrementally by 1, --
-- except on potential duplicate records --
-- Rank() / Dense_Rank() useful when applied on ordered partitions, --
-- or = partitions defined by use of order by clauses --
-- Rank() / Dense_Rank() useful for order-sensitive types, where order by --
-- is more more meaningful
-- Row_Number() non-order sensitive, not necessarily needing order by --
-- Rank()/Dense_Rank() examples --
Select
	emp_no, salary, row_number() over test as row_num 
From
	salaries
Where emp_no = 10560
Window test as (Partition by emp_no order by salary desc);
--
Select
	dm.emp_no,
    count(salary) as number_salary_contracts
From
	dept_manager dm
Join
	salaries s on dm.emp_no = s.emp_no
Group by emp_no
Order by emp_no;
--
Select
	emp_no, salary, rank() over test as rank_num
From
	salaries
Where emp_no = 10560
Window test as (Partition by emp_no order by salary desc);
--
Select
	emp_no, salary, dense_rank() over test as rank_num
From
	salaries
Where emp_no = 10560
Window test as (Partition by emp_no order by salary desc);
--
-- Window functions and joins together --
Select
	d.dept_no,
    d.dept_name,
    dm.emp_no,
    rank() over w as department_salary_rank,
    s.salary,
    s.from_date as salary_from_date,
    s.to_date as salary_to_date,
    dm.from_date as dept_manager_from_date,
    dm.to_date as dept_manager_to_date
	from
		dept_manager dm
			join
				salaries s on s.emp_no = dm.emp_no
			join
				departments d on d.dept_no = dm.dept_no
Window w as (partition by dm.dept_no order by s.salary desc);
-- Results set has errors, need two conditions to fix. --
-- need Between cases to specify when employee was manager in specific department --
Select
	d.dept_no,
    d.dept_name,
    dm.emp_no,
    rank() over w as department_salary_rank,
    s.salary,
    s.from_date as salary_from_date,
    s.to_date as salary_to_date,
    dm.from_date as dept_manager_from_date,
    dm.to_date as dept_manager_to_date
	from
		dept_manager dm
			join
				salaries s on s.emp_no = dm.emp_no
				and
                s.from_date between dm.from_date and dm.to_date
                and
                s.to_date between dm.from_date and dm.to_date
			join
				departments d on d.dept_no = dm.dept_no
Window w as (partition by dm.dept_no order by s.salary desc);
--
-- Window Functions/Joins together example 1 --
Select
	e.emp_no, rank() over test as employee_salary_rank, s.salary 
From
	employees e
Join
	salaries s on s.emp_no = e.emp_no
Where e.emp_no between 10500 and 10600
Window test as (Partition by emp_no order by s.salary desc);
-- 
-- Example 2 --
Select
	e.emp_no, 
    dense_rank() over test as employee_salary_rank, 
    s.salary,
    e.hire_date,
    s.from_date,
    (year(s.from_date) - year(e.hire_date)) as Years_from_start
From
	employees e
Join
	salaries s on s.emp_no = e.emp_no
and
	year(s.from_date) - year(e.hire_date) >= 5
Where e.emp_no between 10500 and 10600
Window test as (Partition by emp_no order by s.salary desc);
--
-- Lag() and Lead() --
-- Value Window functions, return value in DB --
-- Lag() -> Returns value from specified field of record that precedes current row--
-- i.e., lags the current value --
-- Example --
Select
	emp_no,
    salary as current_salary,
    lag(salary) over test as previous_salary
From 
	salaries
Where emp_no = 10001
Window test as (order by salary);
--
-- Lead() -> Leads current value -- 
--
Select
	emp_no,
    salary as current_salary,
    lag(salary) over test as previous_salary,
    lead(salary) over test as next_salary,
    salary - lag(salary) over test as diff_salary_current_previous,
	Lead(salary) over test - salary as diff_salary_next_current
From 
	salaries
Where emp_no = 10001
Window test as (order by salary);
--
-- Lag()/Lead() Examples --
Select
	emp_no,
    salary as current_salary,
    lag(salary) over test as previous_salary,
    lead(salary) over test as next_salary,
    salary - lag(salary) over test as diff_salary_current_previous,
	Lead(salary) over test - salary as diff_salary_next_current
From 
	salaries
Where 
	emp_no between 10500 and 10600
and
	salary > 80000
Window test as (partition by emp_no order by salary);
--
Select
	emp_no,
    salary as current_salary,
    lag(salary) over test as previous_salary,
    lag((salary),2) over test as previous_to_previous_salary,
    lead(salary) over test as next_salary,
	lead((salary),2) over test as after_next_salary
From 
	salaries
Where 
	salary > 80000
Window test as (partition by emp_no order by salary)
Limit 1000;
--
-- Aggregate functions within context of window functions --
-- Aggregate window functions, like sum()/avg() --
-- Groups vs data partitions --
-- Group by vs over/window/partition by --
-- Example --
select sysdate();


Select
	emp_no, salary, from_date, to_date
From
	salaries
Where
	to_date > sysdate();
--
-- Below will return error code 1055 as only_full_group_by mode is not met --
Select
	emp_no, salary, max(from_date), to_date -- max() to get employee's latest contract --
From
	salaries
Where
	to_date > sysdate()
Group by emp_no;
-- Will need to use subquery of larger query, then relate it to rest of salaries table --
Select
	s1.emp_no, s.salary, s.from_date, s.to_date
From
	salaries s
Join
	(select
		emp_no, max(from_date) as from_date
	From
		salaries
	Group by emp_no) s1 on s.emp_no = s1.emp_no
Where
	s.to_date > sysdate()
    and
		s.from_date = s1.from_date;
--
-- Another example, query returning employee number, salary value,
-- start and end dates of first ever contracts signed by each employee --
Select
	s1.emp_no, s.salary, s.from_date, s.to_date
From
	salaries s
Join
	(select
		emp_no, min(from_date) as from_date
	From
		salaries
	Group by emp_no) s1 on s.emp_no = s1.emp_no
-- Where
	-- s.to_date > s.from_date -- not really neccessary but ensures no contract that was signed and ended on same day --
    Where					   -- However pitfall would be that if employee changes department it would not specify such contract changes --
		s.from_date = s1.from_date;  -- Salary avg of department would also be affected --
--
--
Select
	de.emp_no, de.dept_no, de.from_date, de.to_date
From
	dept_emp de
Join
	(select
		emp_no, max(from_date) as from_date
	From
		dept_emp
	Group by emp_no) de1 on de1.emp_no = de.emp_no
Where
	de.to_date > sysdate()
    and
		de.from_date = de1.from_date;
--
-- Larger example, with multiple subqueries --
Select
	de2.emp_no, d.dept_name, s2.salary, avg(s2.salary) over test as avg_salary_per_dept -- de2, s2, are subquery results -- 
From
	(Select
	de.emp_no, de.dept_no, de.from_date, de.to_date
From
	dept_emp de
Join
	(select
		emp_no, max(from_date) as from_date
	From
		dept_emp
	Group by emp_no) de1 on de1.emp_no = de.emp_no
Where
	de.to_date > sysdate()
    and
		de.from_date = de1.from_date) de2 -- de2 connecting subquery below --
Join
	(Select
	s1.emp_no, s.salary, s.from_date, s.to_date
From
	salaries s
Join
	(select
		emp_no, max(from_date) as from_date
	From
		salaries
	Group by emp_no) s1 on s.emp_no = s1.emp_no
	Where
		s.to_date > sysdate()
	and
		s.from_date = s1.from_date) s2 on s2.emp_no = de2.emp_no
	Join
		departments d on d.dept_no = de2.dept_no
Group by de2.emp_no, d.dept_name
Window test as (Partition by de2.dept_no)
Order by de2.emp_no;
--
-- Further example --
Select
	de2.emp_no, s2.salary, d.dept_name, avg(s2.salary) over test as avg_salary_per_dept -- de2, s2, are subquery results -- 
From
	(Select
	de.emp_no, de.dept_no, de.from_date, de.to_date
From
	dept_emp de
Join
	(select
		emp_no, max(from_date) as from_date
	From
		dept_emp
	Group by emp_no) de1 on de1.emp_no = de.emp_no
Where
	de.to_date < '2002-01-01' and de.from_date > '2000-01-01' 
    and
		de.from_date = de1.from_date) de2 -- de2 connecting subquery below --
Join
	(Select
	s1.emp_no, s.salary, s.from_date, s.to_date
From
	salaries s
Join
	(select
		emp_no, max(from_date) as from_date
	From
		salaries
	Group by emp_no) s1 on s.emp_no = s1.emp_no
	Where
		s.to_date < '2002-01-01' and s.from_date > '2000-01-01'
	and
		s.from_date = s1.from_date) s2 on s2.emp_no = de2.emp_no
	Join
		departments d on d.dept_no = de2.dept_no
Group by de2.emp_no, d.dept_name
Window test as (Partition by de2.dept_no)
Order by de2.emp_no, salary;