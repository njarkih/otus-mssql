-- 2. ������� 1 ������ �� Customers, ������� ���� ���� ���������
DELETE TOP (1) 
FROM Sales.Customers
OUTPUT deleted.*
WHERE CustomerName LIKE 'MyIns %'
;