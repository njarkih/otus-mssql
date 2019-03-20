-- 4
-- ������ �����������, ������� ���� ��������� �� 2014� ��� � ��������� Road Freight ��� Post, �������� �������� ����������, ��� ����������� ���� ������������ �����
SELECT
  o.PurchaseOrderID
, CONVERT(VARCHAR(10), o.OrderDate, 104) OrderDate
, m.DeliveryMethodName
, s.SupplierName
, p.FullName ContactPerson
FROM Purchasing.PurchaseOrders o
JOIN Purchasing.Suppliers s ON o.SupplierID = s.SupplierID
JOIN Application.DeliveryMethods m ON o.DeliveryMethodID = m.DeliveryMethodID
  AND m.DeliveryMethodName IN ('Road Freight', 'Post')  
JOIN Application.People p ON o.ContactPersonID = p.PersonID 
WHERE YEAR (o.OrderDate) = 2014
;