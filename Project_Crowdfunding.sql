-- 5(a) Total Number of Projects based on outcome 
select state as Outcome,
count(ProjectID) as TotalNumProjects  
from projects
group by state
order by count(ProjectID) desc;

-- 5(b) Total Number of Projects based on Locations
select country as Country,
count(ProjectID) as TotalNumProjects
from projects
group by country
order by count(ProjectID) desc;

-- 5(c) Total Number of Projects based on  Category
select c.name as category,
count(id) as total_projects 
from projects p join sql_category c on c.id=p.category_id 
group by c.name 
order by count(id) desc;

-- 5(d) Total Number of Projects created by Year , Quarter , Month
select 
	year(from_unixtime(created_at))as year,
	quarter(from_unixtime(created_at))as quarter,
	month(from_unixtime(created_at)) as month,
    count(ProjectID) as total_No_Projects 
from projects
	group by year,quarter,month
	order by year,quarter,month;

-- 6(a,b,c) Successful Projects Amount Raised,Number of Backers, Avg NUmber of Days for successful projects
select sum(goal*static_usd_rate) as Amount_raised, 
       count(backers_count) as No_of_backers, 
       round(avg(deadline-created_at)/86400,0) as Avg_Days 
from projects
    where state="successful";

-- 7(a) . Top Successful Projects Based on Amount raised
select name as Top10_successful_project, 
sum(goal*static_usd_rate) as Amount_raised 
from projects
where state="successful"
group by name
order by Amount_raised desc limit 10;

-- 7(b) Top projects based on number of backers
select name as Top10_successful_project, 
backers_count as No_Of_Backers 
from projects
where state="successful"
order by No_Of_Backers desc limit 10;

-- 8(a) Percentage of Successful Projects overall
select 
concat(round((sum(if(state="successful",1,0))/count(*))*100,2),"%") as Overall_Successful_percent 
from projects;

-- 8(b)   Percentage of Successful Projects  by Category
select c.name as Category_name,
round((sum(if(state="successful",1,0))/count(*))*100,2) as Successful_percent 
from projects p join sql_category c on c.id=p.category_id 
group by c.name
order by Successful_percent desc;

-- 8(c) Percentage of Successful Projects by Year , Month etc.
select 
    year(from_unixtime(created_at))as year,
	quarter(from_unixtime(created_at))as quarter,
	month(from_unixtime(created_at)) as month,
	round((sum(if(state="successful",1,0))/count(*))*100,2) as Successful_percent_YQM 
    from projects
    group by year,quarter,month
    order by year,quarter,month;

-- 8(d) Percentage of Successful projects by Goal Range
select
case
    when goal < 1000 then '0-999'
    when goal between 1000 and 4999 then '1000-4999'
    when goal between 5000 and 9999 then '5000-9999'
    when goal between 10000 and 49999 then '10000-49999'
    when goal> 50000 then '50000 and more'
    else 'Unknown'
    end as Goal_range,
round((sum(if(state="successful",1,0))/count(*))*100,2) as Successful_percent_GoalRange
from projects
group by Goal_range
order by Successful_percent_GoalRange desc;
