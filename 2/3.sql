-- 3
-- Продажи с названием месяца, в котором была продажа, номером квартала, к которому относится продажа, 
-- включите также к какой трети года относится дата - каждая треть по 4 месяца, дата забора заказа должна быть задана, 
-- с ценой товара более 100$ либо количество единиц товара более 20. 
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
WHERE o.PickingCompletedWhen IS NOT NULL -- задана дата забора заказа
GROUP BY o.OrderID, o.OrderDate
HAVING SUM (l.Quantity * l.UnitPrice) > 100.00 -- цена товара больше $100   
    OR SUM (l.Quantity) > 20 -- или количество единиц более 20
ORDER BY [Quarter], Third, o.OrderDate 
;

-- Добавьте вариант этого запроса с постраничной выборкой пропустив первую 1000 и отобразив следующие 100 записей. 
-- Соритровка должна быть по номеру квартала, трети года, дате продажи
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
WHERE o.PickingCompletedWhen IS NOT NULL -- задана дата забора заказа
GROUP BY o.OrderID, o.OrderDate
HAVING SUM (l.Quantity * l.UnitPrice) > 100.00 -- цена товара больше $100   
    OR SUM (l.Quantity) > 20 -- или количество единиц более 20
ORDER BY [Quarter], Third, o.OrderDate 
 OFFSET 1000 ROWS FETCH NEXT 100 ROWS ONLY
;
