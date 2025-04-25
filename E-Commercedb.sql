-- Table Structure for table e_commerce_db

CREATE DATABASE e_commerce_db;

USE e_commerce_db;

-- Brands Table (Independent table)
CREATE TABLE brands(
    brand_id INT PRIMARY KEY AUTO_INCREMENT,
    brand_name VARCHAR(255) NOT NULL,
    logo_url VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Product Category Table (Independent table)
CREATE TABLE product_category(
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(255) NOT NULL,
    parent_id INT NULL,
    description TEXT NOT NULL,
    slug VARCHAR(100) NOT NULL,
    FOREIGN KEY (parent_id) REFERENCES product_category(category_id)
);

-- Size Category Table (Independent table)
CREATE TABLE size_category(
    size_id INT PRIMARY KEY AUTO_INCREMENT,
    size_name VARCHAR(20) NOT NULL,
    description VARCHAR(100) NOT NULL
);

-- Color Table (Independent table)
CREATE TABLE color(
    color_id INT PRIMARY KEY AUTO_INCREMENT,
    color_name VARCHAR(50) NOT NULL,
    hex_code VARCHAR(7),
    description VARCHAR(100)
);

-- Attribute Category Table (Independent table)
CREATE TABLE attribute_category (
    attribute_category_id BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(50) NOT NULL,
    description VARCHAR(255)
);

-- Attribute Type Table (Depends on attribute_category)
CREATE TABLE attribute_type(
    attribute_type_id BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    attribute_type_name VARCHAR(50) NOT NULL,
    attribute_category_id BIGINT UNSIGNED,
    data_type VARCHAR(50) NOT NULL CHECK(data_type IN ('text', 'number', 'boolean')),
    FOREIGN KEY (attribute_category_id) REFERENCES attribute_category(attribute_category_id)
);

-- Product Table (Depends on brands and product_category)
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

-- Product Variation Table (Depends on products, color, and size_category)
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

-- Product Image Table (Depends on products and color)
CREATE TABLE product_images(
    image_id BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    product_id BIGINT UNSIGNED,
    image_url VARCHAR(255) NOT NULL,
    is_primary BOOLEAN DEFAULT FALSE,
    color_id INT,
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (color_id) REFERENCES color(color_id)
);

-- Product Item Table (Depends on products)
CREATE TABLE product_item(
    product_item_id BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    product_id BIGINT UNSIGNED,
    sku VARCHAR(100) UNIQUE NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    quantity_in_stock INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Size Options Table (Depends on size_category and products)
CREATE TABLE size_options(
    size_option_id INT PRIMARY KEY AUTO_INCREMENT,
    size_id INT,
    description VARCHAR(100) NOT NULL,
    product_id BIGINT UNSIGNED,
    value VARCHAR(20) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (size_id) REFERENCES size_category(size_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Junction Tables for Variations
CREATE TABLE product_variation_color(
    variation_id BIGINT UNSIGNED,
    color_id INT,
    PRIMARY KEY (variation_id, color_id),
    FOREIGN KEY (variation_id) REFERENCES product_variation(variation_id),
    FOREIGN KEY (color_id) REFERENCES color(color_id)
);

CREATE TABLE product_variation_size(
    variation_id BIGINT UNSIGNED,
    size_id INT,
    PRIMARY KEY (variation_id, size_id),
    FOREIGN KEY (variation_id) REFERENCES product_variation(variation_id),
    FOREIGN KEY (size_id) REFERENCES size_category(size_id)
);

-- Junction Table for product item and variation
CREATE TABLE product_item_variation(
    product_item_id BIGINT UNSIGNED,
    variation_id BIGINT UNSIGNED,
    option_value VARCHAR(100) NOT NULL,
    PRIMARY KEY (product_item_id, variation_id),
    FOREIGN KEY (product_item_id) REFERENCES product_item(product_item_id),
    FOREIGN KEY (variation_id) REFERENCES product_variation(variation_id)
);

-- Product Attribute Table (Depends on products and attribute_type)
CREATE TABLE product_attribute(
    product_attribute_id BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    product_id BIGINT UNSIGNED,
    attribute_type_id BIGINT UNSIGNED,
    value VARCHAR(255) NOT NULL,
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (attribute_type_id) REFERENCES attribute_type(attribute_type_id)
);

-- Insert Brands
INSERT INTO brands (brand_name, logo_url, description) VALUES
('Nike', 'https://example.com/logos/nike.png', 'Athletic apparel and footwear'),
('Apple', 'https://example.com/logos/apple.png', 'Consumer electronics and software'),
('Levi''s', 'https://example.com/logos/levis.png', 'Denim clothing manufacturer');

-- Insert Categories
INSERT INTO product_category (category_name, parent_id, description, slug) 
VALUES 
('Clothing', NULL, 'Apparel products', 'clothing'),
('Electronics', NULL, 'Electronic devices', 'electronics'),
('T-Shirts', 1, 'Casual tops', 't-shirts'),
('Smartphones', 2, 'Mobile devices', 'smartphones');

-- Insert Size Categories
INSERT INTO size_category (size_name, description) 
VALUES
('Clothing', 'Standard apparel sizes'),
('Shoes', 'Footwear sizes'),
('Phones', 'Device dimensions');

-- Insert Size Options
INSERT INTO size_options (size_id, value, description) 
VALUES
(1, 'S', 'Small'),
(1, 'M', 'Medium'),
(1, 'L', 'Large'),
(2, '10', 'US Size 10'),
(3, '6.1"', '6.1 inch display');

-- Insert Colors
INSERT INTO color (color_name, hex_code, description) 
VALUES
('Red', '#FF0000', 'Classic red'),
('Black', '#000000', 'Jet black'),
('White', '#FFFFFF', 'Pure white'),
('Blue', '#0000FF', 'Navy blue');

-- Insert Attribute Categories
INSERT INTO attribute_category (category_name, description) 
VALUES
('Physical', 'Physical characteristics'),
('Technical', 'Technical specifications'),
('Material', 'Construction materials');

-- Insert Attribute Types
INSERT INTO attribute_type (attribute_type_name, attribute_category_id, data_type) 
VALUES
('Weight', 1, 'number'),
('Screen Size', 2, 'number'),
('Fabric', 3, 'text'),
('Water Resistant', 2, 'boolean');

-- Insert Products
INSERT INTO products (product_name, description, base_price, brand_id, category_id, is_active) 
VALUES
('Air Max 90', 'Iconic running shoes', 120.00, 1, 1, TRUE),
('iPhone 13', 'Latest smartphone from Apple', 799.00, 2, 2, TRUE),
('501 Jeans', 'Classic denim jeans', 59.50, 3, 1, TRUE),
('Galaxy S21', 'Latest smartphone from Samsung', 799.00, 2, 2, TRUE),
('Air Max 90', 'Classic sneakers', 120.00, 1, 1, TRUE),
('iPhone 13', 'Latest smartphone', 799.00, 2, 4, TRUE),
('501 Jeans', 'Original fit jeans', 59.50, 3, 1, TRUE);

-- Insert Product Variations
INSERT INTO product_variation (product_id, variation_name) 
VALUES
(1, 'Color'),
(1, 'Size'),
(2, 'Storage'),
(3, 'Color'),
(3, 'Size');

-- Insert Product Images
INSERT INTO product_images (product_id, image_url, is_primary, color_id) 
VALUES
(1, 'https://example.com/images/airmax-red.jpg', TRUE, 1),
(1, 'https://example.com/images/airmax-black.jpg', FALSE, 2),
(2, 'https://example.com/images/iphone13.jpg', TRUE, NULL),
(3, 'https://example.com/images/jeans-blue.jpg', TRUE, 4);

-- Insert Product Items (SKUs)
INSERT INTO product_item (product_id, sku, price, quantity_in_stock) 
VALUES
(1, 'NIKE-AM90-RED-S', 120.00, 50),
(1, 'NIKE-AM90-BLACK-M', 120.00, 35),
(2, 'APPLE-IP13-128GB', 799.00, 100),
(3, 'LEVIS-501-BLUE-32', 59.50, 75);

-- Insert Product Attributes
INSERT INTO product_attribute (product_id, attribute_type_id, value) 
VALUES
(1, 1, '0.5'), -- Weight in kg
(1, 3, 'Leather'), -- Fabric
(2, 2, '6.1'), -- Screen size
(2, 4, 'true'), -- Water resistant
(3, 3, 'Denim'); -- Fabric

-- Insert Variation Options
INSERT INTO product_variation_color (variation_id, color_id) VALUES(1, 1), (1, 2);

INSERT INTO product_variation_size (variation_id, size_id) VALUES (2, 1), (2, 2), (2, 3), (5, 1), (5, 2), (5, 3);

-- Link Product Items to Variations
INSERT INTO product_item_variation (product_item_id, variation_id, option_value) 
VALUES 
(1, 1, '1'), -- Color: Red
(1, 2, '1'), -- Size: S
(2, 1, '2'), -- Color: Black
(2, 2, '2'), -- Size: M
(4, 3, '4'), -- Color: Blue
(4, 5, '2'); -- Size: M (for jeans)

-- User Management
CREATE ROLE 'Admin';
CREATE ROLE 'SalesUser';
CREATE ROLE 'Guestuser';

-- Create Admin User (Full access)
CREATE USER 'AdminUser'@'localhost' IDENTIFIED BY 'Admin@1024';
GRANT CREATE USER, GRANT OPTION ON *.* TO 'AdminUser'@'localhost';

-- Create Sales User (Product and inventory management)
CREATE USER 'SalesUser'@'localhost' IDENTIFIED BY 'SalesPass123';

-- Grant privileges on product management tables
GRANT SELECT, INSERT, UPDATE ON e_commerce_db.products TO 'SalesUser'@'localhost';
GRANT SELECT, INSERT, UPDATE ON e_commerce_db.product_item TO 'SalesUser'@'localhost';
GRANT SELECT, INSERT, UPDATE ON e_commerce_db.product_variation TO 'SalesUser'@'localhost';
GRANT SELECT, INSERT, UPDATE ON e_commerce_db.product_attribute TO 'SalesUser'@'localhost';

-- Grant privileges on reference tables
GRANT SELECT, INSERT, UPDATE ON e_commerce_db.brands TO 'SalesUser'@'localhost';
GRANT SELECT, INSERT, UPDATE ON e_commerce_db.product_category TO 'SalesUser'@'localhost';
GRANT SELECT, INSERT, UPDATE ON e_commerce_db.size_category TO 'SalesUser'@'localhost';
GRANT SELECT, INSERT, UPDATE ON e_commerce_db.size_options TO 'SalesUser'@'localhost';
GRANT SELECT, INSERT, UPDATE ON e_commerce_db.color TO 'SalesUser'@'localhost';
GRANT SELECT, INSERT, UPDATE ON e_commerce_db.product_images TO 'SalesUser'@'localhost';

-- Grant privileges on junction tables
GRANT SELECT, INSERT, UPDATE ON e_commerce_db.product_variation_color TO 'SalesUser'@'localhost';
GRANT SELECT, INSERT, UPDATE ON e_commerce_db.product_variation_size TO 'SalesUser'@'localhost';
GRANT SELECT, INSERT, UPDATE ON e_commerce_db.product_item_variation TO 'SalesUser'@'localhost';

-- Grant privileges on attribute tables
GRANT SELECT, INSERT, UPDATE ON e_commerce_db.attribute_category TO 'SalesUser'@'localhost';
GRANT SELECT, INSERT, UPDATE ON e_commerce_db.attribute_type TO 'SalesUser'@'localhost';

-- Grant read-only privileges for GuestUser
GRANT SELECT ON e_commerce_db.products TO 'GuestUser'@'localhost';
GRANT SELECT ON e_commerce_db.brands TO 'GuestUser'@'localhost';
GRANT SELECT ON e_commerce_db.product_category TO 'GuestUser'@'localhost';
GRANT SELECT ON e_commerce_db.product_images TO 'GuestUser'@'localhost';
GRANT SELECT ON e_commerce_db.color TO 'GuestUser'@'localhost';

-- Apply the changes
FLUSH PRIVILEGES;

-- Add any additional data or constraints as needed

-- Get all products with their brands
SELECT p.product_name, b.brand_name AS brand, p.base_price 
FROM products p 
JOIN brands b ON p.brand_id = b.brand_id;

-- Get all variations for a product
SELECT p.product_name, pv.variation_name 
FROM products p 
JOIN product_variation pv ON p.product_id = pv.product_id
WHERE p.product_id = 1;

-- Get available SKUs with variations
SELECT pi.sku, p.product_name, 
GROUP_CONCAT(CONCAT(pv.variation_name, ': ', pi_v.option_value)) AS variations
FROM product_item pi
JOIN products p ON pi.product_id = p.product_id
JOIN product_item_variation pi_v ON pi.product_item_id = pi_v.product_item_id
JOIN product_variation pv ON pi_v.variation_id = pv.variation_id
GROUP BY pi.product_item_id;

-- Add indexes to improve query performance

-- Index on brands table
CREATE INDEX idx_brand_name ON brands(brand_name);

-- Index on product_category table
CREATE INDEX idx_category_name ON product_category(category_name);
CREATE INDEX idx_parent_id ON product_category(parent_id);

-- Index on size_category table
CREATE INDEX idx_size_name ON size_category(size_name);

-- Index on color table
CREATE INDEX idx_color_name ON color(color_name);

-- Index on attribute_category table
CREATE INDEX idx_attribute_category_name ON attribute_category(category_name);

-- Index on attribute_type table
CREATE INDEX idx_attribute_type_name ON attribute_type(attribute_type_name);
CREATE INDEX idx_attribute_category_id ON attribute_type(attribute_category_id);

-- Index on products table
CREATE INDEX idx_product_name ON products(product_name);
CREATE INDEX idx_brand_id ON products(brand_id);
CREATE INDEX idx_category_id ON products(category_id);
CREATE INDEX idx_is_active ON products(is_active);

-- Index on product_variation table
CREATE INDEX idx_product_id ON product_variation(product_id);
CREATE INDEX idx_variation_name ON product_variation(variation_name);
CREATE INDEX idx_color_id ON product_variation(color_id);
CREATE INDEX idx_size_id ON product_variation(size_id);

-- Index on product_images table
CREATE INDEX idx_product_id_images ON product_images(product_id);
CREATE INDEX idx_color_id_images ON product_images(color_id);

-- Index on product_item table
CREATE INDEX idx_product_id_item ON product_item(product_id);
CREATE INDEX idx_sku ON product_item(sku);

-- Index on size_options table
CREATE INDEX idx_size_id_options ON size_options(size_id);
CREATE INDEX idx_product_id_options ON size_options(product_id);

-- Index on product_variation_color table
CREATE INDEX idx_variation_id_color ON product_variation_color(variation_id);
CREATE INDEX idx_color_id_variation ON product_variation_color(color_id);

-- Index on product_variation_size table
CREATE INDEX idx_variation_id_size ON product_variation_size(variation_id);
CREATE INDEX idx_size_id_variation ON product_variation_size(size_id);

-- Index on product_item_variation table
CREATE INDEX idx_product_item_id_variation ON product_item_variation(product_item_id);
CREATE INDEX idx_variation_id_item ON product_item_variation(variation_id);

-- Index on product_attribute table
CREATE INDEX idx_product_id_attribute ON product_attribute(product_id);
CREATE INDEX idx_attribute_type_id ON product_attribute(attribute_type_id);
