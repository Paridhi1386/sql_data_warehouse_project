/* Database Exploration */

-- Explore all objects in the DataBase --

SELECT * FROM INFORMATION_SCHEMA.TABLES;

-- Explore all columns in the Database --

SELECT * FROM INFORMATION_SCHEMA.COLUMNS;

-- Explore all columns in a specific table --

SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dim_customers';
