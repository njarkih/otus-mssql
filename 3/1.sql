-- 1. Довставлять в базу 5 записей используя insert в таблицу Customers или Suppliers 
INSERT Sales.Customers (
  CustomerName
, BillToCustomerID
, CustomerCategoryID
, BuyingGroupID
, PrimaryContactPersonID
, AlternateContactPersonID
, DeliveryMethodID
, DeliveryCityID
, PostalCityID
, CreditLimit
, AccountOpenedDate
, StandardDiscountPercentage
, IsStatementSent
, IsOnCreditHold
, PaymentDays
, PhoneNumber
, FaxNumber
, DeliveryRun
, RunPosition
, WebsiteURL
, DeliveryAddressLine1
, DeliveryAddressLine2
, DeliveryPostalCode
, DeliveryLocation
, PostalAddressLine1
, PostalAddressLine2
, PostalPostalCode
, LastEditedBy
)
OUTPUT inserted.*
SELECT TOP 5
  'MyIns ' + CustomerName
, BillToCustomerID
, CustomerCategoryID
, BuyingGroupID
, PrimaryContactPersonID
, AlternateContactPersonID
, DeliveryMethodID
, DeliveryCityID
, PostalCityID
, CreditLimit + 100
, AccountOpenedDate
, StandardDiscountPercentage
, IsStatementSent
, IsOnCreditHold
, PaymentDays
, PhoneNumber
, FaxNumber
, DeliveryRun
, RunPosition
, WebsiteURL
, DeliveryAddressLine1
, DeliveryAddressLine2
, DeliveryPostalCode
, DeliveryLocation
, PostalAddressLine1
, PostalAddressLine2
, PostalPostalCode
, LastEditedBy
FROM Sales.Customers
ORDER BY CustomerID DESC
;
