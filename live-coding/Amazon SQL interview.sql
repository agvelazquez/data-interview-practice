
--https://www.youtube.com/watch?v=Cbm6Hz_Yhwg&list=PLBTZqjSKn0IeKBQDjLmzisazhqQy4iGkb&index=33


CREATE TABLE emp(
 emp_id int NULL,
 emp_name varchar(50) NULL,
 salary int NULL,
 manager_id int NULL,
 emp_age int NULL,
 dep_id int NULL,
 dep_name varchar(20) NULL,
 gender varchar(10) NULL
) ;
insert into emp values(1,'Ankit',14300,4,39,100,'Analytics','Female');
insert into emp values(2,'Mohit',14000,5,48,200,'IT','Male');
insert into emp values(3,'Vikas',12100,4,37,100,'Analytics','Female');
insert into emp values(4,'Rohit',7260,2,16,100,'Analytics','Female');
insert into emp values(5,'Mudit',15000,6,55,200,'IT','Male');
insert into emp values(6,'Agam',15600,2,14,200,'IT','Male');
insert into emp values(7,'Sanjay',12000,2,13,200,'IT','Male');
insert into emp values(8,'Ashish',7200,2,12,200,'IT','Male');
insert into emp values(9,'Mukesh',7000,6,51,300,'HR','Male');
insert into emp values(10,'Rakesh',8000,6,50,300,'HR','Male');
insert into emp values(11,'Akhil',4000,1,31,500,'Ops','Male');

-- Write an SQL query to find details of employees with 3rd highest salary in each department. 
--In case there are less than 3 employees in a department then return employee details with lowest salary in that dep. 

------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------
-------------------------------------- Agus Solution

select count(distinct emp_id) from emp -- no repeated emp_id 
select count(distinct emp_name) from emp -- no repeated emp_name 

with lowest_salary as (
select 
	  emp_id
	, salary
	, dep_name
	, ROW_NUMBER() OVER(PARTITION by dep_name order by salary asc) rn 
from emp
	)
	
, third_salary as (
select 
	  emp_id
	, salary
	, dep_name
	, ROW_NUMBER() OVER(PARTITION by dep_name order by salary desc) rnt
from emp
	)

, all_emp as (
select distinct emp.emp_id, emp.emp_name, emp.salary, emp.dep_id, emp.dep_name
from emp
	)
	
select *
from all_emp ae
left join third_salary t on ae.emp_id = t.emp_id and rnt = 3
left join lowest_salary l on ae.emp_id = l.emp_id and rn = 1


-------------------------------------- Ankit Solution

select *
from (
select *, 
		rank() OVER(PARTITION by dep_name order by salary desc) rnt,
		count(1) over(partition by dep_name) cnt
from emp) ranking
where rnt = 3 or (cnt<3 and cnt = rnt)

