-- 2
--  ѕоставщиков, у которых не было сделано ни одного заказа (потом покажем как это делать через подзапрос, сейчас сделайте через JOIN)
SELECT 
  s.SupplierID
, s.SupplierName
FROM Purchasing.Suppliers s
LEFT JOIN Purchasing.PurchaseOrders o ON s.SupplierID = o.SupplierID
WHERE o.PurchaseOrderID IS NULL
;