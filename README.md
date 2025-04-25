# E-Commerce Database Schema

This project contains the SQL schema and sample data for an e-commerce database. The database is designed to manage various aspects of an e-commerce platform, including products, brands, categories, variations, attributes, and user roles. It also includes indexes to optimize query performance and example queries to demonstrate its functionality.

## Overview

The database is named `e_commerce_db` and is structured to handle the following key components:

1. **Product Management**: Products, categories, brands, and variations.
2. **Inventory Management**: Product items (SKUs) and their stock levels.
3. **Attributes**: Product-specific attributes such as size, color, and technical specifications.
4. **User Roles and Privileges**: Role-based access control for administrators, sales users, and guest users.
5. **Performance Optimization**: Indexes on frequently queried columns to improve performance.

---

## Database Structure

### Tables

1. **Brands Table**: Stores brand information.
   ```sql
   CREATE TABLE brands(
       brand_id INT PRIMARY KEY AUTO_INCREMENT,
       brand_name VARCHAR(255) NOT NULL,
       logo_url VARCHAR(255) NOT NULL,
       description TEXT NOT NULL,
       created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
   );
   ```

2. **Product Category Table**: Organizes products into categories and subcategories.
   ```sql
   CREATE TABLE product_category(
       category_id INT PRIMARY KEY AUTO_INCREMENT,
       category_name VARCHAR(255) NOT NULL,
       parent_id INT NULL,
       description TEXT NOT NULL,
       slug VARCHAR(100) NOT NULL,
       FOREIGN KEY (parent_id) REFERENCES product_category(category_id)
   );
   ```

3. **Products Table**: Stores product details.
   ```sql
   CREATE TABLE products(
       product_id BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
       product_name VARCHAR(255) NOT NULL,
       description TEXT NOT NULL,
       base_price DECIMAL(10, 2) NOT NULL,
       brand_id INT,
       category_id INT,
       created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
       updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
       is_active BOOLEAN DEFAULT TRUE,
       FOREIGN KEY (brand_id) REFERENCES brands(brand_id),
       FOREIGN KEY (category_id) REFERENCES product_category(category_id)
   );
   ```

4. **Product Variations**: Handles variations like size and color.
   ```sql
   CREATE TABLE product_variation(
       variation_id BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
       variation_name VARCHAR(50) NOT NULL,
       product_id BIGINT UNSIGNED,
       color_id INT,
       size_id INT,
       FOREIGN KEY (product_id) REFERENCES products(product_id),
       FOREIGN KEY (color_id) REFERENCES color(color_id),
       FOREIGN KEY (size_id) REFERENCES size_category(size_id)
   );
   ```

5. **User Management**: Roles and privileges for `Admin`, `SalesUser`, and `Guestuser`.

---

## Sample Data

The database includes pre-populated data for testing and demonstration purposes:

1. **Brands**:
   ```sql
   INSERT INTO brands (brand_name, logo_url, description) VALUES
   ('Nike', 'https://example.com/logos/nike.png', 'Athletic apparel and footwear'),
   ('Apple', 'https://example.com/logos/apple.png', 'Consumer electronics and software'),
   ('Levi''s', 'https://example.com/logos/levis.png', 'Denim clothing manufacturer');
   ```

2. **Categories**:
   ```sql
   INSERT INTO product_category (category_name, parent_id, description, slug) 
   VALUES 
   ('Clothing', NULL, 'Apparel products', 'clothing'),
   ('Electronics', NULL, 'Electronic devices', 'electronics'),
   ('T-Shirts', 1, 'Casual tops', 't-shirts'),
   ('Smartphones', 2, 'Mobile devices', 'smartphones');
   ```

3. **Products**:
   ```sql
   INSERT INTO products (product_name, description, base_price, brand_id, category_id, is_active) 
   VALUES
   ('Air Max 90', 'Iconic running shoes', 120.00, 1, 1, TRUE),
   ('iPhone 13', 'Latest smartphone from Apple', 799.00, 2, 2, TRUE),
   ('501 Jeans', 'Classic denim jeans', 59.50, 3, 1, TRUE);
   ```

---

## Example Queries

### 1. Get All Products with Their Brands
This query retrieves all products along with their associated brand names and base prices.
```sql
SELECT p.product_name, b.brand_name AS brand, p.base_price 
FROM products p 
JOIN brands b ON p.brand_id = b.brand_id;
```

### 2. Get All Variations for a Product
This query retrieves all variations (e.g., size, color) for a specific product.
```sql
SELECT p.product_name, pv.variation_name 
FROM products p 
JOIN product_variation pv ON p.product_id = pv.product_id
WHERE p.product_id = 1;
```

### 3. Get Available SKUs with Variations
This query lists all SKUs along with their variations (e.g., size, color).
```sql
SELECT pi.sku, p.product_name, 
GROUP_CONCAT(CONCAT(pv.variation_name, ': ', pi_v.option_value)) AS variations
FROM product_item pi
JOIN products p ON pi.product_id = p.product_id
JOIN product_item_variation pi_v ON pi.product_item_id = pi_v.product_item_id
JOIN product_variation pv ON pi_v.variation_id = pv.variation_id
GROUP BY pi.product_item_id;
```

---

## Indexes

Indexes are added to improve query performance on frequently accessed columns. Examples include:

- **Brands Table**:
  ```sql
  CREATE INDEX idx_brand_name ON brands(brand_name);
  ```

- **Products Table**:
  ```sql
  CREATE INDEX idx_product_name ON products(product_name);
  CREATE INDEX idx_brand_id ON products(brand_id);
  CREATE INDEX idx_category_id ON products(category_id);
  ```

- **Product Variations**:
  ```sql
  CREATE INDEX idx_product_id ON product_variation(product_id);
  CREATE INDEX idx_variation_name ON product_variation(variation_name);
  ```

---

## User Roles and Privileges

1. **Admin**: Full access to manage users and grant privileges.
   ```sql
   CREATE USER 'AdminUser'@'localhost' IDENTIFIED BY 'Admin@1024';
   GRANT CREATE USER, GRANT OPTION ON *.* TO 'AdminUser'@'localhost';
   ```

2. **SalesUser**: Manage products, inventory, and related data.
   ```sql
   CREATE USER 'SalesUser'@'localhost' IDENTIFIED BY 'SalesPass123';
   GRANT SELECT, INSERT, UPDATE ON e_commerce_db.products TO 'SalesUser'@'localhost';
   ```

3. **GuestUser**: Read-only access to product and brand information.
   ```sql
   GRANT SELECT ON e_commerce_db.products TO 'GuestUser'@'localhost';
   ```

---

## Contributors

- **Liyabona Thebe**: Designed and implemented the database schema, sample data, and queries.

---

## How to Use

1. Run the SQL script in a MySQL database to create the schema and populate the data.
2. Use the example queries to test the database functionality.
3. Modify or extend the schema as needed for additional features.

---

## License

This project is for educational purposes and is not intended for production use.
