/* Data Segmentation */

/* Group the data based on specific range */

/* helps us to understand correlation between two measures */

/* Measures by Measures ( total customers by Age group )  ( total products by sales range ) */

/* ----------
--------------- */

/* Segment products into cost ranges and count how many products fall into each group */

Select * from dim_products;

with product_segments as
(
Select 
product_key,
product_name,
product_cost,
case 

when product_cost<100 then 'Below 100'
when product_cost between 100 and 500 then '100 - 500'
when product_cost between 500 and 1000 then '500 -1000'
else 'Above 1000'
end cost_range
from dim_products
) 

Select
cost_range,
count( product_key) as total_products
from product_segments
group by cost_range
order by total_products desc;

/* ----------------------- ----------------------- -----------------------
----------------------- ----------------------- ----------------------- */

/* Group customers into three segments based on their spending behavior :

VIP : At least 12 months of history and spending more than $ 5,000

Regular : At least 12 months of history and spending  $ 5,000 or less 

New : lifespan less than 12 months.
and find total number of customers by each group */
with customer_spending as
(
Select
cust.customer_key,
sum(f.sales_amount) as total_spending,
Min(f.order_date) as first_order,
max(f.order_date) as last_order,
TIMESTAMPDIFF(month, Min(f.order_date), max(f.order_date)) as lifespan
from fact_sales as f
left join dim_customers as cust
on f.customer_key = cust.customer_key
group by cust.customer_key
)
Select
customer_segment,
count(customer_key) as total_customers
from
(Select
customer_key,total_spending,
lifespan,
CASE
WHEN total_spending > 5000 AND lifespan>=12 then 'VIP'
WHEN total_spending <= 5000 and  lifespan>=12 then 'Regular'
else 'New'
end customer_segment
from customer_spending
)t
group by customer_segment
order by total_customers desc;


