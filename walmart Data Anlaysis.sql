## The project consists of walmart transaction across  different countries with diffrent age  group.
## we are going to analyze the data and going to find some beautiful insight from the data 

SELECT * FROM  WEEKLY_SALES Limit 5;


## DATA CLEANSING
## In the first step we are going to seperate date column  in year, week number, month number  and going to change the segment as a particular age type

CREATE TABLE SALES_DATA AS SELECT WEEK_DATE, WEEK(WEEK_DATE) AS WEEK_NUMBER,month(WEEK_DATE)AS MONTH_NUMBER,YEAR(WEEK_DATE) AS CALENDER_YEAR,
REGION, PLATFORM, 
CASE  
WHEN RIGHT(SEGMENT, 1)='1' THEN "YOUNG_ADULT" 
WHEN RIGHT(SEGMENT, 1)='2' THEN "MIDDLE_AGE"
WHEN RIGHT(SEGMENT, 1)IN('3', '4') THEN "RETIRES"
ELSE 'UNKNOWN'
END AS AGE_BAND,
CASE
WHEN LEFT(SEGMENT, 1) ='C' THEN 'COUPLE'
WHEN LEFT(SEGMENT, 1) ='F' THEN 'FAMILIY'
ELSE 'UNKNOWN'
END AS DEM_GRAPHIC,
CASE 
WHEN SEGMENT = NULL THEN 'UNKNOWN'
ELSE SEGMENT
END AS SEGMENT,
CUSTOMER_TYPE, TRANSACTIONS, SALES,
ROUND(SALES/TRANSACTIONS, 2) AS 'AVG_SALES' FROM WEEKLY_SALES ;


# Finding the missing  week number


SELECT * FROM  SALES_DATA LIMIT 40;


## Finding the MISSING WEEK NUMBER


## This statement help us to create number  between 1 to 100

CREATE TABLE SEQ100(X INT auto_increment PRIMARY KEY);
INSERT INTO SEQ100 VALUES (),(),(),(),(),(),(),(),(),();
INSERT INTO SEQ100 VALUES (),(),(),(),(),(),(),(),(),();
INSERT INTO SEQ100 VALUES (),(),(),(),(),(),(),(),(),();
INSERT INTO SEQ100 VALUES (),(),(),(),(),(),(),(),(),();
INSERT INTO SEQ100 VALUES (),(),(),(),(),(),(),(),(),();
INSERT INTO SEQ100 SELECT X+50 FROM SEQ100;

SELECT * FROM SEQ100;

SELECT distinct WEEK_NUMBER FROM CLEAN_WEEKLY_SALE ORDER BY WEEK_NUMBER;

CREATE TABLE SEQ52 AS (SELECT X FROM SEQ100 LIMIT 52);

## Since every year we have 52 week we are going to check which number that are not available in our week number column

SELECT * FROM SEQ52;

# MIssing weak numbers

SELECT X AS WEEK_DAY FROM SEQ52
 WHERE X NOT IN (SELECT distinct WEEK_NUMBER FROM SALES_DATA);
 


# Now we are going to check TOTAL No  TRANSACTION FOR EACH YEAR

SELECT CALENDER_YEAR,sum(TRANSACTIONS) FROM SALES_DATA
GROUP BY CALENDER_YEAR;

# TOTAL SALES FOR  EACH REGION FOR EVERY MONTH

SELECT REGION, MONTH_NUMBER, SUM(SALES) AS TOTAL_SALES FROM SALES_DATA
GROUP BY REGION, MONTH_NUMBER ORDER BY MONTH_NUMBER;

# Total count of transaction from every platform

select platform, sum(transactions) from SALES_DATA
group by (platform);

## what is the percentage of sales  for retail and shopify platform for monthly  sales

with cte_monthly_sales as
(select month_number, calender_year, platform, sum(sales) as monthly_sales
from SALES_DATA group by month_number, calender_year, platform)
select month_number, calender_year,sum(monthly_sales) as mnt,  round(100*max(case when platform = 'Retail' 
then monthly_sales else null end)/sum(monthly_sales),2) as retail_perct,
round(100*max(case when platform = 'Shopify' 
then monthly_sales else null end)/sum(monthly_sales),2) as  shopify_perct from cte_monthly_sales 
group by month_number, calender_year order by calender_year, month_number;


## what is the percentage of sales  for demographic for every year

select calender_year, dem_graphic, sum(sales) as yearly_sales, round(100*sum(sales)/sum(sum(sales)) 
over (partition by dem_graphic),2) as percentage from SALES_DATA  group by calender_year, dem_graphic order by calender_year;

# which age band  contribute for most sales for retail

select age_band,dem_graphic, sum(sales) as total_sales from SALES_DATA
where platform = 'Retail' 
group by age_band, dem_graphic order by total_sales desc;







