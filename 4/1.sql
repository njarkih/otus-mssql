-- 1.  Выберите сотрудников, которые являются продажниками, и еще не сделали ни одной продажи.
WITH orders (id) AS (
  SELECT DISTINCT 
    SalespersonPersonID 
  FROM Sales.Orders o
)
SELECT 
  p.PersonID
, p.FullName
FROM Application.People p
WHERE p.IsSalesperson = 1
  AND p.PersonID NOT IN (SELECT id FROM orders)
;

SELECT 
  p.PersonID
, p.FullName
FROM Application.People p
WHERE p.IsSalesperson = 1
  AND NOT EXISTS (SELECT 1 FROM Sales.Orders o WHERE o.SalespersonPersonID = p.PersonID) 
;

SELECT 
  p.PersonID
, p.FullName
FROM Application.People p
WHERE p.IsSalesperson = 1
  AND p.PersonID != ALL (SELECT DISTINCT SalespersonPersonID FROM Sales.Orders o) 
;


SELECT p.PersonID, p.FullName
FROM Application.People p
WHERE p.IsSalesperson = 1
  AND p.PersonID NOT IN (SELECT DISTINCT SalespersonPersonID 
						 FROM Sales.Orders o)
;



 