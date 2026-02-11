Select * from bronze_crm_sales_details;

# QC - 1 PK should be unique and not null
# Expectation - no record should be return

Select * from bronze_crm_sales_details;
select
s.sls_ord_num,count(*)
from
bronze_crm_sales_details as s
group by s.sls_ord_num
having count(*)>1;


Select
*
from(
Select
*,
count(sls_ord_num) over(partition by sls_ord_num) as identifier
from
bronze_crm_sales_details)t
where identifier > 1;


Select
*
from
(
Select
sls_ord_num,
sls_cust_id,sls_prd_key,
cast(sls_order_dt as date) as new_sls_ord_dt,
cast(s.sls_ship_dt as date) as new_sls_ship_dt,         
cast(s.sls_due_dt as date) as new_sls_due_dt,
count(sls_ord_num) over(partition by sls_ord_num) as duplicate_sls_ord_num
from bronze.bronze_crm_sales_details as s)t
where duplicate_sls_ord_num >1;

# There could be multiple products ordered with same sls_ord_num and sls_cust_id

# QC sls_ord_num with no white spaces

Select 
sls_ord_num from bronze_crm_sales_details
where sls_ord_num != trim(sls_ord_num);

# QC Checking dates 

select * from bronze.bronze_crm_sales_details
where sls_order_dt <=0 or sls_order_dt is null or length(sls_order_dt)!=8;

select * from bronze.bronze_crm_sales_details
where sls_ship_dt <=0 or sls_ship_dt is null;

select * from bronze_crm_sales_details
where sls_due_dt <=0 or sls_due_dt is null;

-- checking limits --

select * from bronze_crm_sales_details
where sls_order_dt<='1900-01-01';
 -- sls_order_dt >=20500101;
 
 select sls_order_dt from bronze_crm_sales_details
where length(sls_order_dt)!=8;

select sls_ship_dt from bronze_crm_sales_details
where length(sls_ship_dt)!=8;

select sls_due_dt from bronze_crm_sales_details
where length(sls_due_dt)!=8;

-- casting date columns --

Select
sls_ord_num,
sls_prd_key,sls_cust_id,
Case when
length(sls_order_dt)!=8 or sls_order_dt is null 
then
 null
else
cast(sls_order_dt as date) 
end as new_sls_ord_dt,
Case when
length(sls_ship_dt)!=8 or sls_ship_dt is null 
then
 null
else
cast(sls_ship_dt as date) 
end as new_sls_ship_dt, 
Case when
length(sls_due_dt)!=8 or sls_ship_dt is null 
then
 null
else
cast(sls_due_dt as date)  
end as new_sls_due_dt,
sls_sales,
sls_quantity,
sls_price
from bronze_crm_sales_details;

-- QC # sls_sales should not be negative or zero

Select sls_ord_num,sls_prd_key,sls_cust_id,
case 
when sls_sales<=0 or sls_sales!= ABS(sls_price)*sls_quantity
then ABS(sls_price)*sls_quantity
else
sls_sales
end as sls_sales,
sls_quantity,sls_price
from bronze_crm_sales_details;
-- where sls_sales <=0;



-- QC # quantity should not be negative or zero

Select sls_ord_num,sls_prd_key,sls_cust_id,sls_sales,sls_quantity,sls_price
from bronze_crm_sales_details
 where sls_quantity<=0;

-- QC # sls_price should not be negative or zero
Select sls_ord_num,sls_prd_key,sls_cust_id,sls_sales,sls_quantity,
Case when
sls_price<=0 or sls_price is null
then sls_sales / coalesce(sls_quantity,0)
else sls_price
end sls_price
from bronze_crm_sales_details;
-- where sls_price<=0;

-- QC # checking dates --


Select
*
from
(select sls_ord_num,
sls_prd_key,sls_cust_id,
cast(sls_order_dt as date) as new_sls_ord_dt,
cast(sls_ship_dt as date) as new_sls_ship_dt,         
cast(sls_due_dt as date) as new_sls_due_dt,
sls_sales,
sls_quantity,
sls_price
from bronze_crm_sales_details)t
where new_sls_ord_dt is null or new_sls_ship_dt is null;

Select
*
from
(select sls_ord_num,
sls_prd_key,sls_cust_id,
cast(sls_order_dt as date) as new_sls_ord_dt,
cast(sls_ship_dt as date) as new_sls_ship_dt,         
cast(sls_due_dt as date) as new_sls_due_dt,
sls_sales,
sls_quantity,
sls_price
from bronze_crm_sales_details)t
where new_sls_ship_dt < new_sls_due_dt;

Select
sls_ord_num,
sls_prd_key,sls_cust_id,
cast(sls_order_dt as date) as new_sls_ord_dt,
cast(sls_ship_dt as date) as new_sls_ship_dt,         
cast(sls_due_dt as date) as new_sls_due_dt,
sls_sales,
sls_quantity,
sls_price
from bronze_crm_sales_details;


/* Final query 
casting date columns,
quantity,sales and price should be interrelated

 */
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
from bronze_crm_sales_details)t;




