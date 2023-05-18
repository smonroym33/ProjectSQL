-- DATA EXPLORATION

SELECT *
FROM PortfolioProject..CovidDeaths
Where continent is not null
order by 3,4


SELECT *
FROM PortfolioProject..CovidVaccinations
order by 3,4

--	SELECT THE DATA THAT WE ARE GOING TO BE USING

SELECT Location, date, total_cases, new_cases, total_deaths, population_density
FROM PortfolioProject..CovidDeaths
order by 1,2

-- LOOKING AT TOTAL CASES VS TOTAL DEATHS

----to convert the type of data (Varchar to Float) in the columns total_cases and total_deaths

SELECT *
FROM PortfolioProject..CovidDeaths
ALTER TABLE dbo.CovidDeaths
ALTER COLUMN total_cases float


SELECT *
FROM PortfolioProject..CovidDeaths
ALTER TABLE dbo.CovidDeaths
ALTER COLUMN total_deaths float



Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
From PortfolioProject..CovidDeaths
order by 1,2


--LOOKING AT TOTAL CASSES VS TOTAL DEATHS IN UNITED STATES
--Shows likelihood of dying if you contract Covid in your country

Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
From PortfolioProject..CovidDeaths
-- WHERE location like '%states%' and
Where continent is not null
order by 1,2


-- LOOKING AT TOTAL CASES VS POPULATION
-- Shows what percentage of population got Covid


Select Location, date, population, total_cases, (total_cases/population)*100 AS GotCovidPercentage
From PortfolioProject..CovidDeaths
-- WHERE location like '%states%' 
Where continent is not null
order by 1,2


--LOOKING AT COUNTRIES WITH HIGHEST INFECTION RATE COMPARED TO POPULATION

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Group by Location, Population
order by PercentPopulationInfected desc


-- SHOWING COUNTRIES WITH THE HIGHEST DEATH COUNT PER POPULATION

Select Location, max(Total_deaths)as TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Where continent is not null
Group by Location
order by TotalDeathCount desc

-- LET'S BREAK THINGS DOWN BY CONTINENT

--SHOWING CONTINENTS WITH THE HIGHEST DEATH COUNT PER POPULATION

Select continent, max(Total_deaths)as TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Where continent is not null
Group by continent
order by TotalDeathCount desc

-- GLOBAL NUMBERS

-- Covid Death Percentage by day 

Select date, sum(new_cases)as Total_cases, SUM(new_deaths) as Total_Deaths, SUM(new_deaths)/sum(new_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
-- WHERE location like '%states%' and
Where continent is not null and new_cases !=0
group by date
order by 1,2

-- Total Covid Death Percentage 

Select sum(new_cases)as Total_cases, SUM(new_deaths) as Total_Deaths, SUM(new_deaths)/sum(new_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
-- WHERE location like '%states%' and
Where continent is not null and new_cases !=0
-- group by date
order by 1,2

--Looking at Total Population vs Vaccinations

----Joining Tables

Select *
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
     On dea.location = vac.location
	 and dea.date = vac.date

-- New Vaccinations per day by country

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
     On dea.location = vac.location
	 and dea.date = vac.date
Where dea.continent is not null
order by 2,3



SELECT *
FROM PortfolioProject..CovidVaccinations
ALTER TABLE dbo.CovidVaccinations
ALTER COLUMN new_vaccinations bigint



Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
  sum(vac.new_vaccinations) OVER (partition by dea.location Order by dea.location,
  dea.Date) as RollingPeopleVaccinated
  --, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
     On dea.location = vac.location
	 and dea.date = vac.date
Where dea.continent is not null
order by 2,3

-- USE CTE to perform Calculation on Partition By in previous query

With PopvsVac(Continent, Location, Date, Population, new_vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
  sum(vac.new_vaccinations) OVER (partition by dea.location Order by dea.location,
  dea.Date) as RollingPeopleVaccinated
  --, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
     On dea.location = vac.location
	 and dea.date = vac.date
Where dea.continent is not null
--order by 2,3
)
Select *
FROM PopvsVac


-- Percentage Rolling People Vaccinated vs Population

With PopvsVac(Continent, Location, Date, Population, new_vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
  sum(vac.new_vaccinations) OVER (partition by dea.location Order by dea.location,
  dea.Date) as RollingPeopleVaccinated
  --, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
     On dea.location = vac.location
	 and dea.date = vac.date
Where dea.continent is not null
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100 as PercentagePeopleVaccinated
FROM PopvsVac


-- TEMP TABLE


Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
  sum(vac.new_vaccinations) OVER (partition by dea.location Order by dea.location,
  dea.Date) as RollingPeopleVaccinated
  --, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
     On dea.location = vac.location
	 and dea.date = vac.date
Where dea.continent is not null
--order by 2,3
Select *, (RollingPeopleVaccinated/Population)*100 as PercentagePeopleVaccinated
FROM #PercentPopulationVaccinated


-- Using DROP TABLE IF NEEDS TO ALTERATE OR CREATE AGAIN THE TABLE WITH THE SAME NAME

DROP TABLE if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric



)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
  sum(vac.new_vaccinations) OVER (partition by dea.location Order by dea.location,
  dea.Date) as RollingPeopleVaccinated
  --, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
     On dea.location = vac.location
	 and dea.date = vac.date
-- Where dea.continent is not null
--order by 2,3
Select *, (RollingPeopleVaccinated/Population)*100 as PercentagePeopleVaccinated
FROM #PercentPopulationVaccinated


--CREATING VIEW TO STORE DATA FOR LATER VISUALIZATIONS


Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
  sum(vac.new_vaccinations) OVER (partition by dea.location Order by dea.location,
  dea.Date) as RollingPeopleVaccinated
  --, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
     On dea.location = vac.location
	 and dea.date = vac.date
Where dea.continent is not null
--order by 2,3

Select *
From PercentPopulationVaccinated
