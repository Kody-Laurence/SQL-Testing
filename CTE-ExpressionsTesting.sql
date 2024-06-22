-- Common table expressions --
-- Tool for obtaining temporary result sets within execution of given query --
-- Example --
Use employees;

Select
	avg(salary) as avg_salary
From
	salaries;
--
With  
	CTE as (
	Select 
		avg(salary) as avg_salary from salaries)
	Select -- Subquery part of CTE -- -- can also use Insert/Update/Delete but Select in this case --
		sum(case when s.salary > c.avg_salary then 1 else 0 end) as no_f_salaries_above_avg,
        count(s.salary) as total_no_of_salary_contracts
	From -- The subclause of the with clause --
		salaries s
	Join
		employees e on s.emp_no = e.emp_no and e.gender = 'F'
	Cross Join
    CTE c;
--
-- To Check --
With cte as (select avg(salary) as avg_salary from salaries)
Select
	*
From
	salaries s
Join
	cte c;
--
-- Another Check --
With cte as (select avg(salary) as avg_salary from salaries)
Select
	*
From
	salaries s
Join
	employees e on s.emp_no = e.emp_no and e.gender = 'F'
Join
	cte c;
--
-- Now with sum() function --
With cte as (select avg(salary) as avg_salary from salaries)
Select
	sum(case when s.salary > c.avg_salary then 1 else 0
    end) as no_f_salaries_above_avg,
    Count(s.salary) as total_no_of_salary_contracts
From
	salaries s
Join
	employees e on s.emp_no = e.emp_no and e.gender = 'F'
Join
	cte c;
--
-- CTEs sometimes called Named Subqueries --
-- Another way to find female salary average --
-- Using case when, else null end --
-- CTEs can be reused/referenced multiple times within count statement --
-- Example --
With cte as (select avg(salary) as avg_salary from salaries)
Select
	sum(case when s.salary > c.avg_salary then 1 else 0
    end) as no_f_salaries_above_avg_with_sum,
    Count(Case when s.salary > c.avg_salary then s.salary else null end) as no_f_salaries_above_avg_when_count,
    Count(s.salary) as total_no_of_salary_contracts
From
	salaries s
Join
	employees e on s.emp_no = e.emp_no and e.gender = 'F'
Cross Join
	cte c;
--
-- Now for male employees, contracts with salary value never above all time company salary average --
With cte as (select avg(salary) as avg_salary from salaries)
Select
	sum(case when s.salary < c.avg_salary then 1 else 0
    end) as no_m_salaries_above_avg,
    Count(s.salary) as total_no_of_salary_contracts
From
	salaries s
Join
	employees e on s.emp_no = e.emp_no and e.gender = 'M'
Join
	cte c;
--
With cte as (select avg(salary) as avg_salary from salaries)
Select
    Count(Case when s.salary < c.avg_salary then s.salary else null end) as no_m_salaries_above_avg_when_count,
    Count(s.salary) as total_no_of_salary_contracts
From
	salaries s
Join
	employees e on s.emp_no = e.emp_no and e.gender = 'M'
Join
	cte c;
--
-- Without CTE --
Select
	sum(case when s.salary < a.avg_salary then 1 else 0 end) as no_salaries_below_avg,
    count(s.salary) as no_of_salary_contracts
From
	(select
		avg(salary) as avg_salary
			from
				salaries s) a
			Join
				salaries s
			Join
				employees e on s.emp_no = e.emp_no and e.gender = 'M';
--
-- With Cross Join --
With cte as (select avg(salary) as avg_salary from salaries)
Select
    sum(Case when s.salary < c.avg_salary then 1 else 0 end) as no_m_salaries_above_avg_with_sum,
    Count(Case when s.salary < c.avg_salary then s.salary else null end) as no_salaries_above_avg_with_count,
    Count(s.salary) as total_no_of_salary_contracts
From
	salaries s
Join
	employees e on s.emp_no = e.emp_no and e.gender = 'M'
Cross Join
	cte c;
-- Multiple ways to get to the same solution --
--
-- Multiple subclauses in WITH clause --
-- Example --
Select
	s.emp_no, 
    max(s.salary) as highest_salary
From
	salaries s
Join
	employees e on e.emp_no = s.emp_no 
Where gender = 'F'
Group by
	s.emp_no;
-- 
-- Now using multiple subclauses --
-- Cannot have multiple WITH clauses within same MySQL query --
-- numerous subclauses are fine --
-- Female contracts --
With cte1 as (select avg(salary) as avg_salary from salaries), -- Subclause 1 --
CTE2 as -- Subclause 2 --
	(Select
    s.emp_no, max(s.salary) as f_highest_salary
From
	salaries s
Join
	employees e on s.emp_no = e.emp_no and e.gender = 'F'
Group by s.emp_no
	)
Select
sum(case when c2.f_highest_salary > c1.avg_salary then 1 else 0 end) as f_highest_salaries_above_avg,
count(e.emp_no) as total_no_female_contracts
from
	employees e
Join cte2 c2 on c2.emp_no = e.emp_no
Cross Join cte1 c1;
-- 2 CTEs, sum function and case statement above --
--
With cte1 as (select avg(salary) as avg_salary from salaries), -- Subclause 1 --
CTE2 as -- Subclause 2 --
	(Select
    s.emp_no, max(s.salary) as f_highest_salary
From
	salaries s
Join
	employees e on s.emp_no = e.emp_no and e.gender = 'F'
Group by s.emp_no
	)
Select
count(case when c2.f_highest_salary > c1.avg_salary then c2.f_highest_salary else null end) as f_highest_salaries_above_avg,
count(e.emp_no) as total_no_female_contracts
from
	employees e
Join cte2 c2 on c2.emp_no = e.emp_no
Cross Join cte1 c1;
--
-- Can also do math to get percentage of contracts above average, using round(), concat() --
With cte_avg_salary as (select avg(salary) as avg_salary from salaries), -- Subclause 1 --
CTE2 as -- Subclause 2 --
	(Select
    s.emp_no, max(s.salary) as f_highest_salary
From
	salaries s
Join
	employees e on s.emp_no = e.emp_no and e.gender = 'F'
Group by s.emp_no
	)
Select
sum(case when c2.f_highest_salary > c1.avg_salary then 1 else 0 end) as f_highest_salaries_above_avg,
count(e.emp_no) as total_no_female_contracts,
concat(round((sum(case when c2.f_highest_salary > c1.avg_salary then 1 else 0 end) / count(e.emp_no))*100,2),'%') as ' Percentage'
from
	employees e
Join cte2 c2 on c2.emp_no = e.emp_no -- Specify data/make sure all data that has info both sides is read --
Cross Join cte_avg_salary c1;
--
-- Male Salaries below alltime avg --
With m_avg_salary_below_alltime as (select avg(salary) as avg_salary from salaries), -- Subclause 1 --
CTE2 as -- Subclause 2 --
	(Select
    s.emp_no, max(s.salary) as m_highest_salary
From
	salaries s
Join
	employees e on s.emp_no = e.emp_no and e.gender = 'M'
Group by s.emp_no
	)
Select
sum(case when c2.m_highest_salary < c1.avg_salary then 1 else 0 end) as m_highest_salaries_above_avg,
count(e.emp_no) as total_no_male_contracts
from
	employees e
Join cte2 c2 on c2.emp_no = e.emp_no
Cross Join m_avg_salary_below_alltime c1;
--
-- 2nd way to do it --
With m_avg_salary_below_alltime as (select avg(salary) as avg_salary from salaries), -- Subclause 1 --
CTE2 as -- Subclause 2 --
	(Select
    s.emp_no, max(s.salary) as m_highest_salary
From
	salaries s
Join
	employees e on s.emp_no = e.emp_no and e.gender = 'M'
Group by s.emp_no
	)
Select
count(case when c2.m_highest_salary < c1.avg_salary then c2.m_highest_salary else null end) as m_highest_salaries_above_avg,
count(e.emp_no) as total_no_male_contracts
from
	employees e
Join cte2 c2 on c2.emp_no = e.emp_no
Cross Join m_avg_salary_below_alltime c1;
--
-- Now with from instead of join cte2 c2 on --
With m_avg_salary_below_alltime as (select avg(salary) as avg_salary from salaries), -- Subclause 1 --
CTE2 as -- Subclause 2 --
	(Select
    s.emp_no, max(s.salary) as m_highest_salary
From
	salaries s
Join
	employees e on e.emp_no = s.emp_no and e.gender = 'M'
Group by s.emp_no
	)
Select
count(case when c2.m_highest_salary < c1.avg_salary then c2.m_highest_salary else null end) as m_highest_salaries_above_avg,
count(emp_no) as total_no_male_contracts
from
	CTE2 c2
Join m_avg_salary_below_alltime c1;
--
-- Referring to CTEs in a With Clause --
-- Can refer to CTE defined earlier within a with clause --
-- Cannot refer to one defined after --
-- Example, employees hired after 2000-01-01 --
-- 2nd CTE in query can reference first CTE, but 1st cannot reference 2nd --
With emp_hired_from_jan_2000 as ( -- Can refer to this within subquery using with clause--
	select
		*
			from employees
				where hire_date > '2000-01-01'),
	highest_contract_salary_values as ( -- can refer to this after defined --
		select
			e.emp_no,
            max(s.salary)
		from
			salaries s
		Join
			emp_hired_from_jan_2000 e on e.emp_no = s.emp_no
		group by
			e.emp_no)
	
Select * from highest_contract_salary_values;
-- CTEs summary --
-- Written in with clause of query --
-- Can contain multiple subclauses --

