-- Temporary Tables --
-- Query can produce temporary dataset --
-- the employees DB contains tabular tables, data in default DB is permanent --
-- Joins to combine data from multiple regular tables (can be temporary result set) --
-- subqueries for creating temporary result sets (can be temporary result set)--
-- Window functions for partitions that can be used to run specific window functions (can be temporary) --
-- Common Table Expressions / CTEs can hold temporary result sets --
-- Permanent data in the regular tables --
-- Used at the back, like alter table/select distinct --
-- lower query cost with temporary tables if done directly --
--

Use employees;

Create Temporary Table f_highest_salaries
Select
	s.emp_no, max(s.salary) as f_highest_salary
From
	salaries s
	Join
	employees e on e.emp_no = s.emp_no
where e.gender = 'f'
Group by s.emp_no;
--
Select
	*
From
	f_highest_salaries
Where emp_no <= '10010';
--
Drop temporary table male_highest_salaries;
Create Temporary Table male_highest_salaries
Select
	s.emp_no, max(s.salary) as male_highest_salary
From
	salaries s
	Join
	employees e on e.emp_no = s.emp_no
where e.gender = 'm'
group by s.emp_no;
--
Select
	*
From
	male_highest_salaries
Limit 10; -- For quicker check --
--
Drop Temporary Table f_highest_salaries;
Create Temporary Table f_highest_salaries
Select
	s.emp_no, max(s.salary) as f_highest_salary
From
	salaries s
	Join
	employees e on e.emp_no = s.emp_no
where e.gender = 'f'
Group by s.emp_no
Limit 10;
-- When temporary table in use, locked for use --
-- Can only be invoked once --
-- Cannot be used in self-joins nor union/union all operators--
-- Workaround, Common Table Expression --
--
-- CTE --
With cte as 
(Select
	s.emp_no, max(s.salary) as f_highest_salary
From
	salaries s
	Join
	employees e on e.emp_no = s.emp_no
where e.gender = 'f'
Group by s.emp_no
Limit 10)
Select * from f_highest_salaries f1 join cte c;
--
-- Union --
With cte as 
(Select
	s.emp_no, max(s.salary) as f_highest_salary
From
	salaries s
	Join
	employees e on e.emp_no = s.emp_no
where e.gender = 'f'
Group by s.emp_no
Limit 10)
Select * from f_highest_salaries union all select * from cte ;
--
-- Temporary Table Dates --
-- Current Date now() and date_sub() --
-- Date_Sub(date, interval expr unit) -> Day/Month/Year, subtracts time--

Create Temporary Table dates
	select
		now() as current_date_time,
        date_sub(now(), interval 1 month) as a_month_earlier,
        date_sub(now(), interval -1 year) as a_year_later;
Select
	*
From
	dates;
--
-- Workaround with CTE --
With cte as 
(select
	now() as current_date_time,
	date_sub(now(), interval 1 month) as a_month_earlier,
	date_sub(now(), interval -1 year) as a_year_later)
Select * from dates d1 join cte c; -- joins both tables together
--
With cte as 
(select
	now() as current_date_time,
	date_sub(now(), interval 1 month) as a_month_earlier,
	date_sub(now(), interval -1 year) as a_year_later)
Select * from dates Union all select * from cte; 
--
Drop temporary table if exists dates;
--
-- Another Example --
Create Temporary Table dates
	select
		now() as current_date_time,
        date_sub(now(), interval 2 month) as two_months_earlier,
        date_sub(now(), interval -2 year) as two_years_later;
Select
	*
From
	dates;
--
With cte as 
(select
	now() as current_date_time,
	date_sub(now(), interval 2 month) as two_months_earlier,
	date_sub(now(), interval -2 year) as two_years_later)
Select * from dates d1 join cte c; -- joins both tables together
--
With cte as 
(select
	now() as current_date_time,
	date_sub(now(), interval 2 month) as two_months_earlier,
	date_sub(now(), interval -2 year) as two_years_later)
Select * from dates d1 union all select * from cte ; -- joins both tables together
--
Drop temporary table if exists male_highest_salaries;
drop temporary table if exists dates;
