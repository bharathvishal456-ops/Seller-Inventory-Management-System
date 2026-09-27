-- Week 3: Seller & Inventory Management System
CREATE DATABASE IF NOT EXISTS seller_inventory_db;
USE seller_inventory_db;

DROP TABLE IF EXISTS Inventory;
DROP TABLE IF EXISTS Product;
DROP TABLE IF EXISTS Seller;

CREATE TABLE Seller (
    Seller_ID INT PRIMARY KEY AUTO_INCREMENT,
    Seller_Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    Phone VARCHAR(15) NOT NULL UNIQUE,
    Address VARCHAR(255) NOT NULL
);

CREATE TABLE Product (
    Product_ID INT PRIMARY KEY AUTO_INCREMENT,
    Product_Name VARCHAR(100) NOT NULL,
    Price DECIMAL(10,2) NOT NULL CHECK (Price > 0),
    Seller_ID INT NOT NULL,
    FOREIGN KEY (Seller_ID) REFERENCES Seller(Seller_ID)
);

CREATE TABLE Inventory (
    Inventory_ID INT PRIMARY KEY AUTO_INCREMENT,
    Product_ID INT NOT NULL UNIQUE,
    Seller_ID INT NOT NULL,
    Stock_Quantity INT NOT NULL CHECK (Stock_Quantity >= 0),
    Stock_Status VARCHAR(20) NOT NULL CHECK (Stock_Status IN ('Available','Out of Stock')),
    Last_Updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (Product_ID) REFERENCES Product(Product_ID),
    FOREIGN KEY (Seller_ID) REFERENCES Seller(Seller_ID)
);

-- Sample Seller Data
INSERT INTO Seller (Seller_Name, Email, Phone, Address) VALUES
('Ravi Traders','ravi@gmail.com','9876543210','Thoothukudi'),
('Kumar Electronics','kumar@gmail.com','9876543211','Madurai'),
('Siva Stores','siva@gmail.com','9876543212','Tirunelveli');

-- Sample Product Data
INSERT INTO Product (Product_Name, Price, Seller_ID) VALUES
('Keyboard',750.00,1),
('Mouse',450.00,1),
('Monitor',8500.00,2),
('USB Cable',250.00,2),
('Headphones',1200.00,3),
('Webcam',2200.00,3);

-- Sample Inventory Data
INSERT INTO Inventory (Product_ID, Seller_ID, Stock_Quantity, Stock_Status) VALUES
(1,1,25,'Available'),
(2,1,8,'Available'),
(3,2,0,'Out of Stock'),
(4,2,15,'Available'),
(5,3,5,'Available'),
(6,3,30,'Available');

-- Seller CRUD
INSERT INTO Seller (Seller_Name, Email, Phone, Address)
VALUES ('New Seller','new@seller.com','9876543213','Chennai');

SELECT * FROM Seller;

UPDATE Seller
SET Address = 'Coimbatore'
WHERE Seller_ID = 1;

DELETE FROM Seller WHERE Seller_ID = 4;

-- Assign a product to a seller
UPDATE Product
SET Seller_ID = 2
WHERE Product_ID = 1;

-- Display products supplied by each seller
SELECT s.Seller_Name, p.Product_ID, p.Product_Name, p.Price
FROM Seller s
JOIN Product p ON s.Seller_ID = p.Seller_ID
ORDER BY s.Seller_Name;

-- Count products supplied by each seller
SELECT s.Seller_Name, COUNT(p.Product_ID) AS Product_Count
FROM Seller s
LEFT JOIN Product p ON s.Seller_ID = p.Seller_ID
GROUP BY s.Seller_ID, s.Seller_Name;

-- Inventory Operations
SELECT p.Product_Name, i.Stock_Quantity
FROM Product p
JOIN Inventory i ON p.Product_ID = i.Product_ID
WHERE i.Stock_Quantity > 0;

SELECT p.Product_Name, i.Stock_Quantity
FROM Product p
JOIN Inventory i ON p.Product_ID = i.Product_ID
WHERE i.Stock_Quantity = 0;

SELECT p.Product_Name, i.Stock_Quantity
FROM Product p
JOIN Inventory i ON p.Product_ID = i.Product_ID
WHERE i.Stock_Quantity < 10;

UPDATE Inventory
SET Stock_Quantity = 20,
    Stock_Status = 'Available'
WHERE Inventory_ID = 2;

-- Delete discontinued inventory
DELETE FROM Inventory
WHERE Product_ID = 3;

-- Reports
SELECT s.Seller_Name, p.Product_Name, i.Stock_Quantity, i.Stock_Status
FROM Seller s
JOIN Product p ON s.Seller_ID = p.Seller_ID
JOIN Inventory i ON p.Product_ID = i.Product_ID
ORDER BY s.Seller_Name;

SELECT p.Product_Name, i.Stock_Quantity, i.Stock_Status
FROM Product p
JOIN Inventory i ON p.Product_ID = i.Product_ID;

SELECT SUM(Stock_Quantity) AS Total_Available_Stock
FROM Inventory
WHERE Stock_Quantity > 0;

SELECT COUNT(*) AS Out_of_Stock_Products
FROM Inventory
WHERE Stock_Quantity = 0;

SELECT p.Product_Name, i.Stock_Quantity
FROM Product p
JOIN Inventory i ON p.Product_ID = i.Product_ID
WHERE i.Stock_Quantity = (SELECT MAX(Stock_Quantity) FROM Inventory);

SELECT AVG(Stock_Quantity) AS Average_Inventory_Quantity
FROM Inventory;
