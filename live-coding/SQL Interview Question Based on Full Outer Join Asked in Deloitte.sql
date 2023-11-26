---- https://www.youtube.com/watch?v=KQfWd6V3IB8
---- Full outer join question

create table emp_2020
(
emp_id int,
designation varchar(20)
);

create table emp_2021
(
emp_id int,
designation varchar(20)
);

insert into emp_2020 values (1,'Trainee'), (2,'Developer'),(3,'Senior Developer'),(4,'Manager');
insert into emp_2021 values (1,'Developer'), (2,'Developer'),(3,'Manager'),(5,'Trainee');

-- Find the change in employees status
-- we only to see the changes promoted, resigned and new employees

--------------------------------- AV Solution 
with status as (
select 
	 coalesce(e0.emp_id,e1.emp_id) as emp_id
	,CASE WHEN e1.emp_id is null and e0.emp_id is not null then 'Resigned'
		  WHEN e1.emp_id is not null and e0.emp_id is null then 'Joined'
		  WHEN e1.emp_id is not null and e0.emp_id is not null
		  		then (CASE WHEN e1.designation = 'Developer' and e0.designation = 'Trainee' THEN 'Promoted'
					 	   WHEN e1.designation = 'Senior Developer' and e0.designation = 'Developer' THEN 'Promoted' 
					 	   WHEN e1.designation = 'Manager' and e0.designation = 'Senior Developer' THEN 'Promoted'
					 	   WHEN e1.designation = e0.designation THEN 'No changes' END)
				else 'No changes' end as status_field
from emp_2020 e0
full outer join emp_2021 e1
	on e0.emp_id = e1.emp_id
)
Select emp_id, status_field
from status
where status_field not in ('No changes')
