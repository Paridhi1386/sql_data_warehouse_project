Select 
cst.cst_id,
cst.cst_key,
cst.cst_firstname,
cst.cst_lastname,
cst.cst_marital_status,
cst.cst_gndr,
cst.cst_create_date,
cust.bdate,
cust.gen,
loc.cntry
from silver_crm_cust_info as cst
left join silver_erp_cust_az12 as cust
on cst.cst_key = cust.cid
left join silver_erp_loc_a101 as loc
on cst.cst_key = loc.cid;

/* Checking if there is any duplicate records after joining tables*/

Select cst_key,count(*)
from
(Select 
cst.cst_id,
cst.cst_key,
cst.cst_firstname,
cst.cst_lastname,
cst.cst_marital_status,
cst.cst_gndr,
cst.cst_create_date,
cust.bdate,
cust.gen,
loc.cntry
from silver_crm_cust_info as cst
left join silver_erp_cust_az12 as cust
on cst.cst_key = cust.cid
left join silver_erp_loc_a101 as loc
on cst.cst_key = loc.cid)t
group by cst_key
having count(*)>1;

/* Data Integration */
/*usually when we have discrepancies as in second result of the below query
# we communicate with the business team, in this case we are takinh crm as master table */
#so to fix the above problem we are gonna use crm gender if it is available if not we will use the 
# other tables gender, if erp gender is null ( which may be introduced due to join ) then n/a
Select distinct cst.cst_gndr,cust.gen,
CASE WHEN cst.cst_gndr !='N/A' then cst.cst_gndr
else coalesce(cust.gen,'N/A')
end as new_gen
from silver_crm_cust_info as cst
left join silver_erp_cust_az12 as cust
on cst.cst_key = cust.cid
left join silver_erp_loc_a101 as loc
on cst.cst_key = loc.cid;

/* Data Integration joined three tables */

Select 
cst.cst_id,
cst.cst_key,
cst.cst_firstname,
cst.cst_lastname,
cst.cst_marital_status,
CASE WHEN cst.cst_gndr !='N/A' then cst.cst_gndr
else coalesce(cust.gen,'N/A')
end as new_gen,
cst.cst_create_date,
cust.bdate,
loc.cntry
from silver_crm_cust_info as cst
left join silver_erp_cust_az12 as cust
on cst.cst_key = cust.cid
left join silver_erp_loc_a101 as loc
on cst.cst_key = loc.cid;

/* giving nice friendly names */

Select 
cst.cst_id as customer_id,
cst.cst_key as customer_number,
cst.cst_firstname as first_name,
cst.cst_lastname as last_name,
cst.cst_marital_status as marital_status,
CASE WHEN cst.cst_gndr !='N/A' then cst.cst_gndr
else coalesce(cust.gen,'N/A')
end as gender,
cst.cst_create_date as create_date,
cust.bdate as birthdate,
loc.cntry as country
from silver_crm_cust_info as cst
left join silver_erp_cust_az12 as cust
on cst.cst_key = cust.cid
left join silver_erp_loc_a101 as loc
on cst.cst_key = loc.cid;

/* rearranging columns */

Select 
cst.cst_id as customer_id,
cst.cst_key as customer_number,
cst.cst_firstname as first_name,
cst.cst_lastname as last_name,
loc.cntry as country,
cst.cst_marital_status as marital_status,
CASE WHEN cst.cst_gndr !='N/A' then cst.cst_gndr
else coalesce(cust.gen,'N/A')
end as gender,
cust.bdate as birthdate,
cst.cst_create_date as create_date
from silver_crm_cust_info as cst
left join silver_erp_cust_az12 as cust
on cst.cst_key = cust.cid
left join silver_erp_loc_a101 as loc
on cst.cst_key = loc.cid;

/* Creating a surrogate key (system generated unique key for each record) */

Select 
row_number() OVER(order by cst_id) as customer_key,
cst.cst_id as customer_id,
cst.cst_key as customer_number,
cst.cst_firstname as first_name,
cst.cst_lastname as last_name,
loc.cntry as country,
cst.cst_marital_status as marital_status,
CASE WHEN cst.cst_gndr !='N/A' then cst.cst_gndr
else coalesce(cust.gen,'N/A')
end as gender,
cust.bdate as birthdate,
cst.cst_create_date as create_date
from silver_crm_cust_info as cst
left join silver_erp_cust_az12 as cust
on cst.cst_key = cust.cid
left join silver_erp_loc_a101 as loc
on cst.cst_key = loc.cid;

/* Creating view in gold layer */

CREATE VIEW  gold.dim_customers AS
Select 
row_number() OVER(order by cst_id) as customer_key,
cst.cst_id as customer_id,
cst.cst_key as customer_number,
cst.cst_firstname as first_name,
cst.cst_lastname as last_name,
loc.cntry as country,
cst.cst_marital_status as marital_status,
CASE WHEN cst.cst_gndr !='N/A' then cst.cst_gndr
else coalesce(cust.gen,'N/A')
end as gender,
cust.bdate as birthdate,
cst.cst_create_date as create_date
from silver_crm_cust_info as cst
left join silver_erp_cust_az12 as cust
on cst.cst_key = cust.cid
left join silver_erp_loc_a101 as loc
on cst.cst_key = loc.cid;

SELECT distinct gender FROM gold.dim_customers;

/* Joining product tables */

Select 
prd_id,
cat_id,
prd_key,
prd_nm,
prd_cost,
prd_line,
prd_start_dt,
cat.cat,
cat.subcat,
cat.maintenance
from silver_crm_prd_info as prd
left join silver_erp_px_cat_g1v2 as cat
on prd.cat_id = cat.id
where prd_end_dt is null; /* filtering historical data */

/* after joining checking that any duplicate records */
Select prd_id,count(*)
from (Select 
prd_id,
cat_id,
prd_key,
prd_nm,
prd_cost,
prd_line,
prd_start_dt,
cat.cat,
cat.subcat,
cat.maintenance
from silver_crm_prd_info as prd
left join silver_erp_px_cat_g1v2 as cat
on prd.cat_id = cat.id
where prd_end_dt is null) t /* filtering historical data */
group by prd_id
having count(*)>1;

/* rearranging columns and giving friendly names */

create VIEW gold.dim_products as
Select 
row_number() OVER(order by prd_start_dt,prd_key) AS product_key,
prd_id as product_id,
prd_key as product_number,
prd_nm as product_name,
cat_id as category_id,
cat.cat as category,
cat.subcat as subcategory,
cat.maintenance,
prd_cost as product_cost,
prd_line as product_line,
prd_start_dt as start_date
from silver_crm_prd_info as prd
left join silver_erp_px_cat_g1v2 as cat
on prd.cat_id = cat.id
where prd_end_dt is null;


Select * from gold.dim_products;


/* last table */



Select 
s.sls_ord_num,
s.sls_prd_key,
s.sls_cust_id,
s.sls_order_dt,
s.sls_ship_dt,
s.sls_due_dt,
s.sls_sales,
s.sls_quantity,
s.sls_price
from silver_crm_sales_details as s;


/* doing lookup with dimension tables and replacing key columns with surrogate keys */

Select 
s.sls_ord_num,
p.product_key,
cu.customer_key,
s.sls_order_dt,
s.sls_ship_dt,
s.sls_due_dt,
s.sls_sales,
s.sls_quantity,
s.sls_price
from silver_crm_sales_details as s
Left join gold.dim_customers as cu
on s.sls_cust_id = cu.customer_id
left join gold.dim_products as p
on s.sls_prd_key = p.product_number;

/* replacing column names with friendly names */

Select 
s.sls_ord_num as order_number,
p.product_key,
cu.customer_key,
s.sls_order_dt as order_date,
s.sls_ship_dt as ship_date,
s.sls_due_dt as due_date,
s.sls_sales as sales_amount,
s.sls_quantity as quantity,
s.sls_price as price
from silver_crm_sales_details as s
Left join gold.dim_customers as cu
on s.sls_cust_id = cu.customer_id
left join gold.dim_products as p
on s.sls_prd_key = p.product_number;

/* creating view */

CREATE VIEW gold.fact_sales as
Select 
s.sls_ord_num as order_number,
p.product_key,
cu.customer_key,
s.sls_order_dt as order_date,
s.sls_ship_dt as ship_date,
s.sls_due_dt as due_date,
s.sls_sales as sales_amount,
s.sls_quantity as quantity,
s.sls_price as price
from silver_crm_sales_details as s
Left join gold.dim_customers as cu
on s.sls_cust_id = cu.customer_id
left join gold.dim_products as p
on s.sls_prd_key = p.product_number;

/* checking foreign key integration */

Select * from gold.fact_sales as s
left join gold.dim_customers as cu
on s.customer_key = cu.customer_key
where cu.customer_key is null;

Select * from gold.fact_sales as s
left join gold.dim_products as p
on s.product_key = p.product_key
where p.product_key is null;

