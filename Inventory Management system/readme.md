# 📦 Inventory Management System (WIP)

This is a **SQL-based Inventory Management System** built from scratch to track products, suppliers, stock, and transactions such as purchases and sales. The aim is to simulate and analyze real-time inventory flow and generate insightful reports using SQL.

> ⚠️ This project is currently in development. More queries and analytical logic will be added as the system evolves!

---

## 📌 Features So Far

- Relational schema design with `Products`, `Suppliers`, `Inventory`, and `Transactions`
- Data insertion with meaningful sample records
- Joining tables to monitor stock levels
- Use of CASE expressions to perform bulk updates after sales
- Aggregate queries to summarize transactions and product performance
- Monthly sales reports by product quantity and value

---

## 🧱 Schema Overview

### Tables Created:
- `Products` — stores product details like name, price, and category
- `Suppliers` — supplier contact details
- `Inventory` — tracks stock and supplier linkage
- `Transactions` — logs both purchase and sales activity using ENUM for type control

### Relationships:
- `Inventory.product_id` → `Products.product_id`
- `Inventory.supplier_id` → `Suppliers.supplier_id`
- `Transactions.product_id` → `Products.product_id`

---

## 🔍 Sample Queries Implemented

- View current inventory levels
- Insert sales transactions and update stock accordingly
- Retrieve products low on stock
- Generate monthly sales report:
  - Top products by **sales quantity**
  - Top products by **sales value**

---

## 📊 Example Insights

```sql
-- Top 2 products by sales value for June 2025
SELECT p.product_name, SUM(t.quantity) AS total_sales, 
       SUM(t.quantity) * p.price AS total_sales_amount
FROM transactions t
JOIN products p ON p.product_id = t.product_id
WHERE type = 'sale' AND transaction_date BETWEEN '2025-06-01' AND '2025-06-30'
GROUP BY p.product_name, p.price
ORDER BY total_sales_amount DESC
LIMIT 2;
```

---

## 🛠️ Next Steps

- Add restock threshold alerts
- Supplier performance analysis
- Predictive sales trends based on historical data
- User interface or data visualization layer

---

## 📁 How to Use

Clone the repository and run the scripts in your favorite PostgreSQL client (e.g., pgAdmin). All code is written with PostgreSQL syntax and may need minor adjustments for other SQL flavors.

---

## 🤝 Contributions Welcome

Feel free to fork this repository, suggest improvements, or share feedback. This is a learning-driven project, and I’m excited to expand it further!
