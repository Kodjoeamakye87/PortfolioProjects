Skip to content
Search or jump to…
Pull requests
Issues
Marketplace
Explore
 
@Kodjoeamakye87 
AlexTheAnalyst
/
SQL-Code
8
6435
Code
Issues
1
Pull requests
Actions
Projects
Wiki
Security
Insights
SQL-Code/Temp_Tables
@AlexTheAnalyst
AlexTheAnalyst Create Temp_Tables
Latest commit 9661640 on Feb 1
 History
 1 contributor
44 lines (29 sloc)  727 Bytes
  
Create table #temp_employee2 (
EmployeeID int,
JobTitle varchar(100),
Salary int
)

Select * From #temp_employee2

Insert into #temp_employee2 values (
'1001', 'HR', '45000'
)

Insert into #temp_employee2 
SELECT * From SQLTutorial..EmployeeSalary

Select * From #temp_employee2




DROP TABLE IF EXISTS #temp_employee3
Create table #temp_employee3 (
JobTitle varchar(100),
EmployeesPerJob int ,
AvgAge int,
AvgSalary int
)


Insert into #temp_employee3
SELECT JobTitle, Count(JobTitle), Avg(Age), AVG(salary)
FROM SQLTutorial..EmployeeDemographics emp
JOIN SQLTutorial..EmployeeSalary sal
	ON emp.EmployeeID = sal.EmployeeID
group by JobTitle

Select * 
From #temp_employee3

SELECT AvgAge * AvgSalary
from #temp_employee3



© 2021 GitHub, Inc.
Terms
Privacy
Security
Status
Docs
Contact GitHub
Pricing
API
Training
Blog
About
Loading complete