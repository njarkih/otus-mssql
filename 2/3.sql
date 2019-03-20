-- 3
-- ������� � ��������� ������, � ������� ���� �������, ������� ��������, � �������� ��������� �������, �������� ����� � ����� ����� ���� ��������� ���� - ������ ����� �� 4 ������, ���� ������ ������ ������ ���� ������, � ����� ������ ����� 100$ ���� ���������� ������ ������ ����� 20. �������� ������� ����� ������� � ������������ �������� ��������� ������ 1000 � ��������� ��������� 100 �������. ���������� ������ ���� �� ������ ��������, ����� ����, ���� �������. 
SELECT 
  o.OrderID
, CONVERT(VARCHAR(10), o.OrderDate, 104) OrderDate
, DATENAME (MONTH, o.OrderDate) [Month]
, DATEPART (QUARTER, o.OrderDate) [Quarter]
, CASE WHEN MONTH (o.OrderDate) > 8 THEN 3
       WHEN MONTH (o.OrderDate) > 4 THEN 2
	   ELSE 1 
  END Third
, SUM (l.Quantity) FullQuantity
, SUM (l.Quantity * l.UnitPrice) FullCost 
FROM Sales.Orders o
JOIN Sales.OrderLines l ON o.OrderID = l.OrderID
WHERE o.PickingCompletedWhen IS NOT NULL -- ������ ���� ������ ������
GROUP BY o.OrderID, o.OrderDate
HAVING SUM (l.Quantity * l.UnitPrice) > 100.00 -- ���� ������ ������ $100   
    OR SUM (l.Quantity) > 20 -- ��� ���������� ������ ����� 20
ORDER BY [Quarter], Third, o.OrderDate 
;

-- � ��������� �� ��������
SELECT 
  o.OrderID
, CONVERT(VARCHAR(10), o.OrderDate, 104) OrderDate
, DATENAME (MONTH, o.OrderDate) [Month]
, DATEPART (QUARTER, o.OrderDate) [Quarter]
, CASE WHEN MONTH (o.OrderDate) > 8 THEN 3
       WHEN MONTH (o.OrderDate) > 4 THEN 2
	   ELSE 1 
  END Third
, SUM (l.Quantity) FullQuantity
, SUM (l.Quantity * l.UnitPrice) FullCost 
FROM Sales.Orders o
JOIN Sales.OrderLines l ON o.OrderID = l.OrderID
WHERE o.PickingCompletedWhen IS NOT NULL -- ������ ���� ������ ������
GROUP BY o.OrderID, o.OrderDate
HAVING SUM (l.Quantity * l.UnitPrice) > 100.00 -- ���� ������ ������ $100   
    OR SUM (l.Quantity) > 20 -- ��� ���������� ������ ����� 20
ORDER BY [Quarter], Third, o.OrderDate 
 OFFSET 1000 ROWS FETCH NEXT 100 ROWS ONLY
;