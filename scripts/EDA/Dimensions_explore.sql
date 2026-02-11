/* Exploring Dimensions */

/* Find all countries names where all customers came */

SELECT distinct country
from dim_customers;

/* Find all product categories " Major level " */
SELECT distinct category
from dim_products;

/* Find all sub categories " Major level " */
SELECT distinct subcategory
from dim_products;

/* Find all products under category and subcategory */

SELECT distinct product_name,category,subcategory
from dim_products
order by 1,2,3;
