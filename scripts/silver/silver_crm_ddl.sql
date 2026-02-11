use silver;
-- Creating crm tables in silver layer---
drop table if exists silver_crm_cust_info;

create table silver_crm_cust_info
( cst_id int,	
cst_key	varchar(50),
cst_firstname	varchar(50),
cst_lastname varchar(50),	
cst_marital_status	varchar(50),
cst_gndr	varchar(50),
cst_create_date date,
dwh_create_date DATETIME default current_timestamp()

);

drop table if exists silver_crm_prd_info;

create table silver_crm_prd_info
(
prd_id	int,
cat_id  varchar(50),
prd_key	varchar(50),
prd_nm varchar(50),
prd_cost	int,
prd_line varchar(50),	
prd_start_dt	date,
prd_end_dt date,
dwh_create_date DATETIME default current_timestamp()

);

drop table if exists silver_crm_sales_details;

create table silver_crm_sales_details
(
sls_ord_num	varchar(50),
sls_prd_key	varchar(50),
sls_cust_id	int,
sls_order_dt		date,
sls_ship_dt		date,
sls_due_dt		date,
sls_sales		int,
sls_quantity		int,
sls_price 	int,
dwh_create_date DATETIME default current_timestamp()
);

