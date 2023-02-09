SELECT *
From PortfolioProject..CovidDeaths
Where continent is not NULL
order by 3,4

SELECT *
From PortfolioProject..CovidVaccinations
order by 3,4


-- Select Data that we are going to be using
SELECT Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
Where continent is not NULL
order by 1,2

-- Looking at Total cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country

SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
WHERE location = 'Australia' AND continent is not NULL
order by 1,2


--Looking at the Total Cases vs Population
-- Shows what percentage of population got Covid
SELECT Location, date, total_cases, population, (total_cases/population)*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
WHERE location = 'Australia'
order by 1,2

-- Looking at countries with highest infection rate compared to population
SELECT Location, population, MAX(total_cases) as HighestInfectionCount,  MAX((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
--WHERE location = 'Australia'
GROUP BY location,population
order by PercentPopulationInfected DESC

-- Showing countries with highest death count per population
SELECT Location, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--WHERE location = 'Australia'
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY TotalDeathCount DESC

--BREAKING DATA DOWN BY CONTINENT
SELECT continent, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--WHERE location = 'Australia'
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount DESC


-- Showing the continent with the highest death count per population
SELECT Location, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--WHERE location = 'Australia'
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY TotalDeathCount DESC


-- GLOBAL NUMBERS
SELECT SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
--,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
--WHERE location = 'Australia'
WHERE continent IS NOT NULL
--Group by date
ORDER BY 1,2

-- Looking at total population vs vaccination using CONVERT 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
	,SUM(convert(bigint, vac.new_vaccinations)) OVER(Partition by dea.location Order by dea.location, dea.date) as RolllingPeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date=vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2,3

-- Looking at total population vs vaccination using CAST 
-- USE CTE
With PopvsVac (continent, location, date, population, New_Vaccinations, RollingPeopleVaccinated)
AS 
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
	,SUM(CAST(vac.new_vaccinations AS bigint)) OVER(Partition by dea.location Order by dea.location, dea.date) as RolllingPeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date=vac.date
WHERE dea.continent IS NOT NULL
--ORDER BY 2,3
)

Select *, (RollingPeopleVaccinated/population)*100
FROM PopvsVac

-- TEMP TABLE
DROP Table if exists #PercentPopulationVaccinated
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
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
	,SUM(CAST(vac.new_vaccinations AS bigint)) OVER(Partition by dea.location Order by dea.location, dea.date) as RolllingPeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date=vac.date
WHERE dea.continent IS NOT NULL
--ORDER BY 2,3

Select *, (RollingPeopleVaccinated/population)*100
FROM #PercentPopulationVaccinated


-- Creating view to store data for later visualizations
Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
	,SUM(CAST(vac.new_vaccinations AS bigint)) OVER(Partition by dea.location Order by dea.location, dea.date) as RolllingPeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date=vac.date
WHERE dea.continent IS NOT NULL
--ORDER BY 2,3


SELECT *
FROM PercentPopulationVaccinated