
-- Create Departments Table
CREATE TABLE departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50)
);

-- Create Employees Table
CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    name VARCHAR(100),
    dept_id INT,
    salary DECIMAL(10, 2),
    join_date DATE,
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);

-- Create Projects Table
CREATE TABLE projects (
    proj_id INT PRIMARY KEY,
    proj_name VARCHAR(100),
    dept_id INT,
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);

-- Insert Departments
INSERT INTO departments (dept_id, dept_name) VALUES
(10, 'Engineering'),
(20, 'HR'),
(30, 'Sales');

-- Insert Employees
INSERT INTO employees (emp_id, name, dept_id, salary, join_date) VALUES
(1, 'Alice', 10, 70000, '2018-01-15'),
(2, 'Bob', 20, 60000, '2019-03-22'),
(3, 'Charlie', 10, 80000, '2016-11-03'),
(4, 'Diana', 30, 75000, '2020-07-01'),
(5, 'Ethan', 20, 62000, '2021-06-17');

-- Insert Projects
-- Insert Projects
INSERT INTO projects (proj_id, proj_name, dept_id) VALUES
(101, 'Website Revamp', 10),
(102, 'Recruitment App', 20),
(103, 'CRM Integration', 30);

-- List employees with their department names
select e.name,d.dept_name from employees e join departments d on e.dept_id = d.dept_id;

-- Categorize employees by salary
select 
case when salary>=70000 then 'High salary'
	 when salary>=60000 and salary<70000 then 'mid salary' end,
name from employees;

-- Find top earner per department
with ranked_table as (
select e.name,d.dept_name,
row_number() over(partition by dept_name order by e.salary) as rank from employees e join departments d on e.dept_id = d.dept_id )
select name,dept_name from ranked_table where rank = 1;

-- Give a 10% raise to employees in Engineering
select e.name,e.salary as prev_salary,round(((e.salary*110)/100),2) as today_salary from employees e join departments d on d.dept_id = e.dept_id where d.dept_name = 'Engineering';
update employees set salary = salary*1.10 where dept_id = (select dept_id from departments where dept_name = 'Engineering');

-- Average salary by department
select d.dept_name,avg(e.salary) from employees e join departments d on d.dept_id = e.dept_id GROUP by 1;

-- Employees earning above department average
select name,salary from employees e where salary>(select avg(salary) from employees where dept_id = e.dept_id);

-- Employees who joined before 2017
select name,join_date from employees where extract(year from join_date)<2017;

-- Get a combined list of all employee and project names
select e.name,p.proj_name from employees e join departments d on e.dept_id=d.dept_id join projects p on p.dept_id = d.dept_id; 

-- CTE to find department-wise average salary, and employees above that average
SELECT avg(e.salary),d.dept_name from employees e join departments d on d.dept_id = e.dept_id group by 2;

-- Employees in per departments
select count(e.name),d.dept_name from  employees e join departments d on d.dept_id = e.dept_id group by 2;

-- Rank employees within department and add labels , salary wise 
with ranked as(
select *,
row_number() over(partition by dept_id order by salary desc) as rank from employees)
select name,dept_id,salary,rank,
case 
when rank = 1 then 'top emp'
when rank = 2 then 'second emp'
else 'other' END
from ranked;


select * from departments;
select * from employees;
SELECT * FROM projects;
