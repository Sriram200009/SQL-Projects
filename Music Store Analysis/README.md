# SQL Project: Music Store Analysis
## Project Description 
Welcome to my Music Store Database Analysis project! This repository is a collection of SQL queries designed to explore and analyze data from a music store database. The objective is to uncover insights and trends to aid in decision-making and strategic planning.


## Table of Contents
- [Installation](#installation)
- [Entity relationship diagram](#Entity-relationship-diagram)
- [Usage](#usage)
- [Features](#features)
- [Questions Solved](#Questions-solved)
- [Contributing](#contributing)
- [License](#license)
- [Acknowledgements](#acknowledgements)

## Installation
To get a copy of this project up and running on your local machine, follow these steps:
1. Clone the repository:
   ```bash
   git clone https://github.com/Sriram200009/SQL-Projects.git
   ```

 ```bash
   cd SQL-Projects
   ```

```bash   
## Setting Up the Music Store Database with pgAdmin

### 1. Install PostgreSQL and pgAdmin
Ensure PostgreSQL and pgAdmin are installed on your machine. You can download and install them from their official websites:
- [PostgreSQL Installation Guide](https://www.postgresql.org/download/)
- [pgAdmin Installation Guide](https://www.pgadmin.org/download/)

### 2. Download the Music Store Database Script
You need a script to create the database schema and populate it with data. This script may be provided in your repository or obtained from an external source.

### 3. Create the Database Using pgAdmin
1. **Open pgAdmin** and log in to your PostgreSQL server.

2. **Create a New Database**:
   - Right-click on the `Databases` node in the Object Explorer and select `Create` > `Database`.
   - Name the database `music_store` and click `Save`.

### 4. Execute the SQL Script
1. **Load the SQL script**:
   - In pgAdmin, right-click on the `music_store` database in the Object Explorer.
   - Select `Query Tool` to open a new query editor window.

2. **Open the SQL script file**:
   - Click on the `Open File` icon in the query editor toolbar.
   - Navigate to the directory where your SQL script file is located and open it.

3. **Execute the script**:
   - Click the `Execute/Refresh` button (lightning bolt icon) in the query editor toolbar to run the script.
   - This script will create the necessary tables, define their schema, and populate them with initial data required for your analysis.

### 5. Verify the Database Setup
1. **List the tables** in the database to verify that they have been created:
   - In the Object Explorer, expand the `Schemas` > `public` > `Tables` node to see the list of tables created.

2. **Check the data** by running simple queries:
   - Open a new query editor window.
   - Run the following query to check if data has been inserted correctly:
     ```sql
     SELECT * FROM employee LIMIT 5;
     ```
```

## Entity relationship diagram

![MusicDatabaseSchema](https://user-images.githubusercontent.com/112153548/213707717-bfc9f479-52d9-407b-99e1-e94db7ae10a3.png)

## Usage

The project consists of various SQL queries that address specific business questions. To run the analysis, execute the SQL scripts using your preferred SQL client. Each query is designed to provide meaningful insights into different aspects of the music store's operations.

## Features

- **Employee Analysis:** Identify the senior most employee based on job title.
- **Invoice Insights:** Determine which countries have the most invoices and identify top invoice values.
- **Customer Analysis:** Find the best customer based on total spending and determine the city with the best customers.
- **Genre Popularity:** Analyze the most popular music genres by country.
- **Track Analysis:** Identify tracks longer than the average length and find the top rock music artists.
- **Sales and Revenue Insights:** Analyze customer spending on artists and determine the top customer by country.

## Questions Solved

### Q1: Senior Most Employee

```sql
SELECT * FROM employee
ORDER BY levels DESC LIMIT 1;
```

### Q2: Country with Most Invoices

```sql
SELECT COUNT(*) AS COUNT, billing_country 
FROM invoice
GROUP BY billing_country 
ORDER BY COUNT DESC LIMIT 1;
```

### Q3: Top 3 Invoice Values

```sql
SELECT total 
FROM invoice
ORDER BY total DESC LIMIT 3;
```

### Q4: City with Best Customers

```sql
SELECT billing_city, SUM(total) AS Grand_total 
FROM invoice
GROUP BY billing_city 
ORDER BY Grand_total DESC LIMIT 1;
```

### Q5: Best Customer

```sql
SELECT customer.customer_id, customer.first_name, customer.last_name, SUM(invoice.total)
FROM customer
JOIN invoice ON customer.customer_id = invoice.customer_id 
GROUP BY customer.customer_id 
ORDER BY SUM(total) DESC LIMIT 1;
```

### Q6: Rock Music Listeners

```sql
SELECT DISTINCT first_name, last_name, email 
FROM customer
INNER JOIN invoice ON customer.customer_id = invoice.customer_id
INNER JOIN invoice_line ON invoice.invoice_id = invoice_line.invoice_id
WHERE track_id IN (SELECT track_id FROM track
                   INNER JOIN genre ON track.genre_id = genre.genre_id
                   WHERE genre.name LIKE 'Rock')
ORDER BY email;
```

### Q7: Top 10 Rock Music Artists

```sql
SELECT artist.name, COUNT(track.track_id) AS Number_of_songs 
FROM artist
INNER JOIN album ON artist.artist_id = album.artist_id
INNER JOIN track ON album.album_id = track.album_id
WHERE track_id IN (SELECT track_id FROM track
                   INNER JOIN genre ON track.genre_id = genre.genre_id
                   WHERE genre.name LIKE 'Rock')
GROUP BY artist.name
ORDER BY Number_of_songs DESC;
```

### Q8: Tracks Longer than Average

```sql
SELECT Name, milliseconds 
FROM track 
WHERE milliseconds > (SELECT AVG(milliseconds) AS AVG_MS FROM track)
ORDER BY milliseconds DESC;
```

### Q9: Customer Spending on Artists

```sql
WITH best_selling_artist AS (
    SELECT a.artist_id AS a_id, a.name AS artist_name, 
           SUM(il.unit_price * il.quantity) AS total_sales
    FROM invoice_line il
    JOIN track t ON t.track_id = il.track_id
    JOIN album al ON al.album_id = t.album_id
    JOIN artist a ON a.artist_id = al.artist_id
    GROUP BY a.artist_id
    ORDER BY total_sales DESC
    LIMIT 1
)
SELECT c.first_name, c.last_name, bsa.artist_name, 
       SUM(il.unit_price * il.quantity) AS amount_spent
FROM invoice i
JOIN customer c ON c.customer_id = i.customer_id
JOIN invoice_line il ON il.invoice_id = i.invoice_id
JOIN track t ON t.track_id = il.track_id
JOIN album alb ON alb.album_id = t.album_id
JOIN best_selling_artist bsa ON bsa.a_id = alb.artist_id
GROUP BY c.first_name, c.last_name, bsa.artist_name
ORDER BY amount_spent DESC;
```

### Q10: Most Popular Genre by Country

```sql
WITH sales_per_country AS (
    SELECT COUNT(*) AS purchases_per_genre, 
           customer.country, genre.name, genre.genre_id
    FROM invoice_line
    JOIN invoice ON invoice.invoice_id = invoice_line.invoice_id
    JOIN customer ON customer.customer_id = invoice.customer_id
    JOIN track ON track.track_id = invoice_line.track_id
    JOIN genre ON genre.genre_id = track.genre_id
    GROUP BY customer.country, genre.name, genre.genre_id
),
max_genre_per_country AS (
    SELECT MAX(purchases_per_genre) AS max_genre_number, country
    FROM sales_per_country
    GROUP BY country
)
SELECT sales_per_country.* 
FROM sales_per_country
JOIN max_genre_per_country ON sales_per_country.country = max_genre_per_country.country
WHERE sales_per_country.purchases_per_genre = max_genre_per_country.max_genre_number;
```

### Q11: Top Customer by Country

```sql
WITH Customter_with_country AS (
    SELECT customer.customer_id, first_name, last_name, billing_country,
           SUM(total) AS total_spending,
           ROW_NUMBER() OVER (PARTITION BY billing_country ORDER BY SUM(total) DESC) AS RowNo 
    FROM invoice
    JOIN customer ON customer.customer_id = invoice.customer_id
    GROUP BY customer.customer_id, first_name, last_name, billing_country
)
SELECT * 
FROM Customter_with_country 
WHERE RowNo <= 1;
```

## Contributing
I welcome contributions from the community. If you have a SQL project you'd like to add or improvements to suggest, feel free to fork the repository, make your changes, and open a pull request.

## License
You can use this dataset to build your own project and practice your SQL skills.

## Acknowledgements
- Special thanks to the Rishabh Mishra's youTube tutorial that inspired this project https://youtu.be/VFIuIjswMKM
- Thanks to the contributors who helped refine the queries and analysis.
  
---
