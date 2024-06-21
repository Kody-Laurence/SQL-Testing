-- Coalesce(), IFNULL() --

Select
	emp_no,
	first_name,
    	last_name,
Case
	When gender = 'm'
    Then 
	'Male'
    Else
	'Female'
	End as Gender
From
	employees;
--
Select
	emp_no,
    	first_name,
    	last_name,
Case gender
	When 'm'
    Then 'Male'
    Else
	'Female'
	End as Gender
From
	employees;
--
Select
	e.emp_no,
	e.first_name,
	e.last_name,
Case
	When dm.emp_no is not null then 'Manager'
    Else
	'Employee'
	End as is_manager
From
	employees e
		Left Join
			dept_manager dm on dm.emp_no = e.emp_no
	Where
		e.emp_no > 109990; 
--
Select
	e.emp_no,
	e.first_name,
	e.last_name,
Case
	When dm.emp_no is not null then 'Manager' 
    Else
	'Employee'
	End as is_manager
From
	employees e
		Left Join
			dept_manager dm on dm.emp_no = e.emp_no
	Where
		e.emp_no > 109990; 
--
Select
	emp_no,
	first_name,
	last_name,
	if (gender = 'm','Male', 'Female') as gender
From
	employees;
--
Select
	dm.emp_no,
    e.first_name,
    e.last_name,
    Max(s.salary) - min(s.salary) as salary_diff,
    Case
		When max(s.salary) - min(s.salary) > 30000 Then 'Salary raised by more than 30k'
        When max(s.salary) - min(s.salary) Between 20000 and 30000 then 'Salary raised by more than 20k and less than 30k'
	Else
		'Salary raised by less than 20k'
	End as salary_increase
From
	dept_manager dm
Join
	employees e on e.emp_no = dm.emp_no
Join
	salaries s on s.emp_no = dm.emp_no
Group By s.emp_no;
--
Select
	e.emp_no,
    e.first_name,
    e.last_name,
Case
	When dm.emp_no is not null then 'Yes, is a Manager'
    Else
		'No, is Employee'
	End as is_manager
From
	employees e
		Left Join
			dept_manager dm on dm.emp_no = e.emp_no
	Where
		e.emp_no > 109990;
 -- Order by emp_no; --
 --
 Select
	dm.emp_no,
    e.first_name,
    e.last_name,
    Max(s.salary) - min(s.salary) as salary_diff,
    Case
		When max(s.salary) - min(s.salary) > 30000 Then 'Salary raised by more than 30k'
        When max(s.salary) - min(s.salary) < 30000 then 'Salary raised less than 30k'
	Else
		'Salary raised by less than 20k'
	End as salary_increase
From
	dept_manager dm
Join
	employees e on e.emp_no = dm.emp_no
Join
	salaries s on s.emp_no = dm.emp_no
Group By s.emp_no;
--
-- With If --
Select
	dm.emp_no,
    e.first_name,
    e.last_name,
    Max(s.salary) - min(s.salary) as salary_diff,
	If(max(s.salary) - min(s.salary) > 30000, 'Salary raised by more than 30k',
		'Salary raised less than 30k')
	as salary_increase
From
	dept_manager dm
Join
	employees e on e.emp_no = dm.emp_no
Join
	salaries s on s.emp_no = dm.emp_no
Group By s.emp_no;
--
Select
	e.emp_no,
    e.first_name,
    e.last_name,
Case
	When max(de.to_date) > sysdate() then 'Is still employed'
    Else
		'No, is not employed'
	End as is_employed
From
	employees e
		Left Join
			dept_emp de on de.emp_no = e.emp_no
Group By de.emp_no
Limit 100;
