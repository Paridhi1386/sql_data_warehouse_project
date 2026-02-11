use bronze;

SELECT * FROM bronze.bronze_crm_prd_info;

# Quality Check1 # Primary key should be unique and not null
# Expectation : return no record

select
prd_id,count(*)
From bronze_crm_prd_info
group by prd_id
having count(*)>1 or prd_id is null;

# created two derived columns cat_id,prd_key so that we can establish relationship with other tables
Select 
prd_id,
replace(substring(prd_key,1,5),'-','_') as cat_id,
substring(prd_key,7,length(prd_key)) as prd_key
from bronze_crm_prd_info;

# Check 2 : checking white spaces in string column
# Expectation : no records should be return

Select * from bronze_crm_prd_info;

Select prd_nm,trim(prd_nm)
from bronze_crm_prd_info
where prd_nm!=trim(prd_nm);

# check 3 : For numeric column check value should not be null or negative

Select * from bronze_crm_prd_info;

Select prd_id,prd_cost
from bronze.bronze_crm_prd_info
where prd_cost<=0 or prd_cost is null;

Select 
prd_id,
replace(substring(prd_key,1,5),'-','_') as cat_id,
substring(prd_key,7,length(prd_key)) as prd_key,
coalesce(prd_cost,0)
from bronze_crm_prd_info;

# Check 4 : Standarization
# Replacing abbriviation with full form in prd_line column

Select distinct(prd_line)
from bronze_crm_prd_info;

Select 
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
prd_start_dt,prd_end_dt
from bronze_crm_prd_info;

# Check4 : Invalid dates
# End date should not be earlier than start date
# Expectation no record retun

Select 
prd_id,prd_nm,prd_start_dt,prd_end_dt
from bronze_crm_prd_info
where prd_end_dt<prd_start_dt;

# Solution 1 : # Switch End date and start date
# but issue here is overlaping of dates will occure for same product
# this gives us another quality check where end date of one product should be one less than next record start date
# Solution 2: End Date = Start date of next record - 1
# cast dates to date
Select 
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