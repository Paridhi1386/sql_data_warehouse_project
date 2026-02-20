/* Advance Analysis */

/* Change over time */

select * from fact_sales;

/* sales amount over years */
Select 
Year(order_date) as order_year,
sum(sales_amount) as total_amount
from fact_sales
where order_date is not null
group by Year(order_date)
order by Year(order_date);

/* sales amount over months */
Select 
month(order_date) as order_month,
sum(sales_amount) as total_amount
from fact_sales
where order_date is not null
group by month(order_date)
order by month(order_date);

/* sales amount year and month */

Select 
year(order_date) as order_year,month(order_date) order_month,
sum(sales_amount) as total_amount
from fact_sales
where order_date is not null
group by year(order_date),month(order_date)
order by year(order_date),month(order_date);

/* customer count and quantity sold over years */

Select 
Year(order_date) as order_year,
count(distinct customer_key) as customer_count,
sum(quantity) as sold_quantity
from fact_sales
where order_date is not null
group by Year(order_date)
order by Year(order_date);
