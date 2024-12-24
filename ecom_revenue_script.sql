SELECT * 
FROM ecom_revenue_project.ecom_revenue;

show columns
from ecom_revenue;

select distinct `Date`
from ecom_revenue;

update ecom_revenue 
set `Date` = str_to_date(`Date`, '%m/%d/%Y')
where `Date` like '%/%/%';

alter table ecom_revenue
modify column `Date` Date;

describe ecom_revenue;

#Data Exploration

Alter table ecom_revenue
change `Revenue (M)` `Revenue` Double;

select 
	min(Revenue) As MinRevenue,
    max(Revenue) As MaxRevenue,
    avg(Revenue) As AvgRevenue
from ecom_revenue;


#MONTHLY TRENDS

alter table ecom_revenue
add column WeekStartDate Date;

update ecom_revenue
set WeekStartDate = DATE_SUB(`Date`, INTERVAL (DAYOFWEEK(`Date`) - 2) DAY);
select `Date`, 
	WeekStartDate 
From ecom_revenue;

select 
	date_format(WeekStartDate, '%Y-%m') AS MONTH,
    Sum(Revenue) AS TotalRevenue,
    Sum(Visits) AS TotalVisits,
    Sum(Orders) AS TotalOrders
from ecom_revenue
group by date_format(WeekStartDate, '%Y-%m')
order by MONTH;

#Yearly Trends

select
	YEAR(WeekStartDate) AS Year,
    AVG(Revenue) AS AvgRevenue,
    AVG(Visits) AS AvgVisits,
    AVG(Orders) AS AvgOrders
from ecom_revenue
group by YEAR(WeekStartDate)
order by Year;

#Weekly and Previous Week Revenue

select
	WeekStartDate,
    Revenue,
    LAG(Revenue, 1) OVER (Order By WeekStartDate) AS PrevWeekRevenue
From ecom_revenue;

#Rolling Averages
select
	WeekStartDate,
    Revenue,
    Avg(Revenue) Over (Order By WeekStartDate ROWS BETWEEN 3 PRECEDING AND CURRENT ROW) 
    AS RollingAvgRevenue
from ecom_revenue;

#Extremely high revenue weeks
select 
	WeekStartDate,
    Revenue
From ecom_revenue
where Revenue > (
	Select Avg(Revenue) + 2 * STDDEV(Revenue) 
	From ecom_revenue);


