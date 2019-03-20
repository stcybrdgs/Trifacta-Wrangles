-- CREATE mock-up target data table for
-- Northwind Demo, Refined Stage

USE Northwind;
-- DROP existing table
IF EXISTS (SELECT * FROM Orders_OrderDetails) DROP TABLE Order_OrderDetails;

-- Create table View joining Orders and OrderDetails
CREATE VIEW Ordrs_OrdrDtls2 
AS
SELECT o.OrderID as OrderID,
       o.CustomerID as CustomerID,
	   o.OrderDate as OrderDate,
	   od.UnitPrice as UnitPrice, 
	   od.Quantity as Quantity,
	   ROUND(od.Discount, 2) as Discount
FROM Orders as o
JOIN [Order Details] as od
on o.OrderID = od.OrderID; 	  

-- Look at new View to confirm structure and contents
SELECT TOP 15 * FROM Ordrs_OrdrDtls;

-- JOIN Orders to [Order Details]
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

