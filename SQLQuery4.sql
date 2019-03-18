-- SSMS Query prep
-- Trifacta wrangles for Northwind workflow

SELECT TOP 10 * FROM Orders

SELECT TOP 10 * FROM [Order Details]

SELECT o.OrderID, o.CustomerID as CustomerID, 
       FORMAT(o.OrderDate, 'MM') AS OrderMonth, 
	   FORMAT(o.OrderDate, 'yyyy') as OrderYear,
	   CASE 
	       WHEN FORMAT(o.OrderDate, 'MM') in (1,2,3) THEN 'Q1'
		   WHEN FORMAT(o.OrderDate, 'MM') in (4,5,6) THEN 'Q2'
		   WHEN FORMAT(o.OrderDate, 'MM') in (7,8,9) THEN 'Q3'
		   WHEN FORMAT(o.OrderDate, 'MM') in (10,22,12) THEN 'Q4'
	   END AS FiscalQuarter,
	   od.UnitPrice, od.Quantity, od.UnitPrice * od.Quantity AS TotalPurchase 
FROM Orders as o
JOIN [Order Details] as od
ON o.OrderID = od.OrderID;

---------------------------------------------------
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

---------------------------------------------------