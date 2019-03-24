-- 2. Отобразить все месяцы, где общая сумма продаж превысила 10 000 
SELECT 
  YEAR(o.OrderDate) [Year]
, MONTH(o.OrderDate) [Month]
FROM Sales.Orders o
JOIN Sales.OrderLines l ON o.OrderID = l.OrderID
WHERE o.PickingCompletedWhen IS NOT NULL
GROUP BY YEAR(o.OrderDate), MONTH(o.OrderDate)
HAVING SUM(l.Quantity * l.UnitPrice) > 10000
ORDER BY [Year], [Month]
;
