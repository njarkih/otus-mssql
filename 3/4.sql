-- 4. Написать MERGE, который вставит запись в клиенты, если ее там нет, и изменит если она уже есть

-- при первом проходе исходная запись проапдейтит имя Adriana Pena на MyMerge Adriana Pena
-- второй проход добавит новую Adriana Pena

SELECT * 
FROM Sales.Customers
WHERE CustomerName LIKE '%Adriana Pena%'
;

MERGE Sales.Customers AS t
USING (
  SELECT 
    CustomerName = 'Adriana Pena'
  , BillToCustomerID = 1055
  , CustomerCategoryID = 5
  , BuyingGroupID = NULL
  , PrimaryContactPersonID = 3255
  , AlternateContactPersonID = NULL
  , DeliveryMethodID = 3	
  , DeliveryCityID = 29158
  , PostalCityID = 29158
  , CreditLimit = 3800.00
  , AccountOpenedDate = '20151130'
  , StandardDiscountPercentage = 0.000
  , IsStatementSent = 0
  , IsOnCreditHold = 0
  , PaymentDays = 7
  , PhoneNumber = '(252) 555-0100'
  , FaxNumber = '(252) 555-0101'
  , DeliveryRun = NULL
  , RunPosition = NULL
  , WebsiteURL = 'http://www.microsoft.com/'
  , DeliveryAddressLine1 = 'Shop 17'
  , DeliveryAddressLine2 = '121 Valentina Road'
  , DeliveryPostalCode = '90055'
  , DeliveryLocation = 0xE6100000010C3425A314BEAD4140F8BE5D9BB22854C0
  , PostalAddressLine1 = 'PO Box 3235'
  , PostalAddressLine2 = 'Girishville'
  , PostalPostalCode = '90055'
  , LastEditedBy = 1
) AS s
ON t.CustomerName = s.CustomerName 
WHEN MATCHED   
    THEN UPDATE SET t.CustomerName = 'MyMerge ' + t.CustomerName
WHEN NOT MATCHED BY TARGET
THEN INSERT (
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
     VALUES (
       s.CustomerName
     , s.BillToCustomerID
     , s.CustomerCategoryID
     , s.BuyingGroupID
     , s.PrimaryContactPersonID
     , s.AlternateContactPersonID
     , s.DeliveryMethodID
     , s.DeliveryCityID
     , s.PostalCityID
     , s.CreditLimit
     , s.AccountOpenedDate
     , s.StandardDiscountPercentage
     , s.IsStatementSent
     , s.IsOnCreditHold
     , s.PaymentDays
     , s.PhoneNumber
     , s.FaxNumber
     , s.DeliveryRun
     , s.RunPosition
     , s.WebsiteURL
     , s.DeliveryAddressLine1
     , s.DeliveryAddressLine2
     , s.DeliveryPostalCode
     , s.DeliveryLocation
     , s.PostalAddressLine1
     , s.PostalAddressLine2
     , s.PostalPostalCode
     , s.LastEditedBy
     )
OUTPUT $action, inserted.*, deleted.*
;

SELECT * 
FROM Sales.Customers
WHERE CustomerName LIKE '%Adriana Pena%'
;
