Use silver;

# load transformed data into silver DB#
Truncate silver_crm_cust_info;
Insert Into silver_crm_cust_info
(
cst_id,
cst_key,
cst_firstname,
cst_lastname,
cst_marital_status,
cst_gndr,
cst_create_date
)Select 
cst_id,
cst_key,
trim(cst_firstname) as cst_firstname,
trim(cst_lastname) as cst_lastname,
case
when upper(trim(cst_marital_status))='M'then 'Married'
when upper(trim(cst_marital_status))='S'then 'single'
else 'N/A'
end as cst_marital_status,
case
when upper(trim(cst_gndr))='M' then 'Male'
when upper(trim(cst_gndr))='F' then 'Female'
else 'N/A'
end as cst_gndr,
cst_create_date
 from (select *,row_number() OVER(partition by cst_id order by cst_create_date desc) as flag
from bronze.bronze_crm_cust_info) tb1
where tb1.flag=1 and tb1.cst_id!=0;


-- Inserting transformed data into silver_crm_prd_info table --

Use Silver;

Truncate silver_crm_prd_info;
Insert into silver.silver_crm_prd_info(
prd_id,
cat_id,
prd_key,
prd_nm,
prd_cost,
prd_line,
prd_start_dt,
prd_end_dt
)Select 
prd_id,
replace(substring(prd_key,1,5),'-','_') as cat_id,
substring(prd_key,7,length(prd_key)) as prd_key,
prd_nm,
coalesce(prd_cost,0) as prd_cost,
case upper(trim(prd_line))
when 'M' then 'Mountains'
when 'R' then 'Road'
when 'S' then 'Other Sales'
when 'T' then 'Touring'
else 'N/A'
end as prd_line,
prd_start_dt,
date_sub(lead(prd_start_dt) over (partition by prd_key order by prd_start_dt),interval 1 day) as prd_end_dt
from bronze.bronze_crm_prd_info;

-- Inserting transformed data into silver_crm_sales_details table --

Use silver;

Insert into silver.silver_crm_sales_details
(
sls_ord_num	,
sls_prd_key	,
sls_cust_id	,
sls_order_dt		,
sls_ship_dt		,
sls_due_dt		,
sls_sales	,
sls_quantity		,
sls_price 
)
Select
sls_ord_num,
sls_prd_key,
sls_cust_id,new_sls_order_dt,
new_sls_ship_dt,new_sls_due_dt,
case
when sls_sales<=0 or sls_sales is null or sls_sales != sls_quantity * ABS(new_sls_price)
then sls_quantity * ABS(new_sls_price)
else sls_sales
end as new_sls_sales,
sls_quantity,
new_sls_price
from(
Select 
sls_ord_num,
sls_prd_key,
sls_cust_id,
Case 
when sls_order_dt =0 or length(sls_order_dt) !=8 then null
else cast(sls_order_dt as date)
end as new_sls_order_dt,
Case 
when sls_ship_dt =0 or length(sls_ship_dt) !=8 then null
else cast(sls_ship_dt as date)
end as new_sls_ship_dt,
case
when sls_due_dt =0 or length(sls_due_dt) !=8 then null
else cast(sls_due_dt as date)
end as new_sls_due_dt,sls_sales,
/*case
when sls_sales<=0 or sls_sales is null or sls_sales != sls_quantity * ABS(sls_price)
then sls_quantity * ABS(sls_price)
else sls_sales
end as new_sls_sales,*/
sls_quantity,
case
when sls_price <=0 or sls_price is null 
then round(ABS(sls_sales)/coalesce(sls_quantity,0))
else sls_price
end as new_sls_price
from bronze.bronze_crm_sales_details)t;
-- ---- ---
# Insert into silver_erp_cust_az12
use silver;
INSERT INTO silver_erp_cust_az12
( cid	,
bdate ,
gen 
)
Select 
substring(cid,4,length(cid)) as cid,
case
when bdate > sysdate()
then null
else bdate
end as bdate,
 case
when  REGEXP_REPLACE(gender,'[[:space:]]','') IN ('M','Male')
then 'Male'
when REGEXP_REPLACE(gender,'[[:space:]]','') IN ('M','Female')
then 'Female'
else 'N/A'
end as gender
from bronze.bronze_erp_cust_az12;
select * from silver.silver_erp_cust_az12;

# Inserting into silver_erp_loc_a101
use silver;
INSERT iNTO silver.silver_erp_loc_a101
(
cid ,
cntry 
)
Select 
cid,
case
when country in ('USA','US','UnitedStates')
then
'UnitedStates'
when country in ('Germany','DE')
then 'Germany'
when country is null
then 'N/A'
else
country
end as country
from(select replace(cid,'-','') as cid,
trim(REGEXP_REPLACE(country,'[[:space:]]','')) as country
from bronze.bronze_erp_loc_a101)t;


# Insert into bronze_erp_px_cat_g1v2
use silver;
Insert into silver_erp_px_cat_g1v2
(
id,
cat ,
subcat ,	
maintenance 
)
Select id,cat,subcat,
trim(REGEXP_REPLACE(maintenance,'[[:space:]]','')) AS maintenance
from bronze.bronze_erp_px_cat_g1v2;
