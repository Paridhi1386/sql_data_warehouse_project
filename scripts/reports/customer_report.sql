/* 
=============================================================
Customer Report
=============================================================

Purpose : 
   - This report consolidates key customer metrics and behaviors.
   
Highlights :

    1. Gathers essential fields such as names, ages and transaction details.
    2. Segments customers into categories ( VIP, Regular,New) and age groups.
    3. Aggregates customer-level metrics:
        - total orders
        - total sales
        - total quantity purchased
        - total products
        - lifespan (in months)
     4. Calculate valuble KPIs:
        - recency (months since last order)
        - average order value
        - average monthly spend
        
 ================================================================
 */
    
CREATE VIEW gold.report_customers AS
with base_query as
(
/*
==================================================================
Base Query   ( Gathering essential column for report and deriving some more columns
==================================================================
*/
Select 
f.order_number,
f.product_key,
f.order_date,
f.sales_amount,
f.quantity,
cust.customer_key,
cust.customer_number,
concat(cust.first_name,'  ',cust.last_name) as customer_name,
timestampdiff(YEAR,cust.birthdate,sysdate()) as age
from fact_sales as f
left join dim_customers as cust 
on f.customer_key = cust.customer_key
where f.order_date is not null
),
customer_aggregation as
(
/*
==================================================================
Customer Aggregation : Summerizes key Metrics at the customer level
==================================================================
*/
Select 
customer_key,
customer_number,
customer_name,
age,
count(distinct order_number) as total_orders,
sum(sales_amount) as total_spending,
sum(quantity) as total_quantity,
count(distinct product_key) as total_products,
max(order_date) as last_order_date,
timestampdiff(month,min(order_date),Max(order_date)) as lifespan
from base_query
group by customer_key,customer_number,customer_name,age
)

Select
customer_key,
customer_number,
customer_name,
age,
case 
 when age < 20 then 'under 20'
 when age between 20 and 29 then '20-29'
 when age between 30 and 39 then '30-39'
 when age between 40 and 49 then '40-39'
 else 'above 50'
 end as age_group,
 CASE
WHEN total_spending > 5000 AND lifespan>=12 then 'VIP'
WHEN total_spending <= 5000 and  lifespan>=12 then 'Regular'
else 'New'
end customer_segment,
last_order_date,
total_orders,
total_spending,
total_quantity,
total_products,
timestampdiff(month,last_order_date,sysdate()) as recency,

/* compute average order value (AOV) */
CASE WHEN total_orders = 0 THEN 0
ELSE
round(total_spending/total_orders,0)
END as avg_order_value,

/* compute average monthly spend */
CASE 
WHEN lifespan = 0 
then round(total_spending,2)
else
round(total_spending/lifespan,2)
end as avg_monthly_spend
from customer_aggregation;
