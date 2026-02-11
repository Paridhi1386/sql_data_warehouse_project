/* In this analysis we find top contributors or Top categories by measures */

/* Which 5 products generated highest revenue */

Select d.product_name,sum(f.sales_amount) as total_revenue
from fact_sales as f
left join dim_products as d
on f.product_key = d.product_key
group by f.product_key,d.product_name
order by total_revenue desc
limit 5;

/* what are the 5 worst performing products in terms of sales */

Select d.product_name,sum(f.sales_amount) as total_revenue
from fact_sales as f
left join dim_products as d
on f.product_key = d.product_key
group by d.product_name
order by total_revenue 
limit 5;

/* Find top 10 customers who have generated highest revenue */

Select d.first_name,d.last_name,sum(f.sales_amount) as total_revenue
from fact_sales as f
left join dim_customers as d
on f.customer_key = d.customer_key
group by d.first_name,d.last_name
order by total_revenue desc
limit 10;

-- 3 customers with fewest order placed --
Select f.customer_key,d.first_name,d.last_name,count(distinct order_number) as order_count
from fact_sales as f
left join dim_customers as d

on f.customer_key = d.customer_key
group by f.customer_key,d.first_name,d.last_name 
order by order_count
limit 3;


  
