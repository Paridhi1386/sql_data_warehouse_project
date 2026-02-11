use bronze;

# check1: Primary key is unique and not null
# expactation: no record

Select cst_id,count(*)
from bronze_crm_cust_info
group by cst_id
having count(*)>1 or cst_id is null;

/* some cst_id are duplicate */

/*
Select *
from bronze_crm_cust_info
where cst_id=29466;
*/

-- setting flag --

Select * from (select *,row_number() OVER(partition by cst_id order by cst_create_date desc) as flag
from bronze_crm_cust_info) tb1
where tb1.flag=1 and tb1.cst_id!=0
;

# check2 : check whitespaces for string columns

select count(*) from
bronze_crm_cust_info;

Select cst.cst_firstname
from bronze_crm_cust_info cst
where cst.cst_firstname != trim(cst.cst_firstname);

Select cst.cst_lastname
from bronze_crm_cust_info cst
where cst.cst_lastname != trim(cst.cst_lastname);


/* final query to fetch only unique records and trimming white spaces from 
string value columns*/
Select 
cst_id,
cst_key,
trim(cst_firstname) as cst_firstname,
trim(cst_lastname) as cst_lastname,
cst_marital_status,
cst_gndr,
cst_create_date
 from (select *,row_number() OVER(partition by cst_id order by cst_create_date desc) as flag
from bronze_crm_cust_info) tb1
where tb1.flag=1 and tb1.cst_id!=0;

/* 
check 3 # Standarization ( replace abbriviation with full form)
*/
use bronze;
Select 
cst_id,
cst_key,
trim(cst_firstname) as cst_firstname,
trim(cst_lastname) as cst_lastname,
case
when upper(trim(cst_marital_status))='M'then 'Married'
when upper(trim(cst_marital_status))='S'then 'single'
else 'NA'
end as cst_marital_status,
case
when upper(trim(cst_gndr))='M' then 'Male'
when upper(trim(cst_gndr))='F' then 'Female'
else 'NA'
end as cst_gndr,
cst_create_date
 from (select *,row_number() OVER(partition by cst_id order by cst_create_date desc) as flag
from bronze_crm_cust_info) tb1
where tb1.flag=1 and tb1.cst_id!=0;
  