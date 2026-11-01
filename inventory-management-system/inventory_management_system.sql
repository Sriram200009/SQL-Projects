-- =====================================================================
-- Inventory Management System (PostgreSQL)
-- Question: what is running low, what is selling, and what should we
-- reorder this month?
-- Run top to bottom on an empty database: psql -d inventory -f inventory_management_system.sql
-- =====================================================================

-- ---------------------------------------------------------------------
-- 1. Schema
-- ---------------------------------------------------------------------
CREATE TABLE products (
    product_id    SERIAL PRIMARY KEY,
    product_name  VARCHAR(255)   NOT NULL,
    price         DECIMAL(10, 2) NOT NULL CHECK (price >= 0),
    category      VARCHAR(100)
);

CREATE TABLE suppliers (
    supplier_id    SERIAL PRIMARY KEY,
    supplier_name  VARCHAR(255) NOT NULL,
    contact_email  VARCHAR(255),
    phone_number   VARCHAR(15)
);

CREATE TABLE inventory (
    inventory_id   SERIAL PRIMARY KEY,
    product_id     INT NOT NULL UNIQUE REFERENCES products (product_id),
    supplier_id    INT NOT NULL REFERENCES suppliers (supplier_id),
    quantity       INT NOT NULL DEFAULT 0 CHECK (quantity >= 0),  -- stock can never go negative
    reorder_level  INT NOT NULL DEFAULT 0,                        -- reorder when stock falls to this level
    last_updated   DATE NOT NULL DEFAULT CURRENT_DATE
);

CREATE TYPE transaction_type AS ENUM ('sale', 'purchase');

CREATE TABLE transactions (
    transaction_id    SERIAL PRIMARY KEY,
    product_id        INT NOT NULL REFERENCES products (product_id),
    type              transaction_type NOT NULL,
    transaction_date  DATE NOT NULL DEFAULT CURRENT_DATE,
    quantity          INT NOT NULL CHECK (quantity > 0)
);

-- ---------------------------------------------------------------------
-- 2. Reference data and opening stock
-- ---------------------------------------------------------------------
INSERT INTO products (product_name, price, category) VALUES
('Laptop',     1200.00, 'Electronics'),
('Desk Chair',  150.00, 'Furniture'),
('Notebook',      2.50, 'Stationery'),
('Spoons',        1.60, 'Cutlery');

INSERT INTO suppliers (supplier_name, contact_email, phone_number) VALUES
('ABC Tech Info', 'contact@abctech.example',   '1234567891'),
('Home Furnish',  'contact@homefurnish.example', '9988234567'),
('Paper Co',      'contact@paperco.example',   '3004001122'),
('Kitchen Supply','contact@kitchen.example',   '7889662346');

INSERT INTO inventory (product_id, quantity, supplier_id, reorder_level) VALUES
(1,   30, 1,  20),   -- Laptops
(2,   40, 2,  25),   -- Desk chairs
(3,  700, 3, 300),   -- Notebooks
(4, 1200, 4, 500);   -- Spoons

-- ---------------------------------------------------------------------
-- 3. Keep stock in sync automatically
--    Every sale reduces stock and every purchase adds to it, so stock
--    never has to be updated by hand. A sale larger than the stock on
--    hand fails (CHECK quantity >= 0), which prevents overselling.
-- ---------------------------------------------------------------------
CREATE OR REPLACE FUNCTION apply_transaction_to_stock()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE inventory
    SET quantity = quantity + CASE WHEN NEW.type = 'purchase' THEN NEW.quantity
                                   ELSE -NEW.quantity END,
        last_updated = NEW.transaction_date
    WHERE product_id = NEW.product_id;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_apply_transaction_to_stock
AFTER INSERT ON transactions
FOR EACH ROW EXECUTE FUNCTION apply_transaction_to_stock();

-- ---------------------------------------------------------------------
-- 4. Sample movements across two months
-- ---------------------------------------------------------------------
INSERT INTO transactions (product_id, type, transaction_date, quantity) VALUES
(1, 'purchase', '2025-05-02',   30),
(2, 'purchase', '2025-05-03',   25),
(3, 'purchase', '2025-05-05',  400),
(2, 'sale',     '2025-05-12',   15),
(1, 'sale',     '2025-05-15',    5),
(4, 'purchase', '2025-05-18', 1200),
(4, 'sale',     '2025-05-25', 1100),
(3, 'purchase', '2025-06-02',  300),
(2, 'purchase', '2025-06-04',   30),
(4, 'purchase', '2025-06-06', 1100),
(1, 'sale',     '2025-06-10',   48),
(2, 'sale',     '2025-06-14',   62),
(3, 'sale',     '2025-06-18', 1150),
(4, 'sale',     '2025-06-22',  900);

-- ---------------------------------------------------------------------
-- 5. Questions the business actually asks
-- ---------------------------------------------------------------------

-- Q1. What is in stock right now?
SELECT p.product_name, i.quantity, i.reorder_level, i.last_updated
FROM inventory i
JOIN products p ON p.product_id = i.product_id
ORDER BY p.product_id;

-- Q2. What needs reordering, and from whom?
CREATE VIEW reorder_list AS
SELECT p.product_name,
       i.quantity                AS in_stock,
       i.reorder_level,
       s.supplier_name,
       s.contact_email
FROM inventory i
JOIN products  p ON p.product_id  = i.product_id
JOIN suppliers s ON s.supplier_id = i.supplier_id
WHERE i.quantity <= i.reorder_level;

SELECT * FROM reorder_list;

-- Q3. Monthly sales by product: units and value, ranked within each month
WITH monthly AS (
    SELECT DATE_TRUNC('month', t.transaction_date)::date AS month,
           p.product_name,
           SUM(t.quantity)           AS units_sold,
           SUM(t.quantity * p.price) AS sales_value
    FROM transactions t
    JOIN products p ON p.product_id = t.product_id
    WHERE t.type = 'sale'
    GROUP BY 1, p.product_name
)
SELECT month, product_name, units_sold, sales_value,
       RANK() OVER (PARTITION BY month ORDER BY sales_value DESC) AS rank_by_value
FROM monthly
ORDER BY month, rank_by_value;

-- Q4. Stock reconciliation: does stock on hand equal opening stock plus
--     purchases minus sales? Any non-zero gap points to a data problem.
WITH movements AS (
    SELECT product_id,
           SUM(CASE WHEN type = 'purchase' THEN quantity ELSE -quantity END) AS net_movement
    FROM transactions
    GROUP BY product_id
),
opening AS (
    SELECT * FROM (VALUES (1, 30), (2, 40), (3, 700), (4, 1200)) AS o (product_id, opening_stock)
)
SELECT p.product_name,
       o.opening_stock,
       m.net_movement,
       i.quantity                                     AS stock_on_hand,
       i.quantity - (o.opening_stock + m.net_movement) AS gap
FROM inventory i
JOIN products  p USING (product_id)
JOIN opening   o USING (product_id)
JOIN movements m USING (product_id)
ORDER BY p.product_id;

-- Q5. Guardrail check: overselling is rejected (expected to fail)
-- INSERT INTO transactions (product_id, type, quantity) VALUES (1, 'sale', 1000);
