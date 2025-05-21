CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Department VARCHAR(50),
    Salary DECIMAL(10, 2),
    HireDate DATE
);

INSERT INTO Employees (EmployeeID, FirstName, LastName, Department, Salary, HireDate) VALUES
(1, 'John', 'Doe', 'Sales', 60000.00, '2022-08-15'),
(2, 'Jane', 'Smith', 'Marketing', 75000.00, '2023-01-20'),
(3, 'Peter', 'Jones', 'Sales', 62000.00, '2022-11-01'),
(4, 'Mary', 'Brown', 'IT', 80000.00, '2023-05-10'),
(5, 'David', 'Lee', 'Finance', 70000.00, '2024-02-25'),
(6, 'Susan', 'Taylor', 'Marketing', 78000.00, '2023-09-01'),
(7, 'Michael', 'Wilson', 'IT', 85000.00, '2024-04-12'),
(8, 'Linda', 'Garcia', 'Sales', 65000.00, '2023-07-01'),
(9, 'Robert', 'Martinez', 'Finance', 72000.00, '2024-01-15'),
(10, 'Jennifer', 'Lopez', 'Marketing', 82000.00, '2023-12-01');

CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(50),
    Location VARCHAR(50)
);

INSERT INTO Departments (DepartmentID, DepartmentName, Location) VALUES
(101, 'Sales', 'New York'),
(102, 'Marketing', 'Los Angeles'),
(103, 'IT', 'San Francisco'),
(104, 'Finance', 'Chicago');

CREATE TABLE Projects (
    ProjectID INT PRIMARY KEY,
    ProjectName VARCHAR(100),
    StartDate DATE,
    EndDate DATE,
    DepartmentID INT,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

INSERT INTO Projects (ProjectID, ProjectName, StartDate, EndDate, DepartmentID) VALUES
(1, 'Sales Reporting System', '2023-09-01', '2024-03-31', 101),
(2, 'New Marketing Campaign', '2024-01-15', '2024-06-30', 102),
(3, 'Infrastructure Upgrade', '2024-05-01', '2024-12-31', 103),
(4, 'Budgeting Tool Development', '2024-03-01', '2024-09-30', 104),
(5, 'Customer Relationship Management', '2024-07-01', '2025-03-31', 101),
(6, 'Social Media Strategy', '2024-04-01', '2024-10-31', 102),
(7, 'Security Enhancement Project', '2025-01-01', '2025-07-31', 103);

--Find employees whose first name starts with 'Jo':
select firstname from employees where firstname like 'Jo%';

--Find employees whose last name contains 'son':
select firstname,lastname from employees where lastname like '%son';

--Categorize employees based on their salary:
select firstname,lastname,salary,
case when salary>=80000 then 'first grade'
when salary>=60000 and salary<80000 then 'second grade'
else 'third grade' end from employees;

--Assign a bonus based on the department:
select firstname,department,salary,
case department
when 'sales' then salary * 1.10
when 'marketing' then salary *1.09
when 'finance' then salary * 1.11
else salary * 1.10 end as updated_salary from employees;

--Assign a rank to employees within each department based on their salary (highest salary first):
select firstname,department,salary,
row_number() over(partition by department order by salary desc) rank from employees;

--Get the top 2 highest-paid employees in each department:
with ranked as 
(select firstname,department,salary,
row_number() over(partition by department order by salary desc) rank from employees)
select firstname,department,salary,rank from ranked where rank<=2;

--Get employee names and their department names:
select e.firstname,d.departmentname from employees e join departments d on e.department = d.departmentname;

-- Get employee names and the projects they might be involved in (based on department):
select e.firstname,p.projectname,e.department from employees e join departments d on e.department = d.departmentname join projects p on D.DEPARTMENTID = P.DEPARTMENTID;

--Find the average salary for each department:
select department,round(avg(salary),2) from employees group by 1;

--Find departments with an average salary greater than 70000:
select department,round(avg(salary),2) from employees group by 1 HAVING avg(salary) > 70000  ;

--List employees ordered by their hire date (oldest first):
select firstname,hiredate from employees order by 2 asc;

--List employees ordered by department (alphabetically) and then by salary (highest first):
select firstname,department,salary from employees order by 2 asc ,3 desc;

--Get the top 5 highest-paid employees:
select firstname,salary from employees order by 2 desc limit 5;

--Find employees whose salary is higher than the average salary of all employees:
select firstname,salary from employees where salary> (select avg(salary) from employees);

--Calculate the number of days each project is scheduled to last:
select projectname,(enddate-startdate) as date from projects;

--Get the first name, last name of employees, their department name, and the name of any project associated with their department:
select e.firstname,e.department,p.projectname from employees e join departments d on e.department = d.departmentname join projects p on d.departmentid = p.departmentid;

--Find departments that have no projects associated with them:
select d.departmentname from departments d join projects p on p.departmentid = d.departmentid where p.projectname is null;

--Find the employee with the second-highest salary in each department:
with ranked as (
select firstname,department,salary,
row_number() over (partition by department order by salary desc) rank from employees
)
select firstname,department,salary,rank from ranked where rank = 2;

--If an employee in the 'Marketing' department has a salary less than 76000, increase their salary by 5%:
select firstname,department,salary,(salary*1.05) as new_salary from employees where department = 'Marketing' and salary<80000;

--Find employees who are in the 'Sales' department and were hired in 2022, OR employees in the 'IT' department with a salary greater than 82000:
select * from employees where department = 'Sales' and extract(year from hiredate) = 2022 or (department = 'IT' and salary>82000);

--Classify projects based on their duration: 'Short-term' (less than 180 days), 'Mid-term' (180 to 365 days), 'Long-term' (more than 365 days):
select projectname,(enddate-startdate) as term, case 
when (enddate-startdate)<180 then 'Short-term'
when (enddate - startdate) BETWEEN 180 and 365 then 'Mid-Term'
when (enddate - startdate)>365 then 'Long-Term' end as duration from projects;









select * from employees;
select * from projects;
select * from departments;
