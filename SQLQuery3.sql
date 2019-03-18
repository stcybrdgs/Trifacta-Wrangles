-- SSMS Query prep
-- Trifacta wrangles for Northwind workflow

CREATE TABLE MyAddress(
 DelAddress TEXT
);
UPDATE MyAddress SET DelAddress = (SELECT ShipAddress FROM Orders) WHERE 
SELECT ShipAddress FROM Orders


-- Northwind Order Join
CREATE TABLE Orders_OrderDetails(
    CustomerID nchar(5),
	OrderDate datetime,
	ShipCity nvarchar(15),
	ShipRegion nvarchar(15),
	ShipCountry nvarchar(15),
	ProductID int,
	UnitPrice money,
	Qty smallint,
	Discount real
);


-- inserts for Northwind
SELECT * INTO Orders_OrderDetails2 
FROM(
	SELECT 
	-- o
	o.OrderID as OrderID, o.CustomerID as CustomerID, o.OrderDate as OrderDate, o.ShipCity as ShipCity, 
	o.ShipRegion as ShipRegion, o.ShipCountry as ShipCountry,
	-- od
	od.ProductID as ProductID, od.UnitPrice as UnitPrice, 
	od.Quantity as Qty, od.Discount as Discount
	FROM Orders AS o
	JOIN [Order Details] as od
	ON o.OrderID = od.OrderID
)


SELECT o.CustomerID as CustomerID, 	   
       FORMAT(o.OrderDate, 'yyyy') as OrderYear,
       CASE 
	       WHEN FORMAT(o.OrderDate, 'MM') in (1,2,3) THEN 'Q1'
		   WHEN FORMAT(o.OrderDate, 'MM') in (4,5,6) THEN 'Q2'
		   WHEN FORMAT(o.OrderDate, 'MM') in (7,8,9) THEN 'Q3'
		   WHEN FORMAT(o.OrderDate, 'MM') in (10,22,12) THEN 'Q4'
	   END AS FiscalQuarter,
	   ROUND(SUM(od.UnitPrice * od.Quantity),2) AS TotalPurchase 
FROM Orders as o
JOIN [Order Details] as od
ON o.OrderID = od.OrderID
GROUP BY o.CustomerID, 
         FORMAT(o.OrderDate, 'yyyy'), 
		 CASE 
	       WHEN FORMAT(o.OrderDate, 'MM') in (1,2,3) THEN 'Q1'
		   WHEN FORMAT(o.OrderDate, 'MM') in (4,5,6) THEN 'Q2'
		   WHEN FORMAT(o.OrderDate, 'MM') in (7,8,9) THEN 'Q3'
		   WHEN FORMAT(o.OrderDate, 'MM') in (10,22,12) THEN 'Q4'
	     END
ORDER BY TotalPurchase DESC;

