select * from CovidDeaths
order by 3,4

-- select data that we are going to be using .

select location, date, total_cases, new_cases, total_deaths, population
from CovidDeaths
order by 1,2
 
-- looking at total case vs total Deaths
-- shows likelihood of dying of you contract covid of in your country
select location, date, total_cases, total_deaths, (total_cases/total_deaths)*100 as DeathPercentage
from CovidDeaths
where location like'%states%'
order by 1,2

-- Looking at total Cases vs Population
-- shows what parcentage of population of Covid

select location, date,  population, total_cases,(total_cases/population)*100 as DeathPercentage
from CovidDeaths
--where location like'%states%'
order by 1,2

-- Looking at country with Highest Infection Rate compared to population

select location,  population, Max(total_cases) as HighestInfectionCount,Max((total_cases/population))*100 as PercentagePopulatioInfected
from CovidDeaths
--where location like'%states%'
group by location,  population
order by PercentagePopulatioInfected desc

--showing Countries Whit Highest Death Count per Population

select Location, Max(total_deaths) as TotalDeathCount
from CovidDeaths
where location = 'Egypt'
group by location
order by TotalDeathCount desc

-- Let's Break Things Down Continent 
select continent , Max(total_deaths) as TotalDeathCount
from CovidDeaths
--where location = 'Egypt'
group by continent
order by TotalDeathCount desc

-- Globel Numbers

select date, total_cases, total_deaths, (total_cases/total_deaths)*100 as DeathPercentage
from CovidDeaths
--where location like'%states%'
where continent is not null
order by 1,2

-- Looking at Total population vs vaccinations

select de.continent, de.location, de.date, de.population, va.new_vaccinations
from CovidDeaths de
join CovidVaccinations va
on de.location = va.location
and de.date = va.date


-- TEMP Table 

Create table #percentPopulationVaccinate
(
  continent nvarchar (255),
  Location nvarchar (255),
  Date datetime,
  population numeric,
  new_vaccinations numeric,
  RollingPepoleVaccinated numeric
)
insert into #percentPopulationVaccinate
select de.continent, de.location, de.date, de.population, va.new_vaccinations, SUM (CONVERT (int, va.new_vaccinations))
over(Partition by de.location order by de.location, de.date) as RollingPepoleVaccinated
from CovidDeaths de
join CovidVaccinations va
on de.location = va.location
and de.date = va.date
where de.continent is not null

select *, (RollingPepoleVaccinated/Population)*100
from #percentPopulationVaccinate
drop table #percentPopulationVaccinate


-- Create View To Store For Later Visualizations

Create View percentPopulationVaccinate as 

select de.continent, de.location, de.date, de.population, va.new_vaccinations, SUM (CONVERT (int, va.new_vaccinations))
over(Partition by de.location order by de.location, de.date) as RollingPepoleVaccinated
from CovidDeaths de
join CovidVaccinations va
on de.location = va.location
and de.date = va.date
where de.continent is not null

select * from percentPopulationVaccinate