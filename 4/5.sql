-- 5. ���������, ��� ������ � ������������� ������:

-- �������� ������
SELECT 
  Invoices.InvoiceID, 
  Invoices.InvoiceDate,
  (SELECT People.FullName
   FROM Application.People
   WHERE People.PersonID = Invoices.SalespersonPersonID
  ) AS SalesPersonName,
  SalesTotals.TotalSumm AS TotalSummByInvoice, 
  (SELECT SUM(OrderLines.PickedQuantity*OrderLines.UnitPrice)
   FROM Sales.OrderLines
   WHERE OrderLines.OrderId = (SELECT Orders.OrderId 
                               FROM Sales.Orders
                               WHERE Orders.PickingCompletedWhen IS NOT NULL	
                               AND Orders.OrderId = Invoices.OrderId)	
   ) AS TotalSummForPickedItems
FROM Sales.Invoices 
JOIN
  (SELECT InvoiceId, SUM(Quantity*UnitPrice) AS TotalSumm
  FROM Sales.InvoiceLines
  GROUP BY InvoiceId
  HAVING SUM(Quantity*UnitPrice) > 27000) AS SalesTotals
ON Invoices.InvoiceID = SalesTotals.InvoiceID
ORDER BY TotalSumm DESC
;

-- ������� ���������� �� ����-��������: ��, ����, ��������� ���������� �������, ����� �� ����-�������, ����� �� ����������� ���������
-- �� ����-�������� �� ����� ������ $27000
-- � ����������� �� ������ �������� ������ ����

-- ��� �������� ������ ������� � cte
WITH SalesTotals AS (
  SELECT 
    l.InvoiceId
  , SUM(l.Quantity*l.UnitPrice) AS TotalSumm
  FROM Sales.InvoiceLines l
  GROUP BY l.InvoiceId
  HAVING SUM(l.Quantity*l.UnitPrice) > 27000
)
SELECT 
  i.InvoiceID 
, i.InvoiceDate
, p.FullName SalesPersomName
, t.TotalSumm
, SUM(l.PickedQuantity*l.UnitPrice) TotalSummForPickedItems
FROM SalesTotals t
-- ��������� ���������� �� SELECT � JOIN
JOIN Sales.Invoices i ON t.InvoiceID = i.InvoiceID
JOIN Sales.Orders o ON i.OrderId = o.OrderID
  AND o.PickingCompletedWhen IS NOT NULL
JOIN Sales.OrderLines l ON o.OrderID = l.OrderID 
JOIN Application.People p ON p.PersonID = i.SalespersonPersonID
GROUP BY i.InvoiceID, i.InvoiceDate, t.TotalSumm, p.FullName 
;
