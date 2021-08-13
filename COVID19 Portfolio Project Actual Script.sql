--Select data that we are going to use

Select location, date, total_cases, new_cases, total_deaths, population
from [dbo].[CovidDeaths]
order by 1,2

--Looking at Total cases vs Total Deaths
Select location, date, total_cases, total_deaths,(total_deaths/Total_cases)*100 as DeathPercentage
from [dbo].[CovidDeaths]
Where location like '%States%'
order by 1,2

--Looking at Total cases vs Population
--Shows percentage of popultion are Covid Infected
Select location, date, population, total_cases, (total_cases/population)*100 as Population_Infection_Percentage
from [dbo].[CovidDeaths]
Where location like '%States%'
order by 1,2

--Countries with highest infection rate by Population
Select location, population, MAX(total_cases) as HighestInfectedCount, MAX(total_cases/population)*100 as Population_Infection_Percentage
from [dbo].[CovidDeaths]
--Where location like '%States%'
Group by location, population
order by Population_Infection_Percentage DESC

--Countries with Highest death Count by Population
Select location, MAX(cast(total_deaths as int)) as TotaldeathCount
from [dbo].[CovidDeaths]
Where continent IS NOT NULL
Group by location
order by TotaldeathCount DESC

--Highest death Count by Continent
Select continent, MAX(cast(total_deaths as int)) as TotaldeathCount
from [dbo].[CovidDeaths]
Where continent IS NOT NULL
Group by continent
order by TotaldeathCount DESC

--Global Numbers
Select date, SUM(new_cases) as NewGlobalCases, SUM(CAST(new_deaths as int)) as NewGlobaldeaths, SUM(CAST(new_deaths as int))/SUM(new_cases)*100 AS GlobalDeathPercentage
from [dbo].[CovidDeaths]
Where continent IS NOT NULL
Group by date 
order by 1,2

--Looking at Total Population vs Vaccination

Select dea.continent, dea.location, dea.date, population, vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations AS INT)) OVER (partition by dea.location Order by dea.location, 
dea.date) as RollingPeopleVaccinated
from [dbo].[CovidVaccinations] as dea
JOIN [dbo].[CovidDeaths] as vac
ON dea.location = vac.location
and dea.date = vac.date
Where dea.continent is not null
Order by 2,3

--Using CTE
With PopulationVSVaccinated (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, population, vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations AS INT)) OVER (partition by dea.location Order by dea.location, 
dea.date) as RollingPeopleVaccinated
from [dbo].[CovidVaccinations] as dea
JOIN [dbo].[CovidDeaths] as vac
ON dea.location = vac.location
and dea.date = vac.date
Where dea.continent is not null
--Order by 2,3
)
select *, (RollingPeopleVaccinated/population)*100 as PercentagePopulationVaccinated
from PopulationVSVaccinated

--Temp_Table

drop table if exists #PercentPopulationvaccinated
Create table #PercentPopulationvaccinated
(
Continent nvarchar(255),
location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccination numeric,
RollingPeopleVaccinated numeric
)
insert into #PercentPopulationvaccinated
Select dea.continent, dea.location, dea.date, population, vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations AS INT)) OVER (partition by dea.location Order by dea.location, 
dea.date) as RollingPeopleVaccinated
from [dbo].[CovidVaccinations] as dea
JOIN [dbo].[CovidDeaths] as vac
ON dea.location = vac.location
and dea.date = vac.date
Where dea.continent is not null
Order by 2,3

select *, (RollingPeopleVaccinated/population)*100 as PercentagePopulationVaccinated
from #PercentPopulationvaccinated 

--Creating View to store data for later visualizations

Create view PercentPopulationvaccinated as
Select dea.continent, dea.location, dea.date, population, vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations AS INT)) OVER (partition by dea.location Order by dea.location, 
dea.date) as RollingPeopleVaccinated
from [dbo].[CovidVaccinations] as dea
JOIN [dbo].[CovidDeaths] as vac
ON dea.location = vac.location
and dea.date = vac.date
Where dea.continent is not null
--Order by 2,3

select * from PercentPopulationvaccinated