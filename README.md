Collecting workspace information# E-Commerce Database Schema

This project contains the SQL schema and data for an e-commerce database. The database is designed to manage products, brands, categories, variations, and user roles for an e-commerce platform. It includes tables for storing product details, variations, attributes, and user management, along with indexes to optimize query performance.

## Features

- **Database Name**: `e_commerce_db`
- **Tables**:
  - `brands`: Stores brand information.
  - `product_category`: Organizes products into categories and subcategories.
  - `size_category` and `size_options`: Manage size-related data.
  - `color`: Stores color options for products.
  - `attribute_category` and `attribute_type`: Define product attributes.
  - `products`: Stores product details.
  - `product_variation`: Manages product variations (e.g., size, color).
  - `product_images`: Stores product images.
  - `product_item`: Tracks individual product SKUs and inventory.
  - Junction tables for managing relationships between variations, colors, and sizes.
  - `product_attribute`: Stores additional attributes for products.
- **User Management**:
  - Roles: `Admin`, `SalesUser`, and `Guestuser`.
  - Privileges: Granular access control for managing products, inventory, and reference data.
- **Indexes**: Optimized for faster queries on frequently accessed columns.

## Data

The database includes sample data for:
- Brands (e.g., Nike, Apple, Levi's).
- Product categories (e.g., Clothing, Electronics).
- Sizes, colors, and attributes.
- Products and their variations.
- Product images and inventory.

## Queries

The schema includes example queries for:
- Fetching products with their brands.
- Retrieving variations for a specific product.
- Listing available SKUs with their variations.

## How to Use

1. **Setup**:
   - Run the SQL script in your MySQL database to create the schema and populate the data.
   - Ensure you have the necessary privileges to execute the script.

2. **User Roles**:
   - `AdminUser`: Full access to manage users and grant privileges.
   - `SalesUser`: Manage products, inventory, and related data.
   - `GuestUser`: Read-only access to product and brand information.

3. **Indexes**:
   - Indexes are added to improve query performance. Use the provided queries to test the database's efficiency.

## Contributors

- **Liyabona Thebe**: Designed and implemented the database schema and sample data.

## License

This project is for educational purposes and is not licensed for production use.
