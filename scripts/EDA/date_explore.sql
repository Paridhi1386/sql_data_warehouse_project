/* Find first order date and last order date */

SELECT min(order_date) as first_order_date,
max(order_date) as last_order_date
FROM gold.fact_sales;

/* How many years orders are placed  OR how many years of sales available*/

SELECT min(order_date) as first_order_date,
max(order_date) as last_order_date,
timestampdiff(year,min(order_date),max(order_date)) as order_years
from fact_sales;

/* How many years orders are placed  OR how many years of sales available*/

SELECT min(order_date) as first_order_date,
max(order_date) as last_order_date,
timestampdiff(month,min(order_date),max(order_date)) as order_years
from fact_sales;


/* Find oldest and youngest customers */

SELECT MIN(birthdate) as oldest_customer,
MAX(birthdate) as youngest_customer
from dim_customers;

SELECT MIN(birthdate) as oldest_customer,
MAX(birthdate) as youngest_customer,
timestampdiff(year,min(birthdate),current_date()) as oldest_customer_age,
timestampdiff(year,max(birthdate),current_date()) as youngest_customer_age
from dim_customers;

Select current_date();