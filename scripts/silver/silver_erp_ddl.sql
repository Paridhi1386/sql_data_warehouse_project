use silver;
-- Creating erp tables in silver layer---
drop table if exists silver_erp_cust_az12;

create table silver_erp_cust_az12
( cid	varchar(50),
bdate	date,
gen varchar(50),
dwh_create_date DATETIME default current_timestamp()
);

drop table if exists silver_erp_loc_a101;

create table silver_erp_loc_a101
(
cid varchar(50),
cntry varchar(50),
dwh_create_date DATETIME default current_timestamp()
);

drop table if exists silver_erp_px_cat_g1v2;

create table silver_erp_px_cat_g1v2
(
id varchar(50),	
cat varchar(50),
subcat varchar(50),	
maintenance varchar(50),
dwh_create_date DATETIME default current_timestamp()
);


