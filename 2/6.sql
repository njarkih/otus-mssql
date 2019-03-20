-- 6
-- Все ид и имена клиентов и их контактные телефоны, которые покупали товар Chocolate frogs 250g
SELECT 
  c.CustomerID
, c.CustomerName
, c.PhoneNumber 
FROM Sales.Customers c
WHERE EXISTS (SELECT 1 FROM Sales.Orders o
	      JOIN Sales.OrderLines l ON o.CustomerID = c.CustomerID AND o.OrderID = l.OrderID
              JOIN Warehouse.StockItems i ON l.StockItemID = i.StockItemID
	        AND i.StockItemName = 'Chocolate frogs 250g'
	       )
;
