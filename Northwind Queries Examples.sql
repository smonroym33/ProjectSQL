-- SELECT Example

Select *
From Suppliers


--SELECT Column Example

Select SupplierID, SupplierName, City, Country 
From Suppliers
Where Country='Germany'


--SELECT DISTINCT Example

Select distinct Country
From Suppliers


--SELECT DISTINCT and COUNT Example

Select Count(distinct Country)
From Suppliers


----WHERE CLAUSE EXAMPLES

-- WHERE Clause Examples with Text Fields

Select *
From Suppliers
Where Country='USA'

-- WHERE Clause Examples with Numeric Fields

Select *
From Suppliers
Where SupplierID=12


--WHERE Clause Examples with AND 

Select *
From Suppliers
Where Country = 'USA' and City = 'Boston'


Select *
From Customers
Where Country='UK' and City='London'


--WHERE Clause Examples with OR

Select *
From Customers
Where Country='Mexico' OR Country='USA'


--WHERE Clause Examples with NOT <> 

Select *
From Customers
Where Country<>'USA'


--WHERE Clause Examples Combining AND, OR and NOT

Select * 
From Customers
Where Country='Brazil' and (City='Sao Paulo' or City='Rio de Janeiro')


--WHERE Clause Examples using <> operator and AND

Select * 
From Customers
Where Country<>'Mexico' and Country<>'Brazil'



--WHERE Clause with NOT 

Select * 
From Customers
Where Not Country='Spain' and not Country='Germany'


----ORDER BY EXAMPLES


Select * 
From Customers 
Order by country

--ORDER BY DESC Example

Select * 
From Customers 
Order by country DESC


--ORDER BY Several Columns Example

Select *
From Customers
Order by Country, companyName


--ORDER BY Several Columns Example 2

Select *
From Customers
Order by Country asc, companyName desc



-- INSERT INTO Examples


Insert Into Customers(customerID, companyName, contactName, contactTitle, city, country)
Values('CARDI', 'Cardinal Foods', 'Tom B. Hanks', 'Administrator', 'New York', 'USA')


--Check inserted row in Customers table

Select * 
From Customers
Where companyName='Cardinal Foods'


-- Order Table by customerID Column

Select *
From Customers 
Order By customerID


----Insert Data Only in Specified Columns

Insert Into Customers(companyName, City, Country)
values ('Mamma Mia', 'Roma', 'Italy')


--Check inserted row in Customers table

Select * 
From Customers
Where companyName='Mamma Mia'


--The IS NULL Operator

Select * 
From Customers
Where ContactName is Null


--The IS NOT NULL Operator

Select * 
From Customers
Where ContactName is not null


-- UPDATE Table 


-- Test Customer record Before Update

Select * 
From Customers
Where CustomerID='CARDI'


--Update for CustomerID = 'CARDI'

--update Customers

Set ContactName='Robert Redford', City='Atlanta'
Where CustomerID='CARDI'


-- Test Customer record After Update

Select * 
From Customers
Where CustomerID='CARDI'


--UPDATE Multiple Records

-- Test Customer record Before Update

Select * 
From Customers
Where Country='Mexico'


--Update for Country='Mexico'
--Update Customers


Set contactName='Juan'
Where Country='Mexico'


-- Test Customer record After Update

Select * 
From Customers
Where Country='Mexico'


--Update back to original state of Customers table

--Update Customers


Set ContactName='Ana Trujillo'
Where CustomerID='ANATR'

--Update Customers

--Set ContactName='Antonio Moreno'
--Where CustomerID='ANTON'

--Update Customers

Set ContactName='Francisco Chang'
Where CustomerID='CENTC'

--Update Customers

Set ContactName='Guillermo Fernández'
Where CustomerID='PERIC'

--Update Customers

Set ContactName='Miguel Angel Paolino'
Where CustomerID='TORTU'


--SQL DELETE Example

Delete 
From Customers
Where contactName='Thomas Hardy'


--Test the deletion from Customers table

Select * 
From Customers
where contactName='Thomas Hardy'


--Delete the companyName='Antonio Moreno Taqueria'

Delete 
From Customers
Where companyName='Antonio Moreno Taqueria'


--Test the deletion from Customers table

Select * 
From Customers
Where companyName='Antonio Moreno Taqueria'


--SQL TOP

Select top 3 * 
From Customers


--SQL TOP PERCENT Example

Select top 50 percent * 
From Customers


--Top with ADD a WHERE CLAUSE

Select top 3 * 
From Customers
Where Country='Germany'


-- Test products record Before Update

Select *
From products


--MIN() Example

Select MIN(unitPrice) As SmallestPrice
From Products

--MAX() Example

Select MAX(unitPrice) As LargestPrice
From Products

--COUNT() Example

Select COUNT(ProductID) As TotalNumOfProducts
From Products


--AVG() Example

Select AVG(unitPrice) As AvgPrice
From Products


--SUM() Example

Select SUM(quantity) As TotalQuantityOfOrderDetails
From order_details


--SQL LIKE Examples

--companyName starting with "a":

Select * 
From Customers
Where companyName like 'a%'


--companyName ending with "a":

Select * 
From Customers
Where companyName like '%a'


--companyName that have "or" in any position:


Select * 
From Customers
Where companyName like '%or%'


--companyName that have "r" in the second position:

Select * 
From Customers
Where companyName like '_r%'


--companyName that starts with "a" and are at least 3 characters in length:

Select * 
From Customers
Where companyName like 'a_%_%'


--contactName that starts with "a" and ends with "o":

Select * 
From Customers
Where contactName like 'a%o'


--companyName that does NOT start with "a":

Select * 
From Customers
Where companyName not like 'a%'


--Using the [charlist] Wildcard

Select * 
From Customers
Where City like '[bsp]%'



--IN Operator Examples

-Select * 
From Customers
Where Country in ('Germany', 'France', 'UK')


--NOT located in "Germany", "France" or "UK":

Select * 
From Customers
Where Country not in ('Germany', 'France', 'UK')


--Select all customers that are from the same countries as the suppliers:

Select * 
From Customers
Where Country in (select Country from Suppliers)


--BETWEEN Example

Select * 
From Products
Where unitPrice between 10 and 20


--NOT BETWEEN Example

Select * 
From Products
Where unitPrice not between 10 and 20


--selects all products with a price BETWEEN 10 and 20. In addition; do not show products with a CategoryID of 1,2, or 3:

Select * 
From Products
Where (unitPrice between 10 and 20) and CategoryID not in (1, 2, 3)


--Select all products with a ProductName BETWEEN 'Carnarvon Tigers' and 'Mozzarella di Giovanni':

Select * 
From Products
Where ProductName between 'Carnarvon Tigers' and 'Mozzarella di Giovanni'
Order by ProductName


select all products with a ProductName NOT BETWEEN 'Carnarvon Tigers' and 'Mozzarella di Giovanni':

Select * from Products
Where ProductName not between 'Carnarvon Tigers' and 'Mozzarella di Giovanni'
Order by ProductName


--Selects all orders with an OrderDate BETWEEN '2014-02-03' and '2014-02-28':

Select * 
From Orders
Where OrderDate between '2014-02-03' and '2014-02-28'


--Alias for Columns Examples

Select CustomerID as ID, contactName as contact
From Customers


--It requires double quotation marks or square brackets if the alias name contains spaces:


Select companyName as Company, ContactName as [Contact Person]
From Customers


--creates an alias named "Address" that combine four columns (Address, PostalCode, City and Country):


Select SupplierName, Address+', '+City+', '+Country+', '+PostalCode as Address
From Suppliers


--Alias for Tables Example


Select o.OrderID, o.OrderDate, c.companyName
From Customers as c, Orders as o
Where c.companyName='Around the Horn' and c.CustomerID=o.CustomerID


--SQL JOIN

Select Orders.OrderID, Customers.companyName, Orders.OrderDate
From Orders 
inner join Customers
       -- on Orders.CustomerID=Customers.CustomerID

--JOIN Three Tables

select ord.OrderID, cus.companyName, shp.companyName as ShipperCompanyName
from (orders ord inner join customers cus
	  on ord.CustomerID=cus.CustomerID) 
            inner join shippers shp
           on ord.ShipperID=shp.ShipperID


