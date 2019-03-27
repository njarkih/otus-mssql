-- 2. Написать рекурсивный CTE sql запрос и заполнить им временную таблицу и табличную переменную

--CREATE TABLE dbo.MyEmployees 
--( 
--EmployeeID smallint NOT NULL, 
--FirstName nvarchar(30) NOT NULL, 
--LastName nvarchar(40) NOT NULL, 
--Title nvarchar(50) NOT NULL, 
--DeptID smallint NOT NULL, 
--ManagerID int NULL, 
--CONSTRAINT PK_EmployeeID PRIMARY KEY CLUSTERED (EmployeeID ASC) 
--); 

--INSERT INTO dbo.MyEmployees VALUES 
--(1, N'Ken', N'Sánchez', N'Chief Executive Officer',16,NULL) 
--,(273, N'Brian', N'Welcker', N'Vice President of Sales',3,1) 
--,(274, N'Stephen', N'Jiang', N'North American Sales Manager',3,273) 
--,(275, N'Michael', N'Blythe', N'Sales Representative',3,274) 
--,(276, N'Linda', N'Mitchell', N'Sales Representative',3,274) 
--,(285, N'Syed', N'Abbas', N'Pacific Sales Manager',3,273) 
--,(286, N'Lynn', N'Tsoflias', N'Sales Representative',3,285) 
--,(16, N'David',N'Bradley', N'Marketing Manager', 4, 273) 
--,(23, N'Mary', N'Gibson', N'Marketing Specialist', 4, 16); 


--Результат вывода рекурсивного CTE:
--EmployeeID Name Title EmployeeLevel
--1	Ken Sánchez	Chief Executive Officer	1
--273	| Brian Welcker	Vice President of Sales	2
--16	| | David Bradley	Marketing Manager	3
--23	| | | Mary Gibson	Marketing Specialist	4
--274	| | Stephen Jiang	North American Sales Manager	3
--276	| | | Linda Mitchell	Sales Representative	4
--275	| | | Michael Blythe	Sales Representative	4
--285	| | Syed Abbas	Pacific Sales Manager	3
--286	| | | Lynn Tsoflias	Sales Representative	4


WITH EmploeesTree (ManagerID, EmployeeID, EmployeeName, Title, EmployeeLevel, Struct) AS (
  SELECT e.ManagerID, e.EmployeeID, e.FirstName + e.LastName, e.Title, 1, CONVERT(VARCHAR(8000), ISNULL(e.ManagerID, 0)) + ' '
  FROM MyEmployees e
  WHERE e.ManagerId IS NULL
  UNION ALL  
  SELECT e.ManagerID, e.EmployeeID, e.FirstName + e.LastName, e.Title, t.EmployeeLevel + 1, t.Struct + ' ' + CONVERT(VARCHAR(8000), ISNULL(e.ManagerID, 0))
  FROM MyEmployees AS e  
  JOIN EmploeesTree AS t ON e.ManagerID = t.EmployeeID
)
SELECT EmployeeID, REPLICATE('|		', EmployeeLevel) + EmployeeName, Title, EmployeeLevel
FROM EmploeesTree
ORDER BY Struct + ' ' + CONVERT(VARCHAR(8000), EmployeeID)
;
