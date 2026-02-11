use bronze;
-- Creating erp tables in bronze layer---
drop table if exists bronze_erp_cust_az12;

create table bronze_erp_cust_az12
( cid	varchar(50),
bdate	date,
gen varchar(50)
);

drop table if exists bronze_erp_loc_a101;

create table bronze_erp_loc_a101
(
cid varchar(50),
cntry varchar(50)
);

drop table if exists bronze_erp_px_cat_g1v2;

create table bronze_erp_px_cat_g1v2
(
id varchar(50),	
cat varchar(50),
subcat varchar(50),	
maintenance varchar(50)
);


