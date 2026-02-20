/* Propotional Analysis */

/* Part to Whole */

/* In this anlysis we will figure out how individual category performing compared to the overall,
allowing us to understand which category has greatest impact on the business */

/* which category is bringing most revenue */
Select
category,
total_sales,
sum(total_sales) over() as overall_sales,
concat(round((total_sales/sum(total_sales) over())*100,2),'%') as contribution
from
(SELECT 
p.category,
sum(f.sales_amount) as total_sales
FROM 
fact_sales as f
left join dim_products as p
on f.product_key = p.product_key
where f.order_date is not null
group by p.category)t;

/* In Bikes category which product sold most no. of quantities */

with cte2 as 
(
Select
product_name,
sum(quantity) as sold_quantity
from fact_sales as f
left join dim_products as p
on f.product_key = p.product_key
where p.category = 'Bikes'
group by product_name
order by product_name)

Select 
product_name,
sold_quantity,
sum(sold_quantity) over() as all_soid_quantity,
concat(round((sold_quantity/sum(sold_quantity) over())*100,2),'%')
from cte2
order by round((sold_quantity/sum(sold_quantity) over())*100,2) desc


