--The following data is found at the following link:
https://ourworldindata.org/covid-deaths
--Time frame selected from feb 2020 to June 2022

Select *
From PortfolioProject.dbo.CovidDeaths
Order by 3,4

--Select *
--From PortfolioProject.dbo.CovidVaccination
--Order by 3,4

-- Select Data that I'm going to be using

Select Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject.dbo.CovidDeaths
order by 1,2


-- Looking at Total Cases vs Total Deaths
-- This data tells me the death rate of a person who got covid in United States at a specific date. Row 865 for example tells me that if you are someone who got infected covid and is living in United States on 6/4/2022, your death rate is about 1.19%.

Select Location, date, total_cases,  total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject.dbo.CovidDeaths
where location like 'United States'
order by 1,2

-- Looking at Total Cases vs Population
-- Shows what percentage of population got infected covid.
-- As of 6/4/2022 There is about 25.5% of the population in United States got infected covid.

Select Location, date, population, total_cases, (total_cases/population)*100 as InfectedPopulationPercentage
From PortfolioProject.dbo.CovidDeaths
where location like 'United States'
order by 1,2


-- Look at Countries with Highest Infection Rate compared to Population
-- Faeroe Islands have the highest infection rate compared to population.

Select Location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as InfectedPopulationPercentage
From PortfolioProject.dbo.CovidDeaths
-- where location like 'United States'
Group by Location, population
Order by 4 DESC

-- Showing countries with the Highest Death Count per Population
-- This data shows that the United States has the Highest Death Count

Select Location, MAX(cast(total_deaths as int)) as HighestDeathCount
From PortfolioProject.dbo.CovidDeaths
-- where location like 'United States'
Where continent is not null
Group by Location
Order by 2 DESC

-- Showing continents with the highest death counts

Select continent, MAX(cast(total_deaths as int)) as HighestDeathCount
From PortfolioProject.dbo.CovidDeaths
-- where location like 'United States'
Where continent is not null
Group by continent
Order by 2 DESC

-- Global numbers

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_death, SUM(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
From PortfolioProject.dbo.CovidDeaths
where continent is not null
--Group by date
order by 1,2

--Global number by date

Select date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_death, SUM(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
From PortfolioProject.dbo.CovidDeaths
where continent is not null
Group by date
order by 1,2

--Looking at total population vs vaccinations

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(cast(vac.new_vaccinations as bigint)) OVER (partition by dea.Location order by dea.location, dea.date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/Population)*100
From PortfolioProject..CovidDeaths as dea
Join PortfolioProject..CovidVaccination as vac
	on dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
order by 2,3


-- Use CTE b/c we can't use RollingPeopleVaccinated that we just created to divide by population, so in order to do further calculation, we need to use CTE.

WITH CTE_VacvsPop (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as bigint)) OVER (partition by dea.Location order by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths as dea
Join PortfolioProject..CovidVaccination as vac
	on dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100 as VaccinatedPopulation
From CTE_VacvsPop

--TEMP TABLE

DROP table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as bigint)) OVER (partition by dea.Location order by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths as dea
Join PortfolioProject..CovidVaccination as vac
	on dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100 as VaccinatedPopulation
From #PercentPopulationVaccinated

--Creating View to store data for later visualizations

---DeathPercentage

USE PortfolioProject
GO
Create View DeathPercentage as
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
--Where location like '%states%'
where continent is not null 
--Group By date
--order by 1,2

---Total Death Count 

USE PortfolioProject
GO
Create View TotalDeathCount as
Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Where continent is null 
and location not in ('World', 'European Union', 'International')
Group by location
--order by TotalDeathCount desc

--PercentPopulationInfected

USE PortfolioProject
GO
Create View PercentPopulationInfected as
Select Location, Coalesce(Population,0) as population, Coalesce(MAX(total_cases),0) as HighestInfectionCount,  Coalesce((Max((total_cases/population))*100),0) as PercentPopulationInfected
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Group by Location, Population
--order by PercentPopulationInfected desc

--PercentPopulationInfectedWithDate

USE PortfolioProject
GO
Create View PercentPopulationInfectedWithDate as
Select Location, Population, date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Group by Location, Population, date
--order by PercentPopulationInfected desc



