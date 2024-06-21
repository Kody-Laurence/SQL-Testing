-- Stored Routines --
-- SQL Statements stored on DB server
-- Invoke routine, call/reference --
-- Store algerithm in routine --
-- call stored_routine (example name) --
-- Stored Procedures/Functions, functions like aggregate functions --

Use Employees;

-- Delimiter $$ --
-- Call stored_procedure -> query #1 ;
-- Teporary delimter like $$ --
-- Delimiter $$ --
-- Create Procedure procedure_name(), can be created without parameters, always has () --
-- Begin --
	-- Select * from employees --
	-- Limit 1000; --
-- End $$ --
-- Delimiter ; --
-- From here $$ will not act as delimiter --
--
Use employees;
--
Drop Procedure if exists select_employees;

Delimiter $$
Create Procedure select_employees()
Begin
	Select 
		*
	From 
		employees
	Limit 1000;
End$$
Delimiter ;

Call employees.select_employees(); -- () -> stored routine --

Call select_employees;
--
Drop Procedure if exists average_salary;
Delimiter $$
Create Procedure average_salary()
Begin
	Select
		avg(salary)
	From
		salaries;
End $$
Delimiter ;

Call average_salary;
--
Drop Procedure select_employees;
-- Next, Parametic procedures --
-- Create stored procedures w/ Input Parameter --
-- In parameter --

Use employees;
Drop Procedure if exists emp_salary;

Delimiter $$
Use employees $$
Create procedure emp_salary(in p_emp_no integer) -- (P Parameter, datatype)
Begin
	Select
		e.first_name, e.last_name, s.salary, s.from_date, s.to_date
	From
		employees e
	Join
		Salaries s on e.emp_no = s.emp_no
	Where
		e.emp_no = p_emp_no; -- Checks whether input column corresponds to input value --
	End $$
Delimiter ;
--
Drop Procedure if exists emp_avg_salary;

Delimiter $$
Use employees $$
Create procedure emp_avg_salary(in p_emp_no integer) -- (P Parameter, datatype)
Begin
	Select
		e.first_name, e.last_name, avg(s.salary)
	From
		employees e
	Join
		Salaries s on e.emp_no = s.emp_no
	Where
		e.emp_no = p_emp_no -- Checks whether input column corresponds to input value --
	Group by e.first_name, e.last_name;
	End $$
Delimiter ;
Call emp_avg_salary(11300);
--
-- Stores Procedures with output parameter --
Drop Procedure if exists emp_avg_salary_out;

Delimiter $$
Use employees $$
Create procedure emp_avg_salary_out(in p_emp_no integer, out p_avg_salary decimal (10,2)) -- (P Parameter, datatype)
Begin
	Select
		avg(s.salary)
	Into
		p_avg_salary
	From
		employees e
	Join
		Salaries s on e.emp_no = s.emp_no
	Where
		e.emp_no = p_emp_no -- Checks whether input column corresponds to input value --
	Group by e.first_name, e.last_name;
	End $$
Delimiter ;
--
Drop procedure if exists emp_info;
Delimiter $$
Create procedure 
	emp_info(in p_first_name varchar(255), p_last_name varchar(255), out p_emp_no integer)
Begin
    Select
		e.emp_no
	Into
		p_emp_no
	From
		employees e
	Where
		e.first_name = p_first_name
	and
		e.last_name = p_last_name;
End $$
Delimiter ;
-- SQL Variables --
-- Defining program = using paramaters , more abstract --
-- Input argument, output variable --

Set @v_avg_salary = 0;
Call
	employees.emp_avg_salary_out(11300, @v_avg_salary);
Select
	@v_avg_salary;
-- In-Out Parameter --

set @v_emp_no = 0;
Call
	employees.emp_info('Aruna', 'Journel', @v_emp_no);
Select
	@v_emp_no;
-- Benefit of user defined functions in SQL --


Delimiter $$
Create Function f_emp_avg_salary(p_emp_no integer) returns decimal(10,2)
Deterministic No SQL Reads SQL Data
Begin
	Declare
		v_avg_salary decimal(10,2); -- Data type must be same as in returns --
	Select
		avg(s.salary)
	Into
		v_avg_salary
	From
		employees e
	Join
		salaries s on e.emp_no = s.emp_no
	Where
		e.emp_no = p_emp_no;
	Return
		v_avg_salary;
End $$
Delimiter ;

Select f_emp_avg_salary(11300);
--
Drop function if exists f_emp_info;

Delimiter $$
Create Function f_emp_info(p_first_name varchar(255), p_last_name varchar(255)) returns integer
No SQL
Begin
	Declare							    -- first select for date info --
		v_max_from_date date;
	Declare                             -- Will need 2nd select for salary info --
        v_salary decimal(10,2);
	Select
		Max(from_date)
	Into
		v_max_from_date
	From
		employees e
	Join
		salaries s on e.emp_no = s.emp_no
	Where
		e.first_name = p_first_name
	And
		e.last_name = p_last_name;
        -- 2nd select --
	Select
		s.salary
	Into
		v_salary
	From
		employees e
	Join
		salaries s on e.emp_no = s.emp_no
	Where
		e.first_name = p_first_name
	And
		e.last_name = p_last_name
	And
		s.from_date = v_max_from_date;
	Return v_salary;
End $$
Delimiter ;
Select f_emp_info('Aruna', 'Journel') as Salary_employee;
-- Concluding Stored routines --
-- Function returns values, select function, single value return --
-- Stored procedure doesn't return values, call procedure, multiple out paramaters --
-- 1 value = function, multiple = procedure --
-- Procedure - Insert, Update, delete, Function do not use I/U/D --
-- Can include function within select statement --
-- Cannot include select statement in procedure --
-- Procedure can be called to perform operation with call statement -- 