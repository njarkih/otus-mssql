-- 2
--  �����������, � ������� �� ���� ������� �� ������ ������ (����� ������� ��� ��� ������ ����� ���������, ������ �������� ����� JOIN)
SELECT 
  s.SupplierID
, s.SupplierName
FROM Purchasing.Suppliers s
LEFT JOIN Purchasing.PurchaseOrders o ON s.SupplierID = o.SupplierID
WHERE o.PurchaseOrderID IS NULL
;