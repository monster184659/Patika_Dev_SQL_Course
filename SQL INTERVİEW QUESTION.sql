CREATE TABLE Employee (
EmpID int NOT NULL,
	EmpName Varchar,
	Gender Char,
	Salary int,
	City Char(20)
)

INSERT INTO Employee
VALUES (1, 'Arjun', 'M', 75000, 'Pune'),
(2, 'Ekadanta', 'M', 125000, 'Bangalore'),
(3, 'Lalita', 'F', 150000 , 'Mathura'),
(4, 'Madhav', 'M', 250000 , 'Delhi'),
(5, 'Visakha', 'F', 120000 , 'Mathura')


CREATE TABLE EmployeeDetail (
EmpID int NOT NULL,
Project Varchar,
EmpPosition Char(20),
DOJ date )

--- first run the above code then below code
SET datestyle = 'DMY';
INSERT INTO EmployeeDetail
VALUES (1, 'P1', 'Executive', '26-01-2019'),
(2, 'P2', 'Executive', '04-05-2020'),
(3, 'P1', 'Lead', '21-10-2021'),
(4, 'P3', 'Manager', '29-11-2019'),
(5, 'P2', 'Manager', '01-08-2020')

SELECT * FROM EmployeeDetail

--QA1 Find the list of employees whose salary ranges between 2L to 3L.

SELECT * FROM Employee
WHERE 200000 < salary AND   salary < 300000

--QA2 Write a query to retrieve the list of employees from the same city.

SELECT * FROM Employee E1, Employee E2
WHERE E1.City = E2.City AND E1.EmpName!= E2.EmpName

--QA3 Query to find the null values in the Employee table.

WHERE EmpID IS NULL


--QB1: Query to find the cumulative sum of employee’s salary.
SELECT SUM(salary) OVER(ORDER BY salary ) FROM Employee


--QB2: What’s the male and female employees ratio.
WITH a AS(
SELECT Gender, COUNT(gender) AS gend FROM Employee
GROUP BY Gender),
b AS(
SELECT COUNT(gender) AS top FROM Employee)
SELECT a.gender, a.gend*100/(SELECT top FROM b) FROM a
GROUP BY a.gender, a.gend

--OR

SELECT
(COUNT(*) FILTER (WHERE Gender = 'M') * 100.0 / COUNT(*)) AS MalePct,
(COUNT(*) FILTER (WHERE Gender = 'F') * 100.0 / COUNT(*)) AS FemalePct
FROM Employee;

--QB3:Write a query to fetch 50% records from the Employee table.

SELECT * FROM Employee
WHERE EmpID <= (SELECT COUNT(EmpID)/2 FROM  Employee)

--QC1:Query to fetch the employee’s salary but replace the LAST 2 digits with ‘XX’
--i.e 12345 will be 123XX

SELECT Salary, CONCAT(LEFT(CAST(Salary AS text), LENGTH(CAST(Salary AS text))-2), 'XX')
AS masked_number
FROM Employee

--QD1: Write a query to fetch even and odd rows from Employee table.
SELECT *, CASE WHEN EmpID % 2 = 0 THEN 'ÇİFT SAYI' ELSE 'TEK SAYI' END FROM Employee

--QE1: Write a query to find all the Employee names whose name:
--• Begin with ‘A’
--• Contains ‘A’ alphabet at second place
--• Contains ‘Y’ alphabet at second last place
--• Ends with ‘L’ and contains 4 alphabets
--• Begins with ‘V’ and ends with ‘A’

SELECT * FROM Employee
WHERE EmpName ILIKE 'A%'

SELECT * FROM Employee
WHERE EmpName ILIKE '_a%'

SELECT * FROM Employee
WHERE EmpName ILIKE '%y_'

SELECT * FROM Employee
WHERE EmpName ILIKE '%l' AND  EmpName ILIKE '____'

SELECT * FROM Employee
WHERE EmpName ILIKE 'V%A'

--QE2: Write a query to find the list of Employee names which is:
--• starting with vowels (a, e, i, o, or u), without duplicates
--• ending with vowels (a, e, i, o, or u), without duplicates
--• starting & ending with vowels (a, e, i, o, or u), without duplicates

SELECT * FROM Employee
WHERE EmpName ILIKE 'a%' OR EmpName ILIKE 'E%' OR EmpName ILIKE 'I%' OR EmpName ILIKE 'O%'
OR EmpName ILIKE 'U%'

SELECT * FROM Employee
WHERE EmpName ILIKE '%A' OR EmpName ILIKE '%E' OR EmpName ILIKE '%I' OR EmpName ILIKE '%O'
OR EmpName ILIKE '%U'

SELECT DISTINCT EmpName 
FROM Employee
WHERE LOWER(EmpName) SIMILAR TO '[aeiou]%[aeiou]';

--QF1: Find Nth highest salary from employee table with and without using the
--TOP/LIMIT keywords.
ALTER TABLE Employee
ALTER COLUMN salary TYPE INTEGER USING salary::INTEGER

SELECT *, RANK() OVER(ORDER BY salary desc) FROM Employee
LIMIT 1

--General Solution without using TOP/LIMIT
SELECT Salary FROM Employee E1
WHERE N-1 = (

SELECT COUNT( DISTINCT ( E2.Salary ) )
FROM Employee E2
WHERE E2.Salary > E1.Salary );

--- OR ---
SELECT Salary FROM Employee E1
WHERE N = (

SELECT COUNT( DISTINCT ( E2.Salary ) )
FROM Employee E2
WHERE E2.Salary >= E1.Salary );

--Using TOP
SELECT TOP 1 Salary
FROM Employee
WHERE Salary < (
SELECT MAX(Salary) FROM Employee)
AND Salary NOT IN (
SELECT TOP 2 Salary
FROM Employee
ORDER BY Salary DESC)
ORDER BY Salary DESC;

--QG1 Write a query to find and remove duplicate records from a table.
WITH a AS(
SELECT EmpID, EmpName, Gender, Salary, City, COUNT(*) FROM Employee
GROUP BY EmpID, EmpName, Gender, Salary, City)
SELECT * FROM a
WHERE COUNT>1

DELETE FROM Employee
WHERE EmpID IN
(SELECT EmpID FROM Employee
GROUP BY EmpID
HAVING COUNT(*) > 1);

--QH1: Query to retrieve the list of employees working in same project.

WITH a AS(
SELECT Employee.EmpID, Employee.EmpName, EmployeeDetail.Project FROM Employee
JOIN EmployeeDetail ON Employee.EmpID = EmployeeDetail.EmpID
GROUP BY  EmployeeDetail.Project, Employee.EmpName, Employee.EmpID)

SELECT a.EmpName, a.project, c.EmpName FROM a
INNER JOIN a AS c ON c.project = a.project and c.EmpName != a.EmpName AND c.EmpID < a.EmpID

--QI1:Show the employee with the highest salary for each project

SELECT EmployeeDetail.project, MAX(salary) FROM Employee
INNER JOIN EmployeeDetail ON Employee.EmpID = EmployeeDetail.EmpID
GROUP BY project

--QJ1: Query to find the total count of employees joined each year

SELECT EXTRACT(year FROM doj) AS yearr, COUNT(Employee.EmpID) FROM Employee
INNER JOIN EmployeeDetail ON Employee.EmpID = EmployeeDetail.EmpID
GROUP BY yearr

--QK1:Create 3 groups based on salary col, salary less than 1L is low, between 1 -
--2L is medium and above 2L is High

SELECT salary, CASE WHEN salary < 100000 THEN 'LOW' WHEN salary > 100000 AND salary < 200000 THEN 'MEDIUM'
ELSE 'HIGH' END AS salary_group
FROM Employee



--bonus: Query to pivot the data in the Employee table and retrieve the total
--salary for each city.
--The result should display the EmpID, EmpName, and separate columns for each city
--(Mathura, Pune, Delhi), containing the corresponding total salary.

SELECT  EmpID, EmpName, SUM(CASE WHEN city = 'Pune' THEN salary  ELSE NULL END) AS Pune,
SUM(CASE WHEN city = 'Bangalore' THEN salary ELSE NULL END) AS Bangalore ,
SUM(CASE WHEN city = 'Mathura' THEN salary  ELSE NULL END) AS Mathura,
SUM(CASE WHEN city = 'Delhi' THEN salary  ELSE NULL END) AS Delhi 
FROM Employee
GROUP BY EmpID, EmpName




