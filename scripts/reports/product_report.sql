/*

=======================================================================

Product Report

========================================================================

Purpose:

     - This Report consolidates key product metrics and behaviors.

Highlights:

       1. Gathers essential fields such as product name , category , subcategory, and cost.
       2. Segments products by revenue to identify high performers , Mid range or Low performers.
       3. Aggregates product level metrics:
          - total orders
          - total sales
          - total quantity sold
          - total customers (unique)
          - lifespan ( in months)
        4. Calculate Valuable KPIs:
           - recency ( months since last sale )
           - average order revenue
           - average monthly revenue
           
     */
     
     CREATE VIEW gold.report_products AS
     with base_query as
     (
     /* 
     ==================================
     Base query : select all mandatory columns 
     ========================================
     */
     Select 
     f.order_number,
     f.order_date,
     f.customer_key,
     f.sales_amount,
      f.quantity,
     p.product_key,
     p.product_id,
     p.product_number,
     p.product_name,
     p.category,
     p.subcategory,
     p.product_cost
     from fact_sales as f
     left join dim_products as p
     on f.product_key = p.product_key
     where f.order_date is not null
     ),
     
      product_aggregation as(
      /* Key Metrics : Prodcut aggregation */
      
      
     select 
     product_key,
     product_number,
     product_name,
     category,
     subcategory,
     timestampdiff(month,min(order_date),max(order_date)) as lifespan,
     max(order_date) as last_sale_date,
     sum(sales_amount) as total_sales,
     count(distinct order_number) as total_order,
     count(distinct customer_key) as total_customers,
     sum(quantity) as total_quantity
     from base_query
     group by 
     product_key,product_number,product_name,
     category,subcategory
     )
     
     select 
     product_key,
     product_number,
     product_name,
     category,
     subcategory,
     total_sales,
     total_order,
     total_quantity,
     total_customers,
     last_sale_date,
     lifespan,
     timestampdiff(month,last_sale_date,sysdate()) as recency_in_months,
     case 
     when total_sales > 50000 then 'High Performer'
     when total_sales >= 10000 then 'Mid - Range'
     else 'Low Performer'
     end as product_segment,
     round(total_sales / total_quantity,0) as avg_selling_price,
     -- Average order revenue--
     case when total_order = 0 then 0
     else round(total_sales / total_order,0)
     end as avg_order_revenue,
     -- Average monthly revenue --
     case when lifespan = 0 then total_sales
     else
     round(total_sales / lifespan,0)
     end as avg_monthly_revenue
     from product_aggregation;
     
     
           