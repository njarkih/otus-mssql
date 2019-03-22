-- 5. Объясните, что делает и оптимизируйте запрос:

-- Исходный запрос
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

-- выводит информацию по счёт-фактурам: ид, дата, сотрудник оформивший продажу, сумма по счёт-фактуре, сумма по отгруженной продукции
-- по счёт-фактурам на сумму больше $27000
-- с сортировкой от самого крупного заказа вниз

-- для удобства чтения вынесла в cte
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
-- перенесла подзапросы из SELECT в JOIN, т.к. подзапросы в SELECT выполняются для каждой строки
JOIN Sales.Invoices i ON t.InvoiceID = i.InvoiceID
-- не стала выносить расчёт суммы продаж в отдельный подзапрос, а делаю JOIN сразу с SalesTotal 
-- чтобы ограничить количество заказов только теми, что имеют сумму по счёт-факруте > 27000
JOIN Sales.Orders o ON i.OrderId = o.OrderID
  AND o.PickingCompletedWhen IS NOT NULL 
  -- была ещё идея переписать NOT на положительное условие, например, IIF(o.PickingCompletedWhen IS NULL, 0, 1) = 1, но в плане ничего не изменилось
JOIN Sales.OrderLines l ON o.OrderID = l.OrderID 
JOIN Application.People p ON p.PersonID = i.SalespersonPersonID
GROUP BY i.InvoiceID, i.InvoiceDate, t.TotalSumm, p.FullName 
;
