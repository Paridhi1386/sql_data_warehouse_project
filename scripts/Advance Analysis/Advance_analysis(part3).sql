/* Performance over time */

/* comapring current value with Target Value */
/* we can perform many time of comparisons such as
current year sale vs previuos year sale (YOY sale)
current year sale vs Averaage sale 
current year sale vs lowest or highest sale */

/* -------------------------------------
-------------------------------------------- */

/* Analyze the yearly performance of products by comparing their sales
to both the average sales performance of the product and previous year's sales */

Select
year(f.order_date) as order_year,
p.product_name ,
sum(f.sales_amount) as total_sale
from fact_sales as f
left join dim_products as p
on f.product_key = p.product_key
where f.order_date is not null
group by year(f.order_date),p.product_name
order by p.product_name,year(f.order_date);

/* ---------------
--------------- */
with cte1 as
(
Select
year(f.order_date) as order_year,
p.product_name  ,
sum(f.sales_amount) as current_sales
from fact_sales as f
left join dim_products as p
on f.product_key = p.product_key
where f.order_date is not null
group by year(f.order_date),p.product_name
order by p.product_name,year(f.order_date))

Select 
order_year,
product_name,
current_sales,
round (Avg(current_sales) over(partition by product_name),0) as avg_total_sale,
current_sales - round (Avg(current_sales) over(partition by product_name),0) as diff_avg,
case
when  current_sales - round (Avg(current_sales) over(partition by product_name),0) > 0 then 'Above Avg'
when  current_sales - round (Avg(current_sales) over(partition by product_name),0) < 0 then 'Below Avg'
else 'Avg'
end avg_change,

/* year over year analysis */
Lag(current_sales) over(partition by product_name) as LY_sale,
current_sales - Lag(current_sales) over(partition by product_name) as sale_diff,
case
when current_sales - Lag(current_sales) over(partition by product_name) > 0 then 'Increase'
when current_sales - Lag(current_sales) over(partition by product_name) < 0 then 'Decrease'
else 'No Change'
end sales_flag,

/* Comparing with lowest sale */
Min(current_sales) over(partition by product_name ) as Lowest_sale,
case 
when current_sales > Min(current_sales) over(partition by product_name ) then 'More than lowest sale'
when current_sales < Min(current_sales) over(partition by product_name ) then 'Less than lowest sale'
else 'Lowest sale'
end Low_sale_flag
from cte1;






