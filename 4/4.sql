-- 4. �������� ������ (�� � ��������), � ������� ���� ���������� ������, �������� � ������ ����� ������� �������, 
-- � ����� ��� ����������, ������� ����������� �������� �������

-- ��� 3 ����� ������� �������
WITH TopPrice AS (
  SELECT TOP 3 
    StockItemID
  , UnitPrice
  FROM Warehouse.StockItems
  ORDER BY UnitPrice DESC
)
-- ���������� �� ������� � ������� ���� ������ �� ��� 3
, FindedOrders AS (
  SELECT 
    o.PickedByPersonID
  , c.DeliveryCityID  
  FROM Sales.Orders o
  JOIN Sales.OrderLines l ON o.OrderID = l.OrderID 
  JOIN Sales.Customers c ON c.CustomerID = o.CustomerID
  WHERE EXISTS (SELECT 1 FROM TopPrice p WHERE p.StockItemID = l.StockItemID)
)
SELECT 
  c.CityID
, c.CityName
, STRING_AGG(p.FullName, ', ') PickedByPerson
FROM FindedOrders f
JOIN Application.Cities c ON c.CityID = f.DeliveryCityID
LEFT JOIN Application.People p ON f.PickedByPersonID = p.PersonID
GROUP BY c.CityID, c.CityName
;

SELECT 
  c.CityID
, c.CityName
, STRING_AGG(p.FullName, ', ') PickedByPerson
FROM (SELECT 
        o.PickedByPersonID
      , c.DeliveryCityID  
      FROM Sales.Orders o
      JOIN Sales.OrderLines l ON o.OrderID = l.OrderID 
      JOIN Sales.Customers c ON c.CustomerID = o.CustomerID
      WHERE EXISTS (SELECT 1 FROM (SELECT TOP 3 StockItemID, UnitPrice FROM Warehouse.StockItems ORDER BY UnitPrice DESC) p WHERE p.StockItemID = l.StockItemID)
) f
JOIN Application.Cities c ON c.CityID = f.DeliveryCityID
LEFT JOIN Application.People p ON f.PickedByPersonID = p.PersonID
GROUP BY c.CityID, c.CityName
;
