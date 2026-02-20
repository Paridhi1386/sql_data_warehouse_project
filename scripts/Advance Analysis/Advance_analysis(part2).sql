/* Cumulative Analysis */

/* In this we will see bussiness growth or decline over time */

Select * from fact_sales;

Select
t.order_year,
total_sales,
sum(total_sales) over (order by t.order_year) as running_total
from (
Select 
year(order_date) as order_year,
Sum(sales_amount) as total_sales
from fact_sales
where order_date is not null
group by year(order_date)
) t;



