-- 5
-- 10 ��������� �� ���� ������ � ������ ������� � ������ ����������, ������� ������� �����
SELECT TOP 10
  CONVERT(VARCHAR(10), o.OrderDate, 104) OrderDate
, c.CustomerName
, p.FullName SalespersonPerson
FROM Sales.Orders o
JOIN Sales.Customers c ON o.CustomerID = c.CustomerID 
JOIN Application.People p ON o.SalespersonPersonID = p.PersonID
ORDER BY o.OrderDate DESC
;