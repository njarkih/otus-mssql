-- 1. Посчитать среднюю цену товара, общую сумму продажи по месяцам
SELECT 
  YEAR(o.OrderDate) [Year]
, MONTH(o.OrderDate) [Month]
, AVG(l.UnitPrice) AvgCost -- средняя цена товара 
, SUM(l.Quantity * l.UnitPrice) FullCost -- общая сумма продажи
FROM Sales.Orders o
JOIN Sales.OrderLines l ON o.OrderID = l.OrderID
WHERE o.PickingCompletedWhen IS NOT NULL
GROUP BY YEAR(o.OrderDate), MONTH(o.OrderDate)
ORDER BY [Year], [Month]
;
