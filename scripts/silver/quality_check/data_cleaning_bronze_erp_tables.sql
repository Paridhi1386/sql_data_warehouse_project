use bronze;

SELECT * FROM bronze.bronze_erp_cust_az12;

# QC Primary Key should be unique and not null

Select cid,count(cid)
from bronze.bronze_erp_cust_az12 
group by cid
having cid>1;

# Primary Key should not be null
Select cid
from bronze.bronze_erp_cust_az12 
where cid is null;

# no white spaces

Select cid
from bronze.bronze_erp_cust_az12 
where cid != trim(cid);

/*cst_key is primary key in bronze_crm_cust_info table and cid column is primary key in bronze_erp_cust_az12 table 
so they both should match because we can connect in future to get more information for customers from bronze_erp_cust_az12 table*/

Select 
substring(cid,4,length(cid)) as cid
from bronze.bronze_erp_cust_az12; 

# bdate should not be more than today
Select bdate
from bronze.bronze_erp_cust_az12
where bdate > sysdate();

Select bdate
from bronze.bronze_erp_cust_az12
where bdate is null;

Select 
case
when bdate > sysdate()
then null
else bdate
end as bdate
from bronze.bronze_erp_cust_az12;

Select * from bronze.bronze_erp_cust_az12;

# QC white spaces in gender column

Select gender
from  bronze.bronze_erp_cust_az12
where gender != trim(gender);

Select distinct gender
from bronze.bronze_erp_cust_az12;

/* QC for data standarization & normalization but there are new line characters also in gender field so
using REGEXP_REPLACE function because trim function doesn't remove tab,new line spaces from field value */

 Select case
when  REGEXP_REPLACE(gender,'[[:space:]]','') IN ('M','Male')
then 'Male'
when REGEXP_REPLACE(gender,'[[:space:]]','') IN ('M','Female')
then 'Female'
else 'N/A'
end as gender
from bronze.bronze_erp_cust_az12;

-- Final Query ( cleaned )--

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

# QC second ERP table bronze_erp_loc_a101 

/* cid is primary key in bronze_erp_loc_a101 and cst_key is primary key in bronze_crm_cust_info and in future we can get country 
info by joining these two tables*/
use bronze;
select * from bronze.bronze_erp_loc_a101;

Select replace(cid,'-','') as cid
,country
from 
bronze.bronze_erp_loc_a101;
 
 Select distinct country
 from 
bronze_erp_loc_a101;

/* Country standarazation and removing new line character */

/* final cleaned and standarized table */

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
from bronze_erp_loc_a101)t;


# QC third ERP table bronze_erp_px_cat_g1v2

Select * from bronze_erp_px_cat_g1v2;

select * from silver.silver_crm_prd_info;



# QC Primary Key should be unique and not null

Select id,count(id)
from bronze_erp_px_cat_g1v2
group by id
having count(id)>1;

Select id
from bronze_erp_px_cat_g1v2
where id is null;

# Check white spaces for string columns

Select
cat
from bronze_erp_px_cat_g1v2
where cat != trim(cat);

Select
subcat
from bronze_erp_px_cat_g1v2
where subcat != trim(subcat);
 
 Select
maintenance
from bronze_erp_px_cat_g1v2
where maintenance != trim(maintenance);
 
 /* Data standarization and normalization */
 
 Select distinct cat 
 from  bronze_erp_px_cat_g1v2;
 
 Select distinct subcat 
 from  bronze_erp_px_cat_g1v2
 order by subcat;
 
Select distinct maintenance 
 from  bronze_erp_px_cat_g1v2
 order by maintenance;
 
 /* removing new line charcter from maintenance column */
 
 Select distinct trim( REGEXP_REPLACE(maintenance,'[[:space:]]','')) AS maintenance
 from bronze_erp_px_cat_g1v2;

/* Final clean query */

Select id,cat,subcat,
trim(REGEXP_REPLACE(maintenance,'[[:space:]]','')) AS maintenance
from bronze.bronze_erp_px_cat_g1v2;

