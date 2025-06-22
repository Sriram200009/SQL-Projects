-- Create the Products table
CREATE TABLE Products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    category VARCHAR(100)
);

-- Create the Suppliers table
CREATE TABLE Suppliers (
    supplier_id SERIAL PRIMARY KEY,
    supplier_name VARCHAR(255) NOT NULL,
    contact_email VARCHAR(255),
    phone_number VARCHAR(15)
);

-- Create the Inventory table
CREATE TABLE Inventory (
    inventory_id SERIAL PRIMARY KEY,
    product_id INT,
    quantity INT DEFAULT 0,
    supplier_id INT,
    last_updated DATE DEFAULT CURRENT_DATE,
    FOREIGN KEY (product_id) REFERENCES Products(product_id),
    FOREIGN KEY (supplier_id) REFERENCES Suppliers(supplier_id)
);

-- Create the Transactions table

CREATE TYPE transaction_type AS ENUM ('sale', 'purchase');

CREATE TABLE Transactions (
    transaction_id SERIAL PRIMARY KEY,
    product_id INT,
    type transaction_type NOT NULL
    transaction_date DATE DEFAULT CURRENT_DATE,
    quantity INT NOT NULL,
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

--inserting Data into products table
Insert into products (product_name, Price, Category) Values
('Laptop', 1200.00, 'Electronics'), 
('Desk Chair', 150.00, 'furniture'),
('Notebook', 2.50, 'Stationery'),
('Spoons', 1.60, 'cutlery');

--inserting Data into suppliers table
Insert into suppliers (Supplier_name,Contact_email,Phone_number) Values
('ABCTechInfo', 'Contact@ABC.com', 1234567891), 
('IKEA','Contact@ikea.com', 9988234567),
('Classmate','Contact@Classmate.com', 3004001122),
('MandM', 'Contact@MandM.com', 7889662346);

--inserting Data into Inventory table
Insert into inventory (product_id,quantity,supplier_id) Values
(1, 30, 1), -- Laptops from ABCtechinfo
(2,40,2), -- Deskchair from IKEA
(3,700,3), -- Notebooks from Classmate
(4,1200,4); -- Spoons from M&M

-- Product_ID 1 for Laptop, 2 for DeskChair, 3 for Notebook and 4 for Spoons
-- Supplier_ID 1 for ABCTechinfo, 2 for IKEA, 3 for Classmate & 4 for M&M
-- inserting sample transactions
insert into transactions (product_id, type, Quantity) Values
(1, 'purchase' , 30),
(2,'purchase',25),
(3,'purchase',400),
(2,'sale',15),
(1,'sale',5),
(4,'purchase',1200),
(4,'sale',1100),
(3,'purchase',300),
(2,'purchase',30),
(4,'purchase',1100);

--Joining invetory table with products table to find available stock
Select p.product_id, i.quantity
from inventory i
Join products p on i.product_id = p.product_id;

-- Adding Sales transactions 
insert into transactions (product_id, type, Quantity) Values
(1,'sale',7),
(2,'sale', 10);

--update stock after sales
Update inventory
set quantity = quantity - 
Case product_id
when 1 then 7
when 2 then 10
else 0
End
where product_id in (1,2);

-- Checking the transactions to confirm inventory update is accurate
Select product_id, type, sum(Quantity) from transactions
where product_id = 2
Group by product_id, type

-- List of products stored in less quantity in inventory
Select p.product_name,p.product_id,i.Quantity from inventory i
join products p on p.product_id = i.product_id
order by i.quantity asc limit 2;
--Generating monthly sales report of top 2 products by value
Select p.product_name, sum (t.quantity) as total_sales, sum (t.quantity)* p.price as total_sales_amount from transactions t
join products p on p.product_id = t.product_id
where type = 'sale' and transaction_date between '2025-06-01'and '2025-06-30'
group by p.product_name, p.price
--Generating monthly sales report of top 2 products by value
Select p.product_name, sum (t.quantity) as total_sales, sum (t.quantity)* p.price as total_sales_amount from transactions t
join products p on p.product_id = t.product_id
where type = 'sale' and transaction_date between '2025-06-01'and '2025-06-30'
group by p.product_name, p.price
order by total_sales_amount Desc limit 2;

--Generating monthly sales report of top 2 products by quantity
Select p.product_name, sum (t.quantity) as total_sales from transactions t
join products p on p.product_id = t.product_id
where type = 'sale' and transaction_date between '2025-06-01'and '2025-06-30'
group by p.product_name
order by total_sales Desc limit 2;



