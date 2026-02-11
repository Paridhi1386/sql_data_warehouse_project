-- Find total number of customers --
Select COUNT(distinct customer_id) as customer_count from dim_customers;

-- Find total number of products --
SELECT COUNT(distinct product_key) as total_products from dim_products;

-- Find total_orders --
SELECT COUNT( distinct order_number) as total_orders from fact_sales;

-- Find total_salesamount --
select sum(sales_amount) as total_salesamount from fact_sales;



-- Find total_soldquantity --
Select sum(quantity) as total_soldquantity from fact_sales;

-- Find average sale price --

Select round(avg(price),0) as avg_saleprice from fact_sales;

-- customer count who placed order --
Select count(distinct customer_key) from fact_sales;

/* Generate a report that shows all key metrics of a business */

Select 'total nr.customers' As measure_name , COUNT(distinct customer_key) as measure_value from dim_customers
union all
SELECT 'total nr.products' , COUNT(distinct product_key) from dim_products
union all
SELECT 'total nr.orders',COUNT( distinct order_number) from fact_sales
union all
select 'total_sales_amount',sum(sales_amount) from fact_sales
union all
Select 'total_sales_quantity', sum(quantity) from fact_sales
union all
Select 'avg_salesprice',round(avg(price),0)  from fact_sales;

