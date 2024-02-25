
-- check how many products are in each warehouse 
SELECT warehouseCode, COUNT(*) as count
FROM products
GROUP BY warehouseCode
ORDER BY count DESC ;


SELECT warehouseCode, COUNT(*) as count, productLine
FROM products
GROUP BY warehouseCode, productLine
ORDER BY count DESC;


-- showing the number of each warehouse in the product and their corresponding total quantity in stock 
-- showing the size of each warehouse in descending order 
SELECT warehouseCode, COUNT(*) as count, SUM(quantityInStock) as totalQuantity, productLine 
FROM products
GROUP BY warehouseCode, productLine 
ORDER BY totalQuantity DESC;

-- to check the distinct number of product line 
SELECT DISTINCT(productLine) from products; 

-- to check how many products are in each warehouse 
SELECT productLine, warehouseCode, COUNT(*) AS count from products 
GROUP BY warehouseCode, productLine
ORDER BY count DESC ;

-- to check the total quantity of the product line in each warehouse 
SELECT warehouseCode,  SUM(quantityInStock) as totalQuantity, productLine
FROM products
GROUP BY warehouseCode, productLine
ORDER BY totalQuantity DESC;
 

-- to check the percentage of remianing stock in each warehouse 
SELECT warehouseCode, productLine,
       COUNT(products.productCode) AS productCount,
       SUM(quantityInStock) AS totalQuantityInStock,
       SUM(quantityOrdered) AS totalQuantityOrdered,
       (SUM(quantityInStock) - SUM(quantityOrdered)) AS remainingStock,
       ((SUM(quantityInStock) - SUM(quantityOrdered)) / SUM(quantityInStock)) * 100 AS remainingStockPercentage
FROM products
INNER JOIN orderdetails ON products.productCode = orderdetails.productCode
GROUP BY warehouseCode, productLine
ORDER BY remainingStockPercentage DESC;


-- to check the profit percentage by product line 
SELECT warehouseCode, productLine,
       COUNT(products.productCode) AS productCount,
       SUM(buyPrice) AS totalBuyPrice,
       SUM(priceEach) AS totalPriceEach,
       (SUM(priceEach) - SUM(buyPrice)) AS profit,
       ((SUM(priceEach) - SUM(buyPrice)) / SUM(buyPrice)) * 100 AS profitPercentage
FROM products
INNER JOIN orderdetails ON products.productCode = orderdetails.productCode
GROUP BY warehouseCode, productLine
ORDER BY profitPercentage DESC;

-- to check the profit percentage by warehouse 
SELECT warehouseCode,
       COUNT(products.productCode) AS productCount,
       SUM(buyPrice) AS totalBuyPrice,
       SUM(priceEach) AS totalPriceEach,
       (SUM(priceEach) - SUM(buyPrice)) AS profit,
       ((SUM(priceEach) - SUM(buyPrice)) / SUM(buyPrice)) * 100 AS profitPercentage
FROM products
INNER JOIN orderdetails ON products.productCode = orderdetails.productCode
GROUP BY warehouseCode
ORDER BY profitPercentage DESC;


-- turn over by productline and warehouse 
SELECT
    p.productLine, warehouseCode,
    SUM(p.quantityinstock) AS TotalQuantityInStock,
    SUM(cogs_query.COGS) AS TotalCOGS,
    SUM(p.quantityinstock) / SUM(cogs_query.COGS) AS InventoryTurnover
FROM
    products p
JOIN
    (
        SELECT
            p.productLine,
            SUM(od.quantityordered * od.priceeach) AS COGS
        FROM
            products p
        JOIN
            orderdetails od ON p.productcode = od.productcode
        GROUP BY
            p.productLine
    ) AS cogs_query
ON
    p.productLine = cogs_query.productLine
GROUP BY
    p.productLine,warehouseCode
ORDER BY InventoryTurnover DESC;


-- calculating inventory Turnover by warehouse 
SELECT
    p.warehouseCode,
    SUM(p.quantityinstock) AS TotalQuantityInStock,
    SUM(cogs_query.COGS) AS TotalCOGS,
    SUM(p.quantityinstock) / SUM(cogs_query.COGS) AS InventoryTurnover
FROM
    products p
JOIN
    (
        SELECT
            p.warehouseCode,
            SUM(od.quantityordered * od.priceeach) AS COGS
        FROM
            products p
        JOIN
            orderdetails od ON p.productcode = od.productcode
        GROUP BY
            p.warehouseCode
    ) AS cogs_query
ON
    p.warehouseCode = cogs_query.warehouseCode
GROUP BY
    p.warehouseCode
ORDER BY InventoryTurnover DESC;

-- to chheck the percentage of remaining stock of different claasic cars in the warehouse 
select  p.productName, p.quantityInStock, o.quantityOrdered, (p.quantityInStock- o.quantityOrdered) / (p.quantityInStock) * 100 AS remainingStockPercentage
from products p 
INNER JOIN orderdetails o
on p.productCode = o.productCode 
WHERE productLine LIKE '%classic%'
ORDER BY remainingStockPercentage ;


 


