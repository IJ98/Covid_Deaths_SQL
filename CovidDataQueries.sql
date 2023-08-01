--Inspecting the data
select * from CovidProject..Deaths$
order by 3,4


-- Total cases vs deaths (shows how likleihood of dying if you get covid in your country)
select location,date,population,total_cases,total_deaths,ROUND((total_deaths/total_cases)*100,2) as deaths_vs_cases
from CovidProject..Deaths$
where continent is not null and location = 'India'  -- change location name to check for your country of interest
order by 2,6 desc

--Date of first death by location
select location, min(date) as Date_of_first_death
from CovidProject..Deaths$
where continent is not null AND new_deaths>=1
group by location
order by 2

--Date of first case by location
select location, min(date) as Date_of_first_case
from CovidProject..Deaths$
where continent is not null AND new_cases>=1
group by location
order by 2 

--No of deaths in a continent as % of deaths in the world 
with ctecontinent as 
(
select continent,sum(cast(new_deaths as float)) as Total_deaths
from CovidProject..Deaths$
where continent is not null
group by continent
)
select  *, sum(Cast(Total_deaths as float)) OVER() as Total, 
		Total_deaths*100/ sum(Cast(Total_deaths as float)) OVER() as Percentage
from ctecontinent
order by Percentage desc


--No of cases in a continent as % of deaths in the world 
with ctecontinent as (
select continent,sum(cast(new_cases as float)) as Total_cases
from CovidProject..Deaths$
where continent is not null
group by continent
)
select  *, sum(Cast(Total_cases as float)) OVER() as Total, 
		Total_cases*100/ sum(Cast(Total_cases as float)) OVER() as Percentage
from ctecontinent
order by Percentage desc

-- Total cases vs population (shows what % of population got covid)
select location,date,population,total_cases,ROUND((total_cases/population)*100,2) as cases_vs_population 
from CovidProject..Deaths$
where continent is not null and location='India' -- change location name to check for your country of interest
order by 2,5 desc

-- Countries with highest infection rate compared to population
select location, population, max(cast(total_cases as bigint)) as Highest_infection_count, max(round((cast(total_cases as bigint)/population)*100,2)) as Percent_population_infected
from CovidProject..Deaths$
group by location,population,continent
having continent is not null
order by Percent_population_infected desc

-- Countries with highest death count compared to population
select location, max(cast(total_deaths as bigint)) as Highest_death_count
from CovidProject..Deaths$
where continent is not null
group by location
order by Highest_death_count desc

-- Countinents with highest death count compared to population
select continent, max(cast(total_deaths as bigint)) as Highest_death_count
from CovidProject..Deaths$
where continent is not null 
group by continent
order by Highest_death_count desc


