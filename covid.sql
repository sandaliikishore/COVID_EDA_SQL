select *
from Covid_project_SK..CovidDeaths
where continent is not null
Order by 3,4 ;

--select *
--from Covid_project_SK..CovidVaccinations
--Order by 3,4

-- Selecting data that we are going to use

select location, date, total_cases, new_cases, total_deaths, population	
from Covid_project_SK..CovidDeaths
where continent is not null
order by 1,2 ;

--Looking at Total cases vs. Total deaths
-- This shows the chances of deaths when it started after 3 months cases appeared. 
--1.61% of death on 11th march 2023 in India.
-- Peak time of death hight rates were from Aril to June in 2020. The drops a little but again spiked in July 2020.
-- The cases rapildy increases with every day. At the end of the data in 2021, the people got ifected rose to one crore people where 2 lakh people died.

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Death_per_cases	
from Covid_project_SK..CovidDeaths
where location = 'India'
and  continent is not null
order by 1,2 ;

-- Looking at Total cases vs. Population
--This shows what percentage of people got affected by Covid.

select location, date, total_cases, population, (total_cases/population)* 100 as Covid_per_pop	
from Covid_project_SK..CovidDeaths
where location like '%India%'
order by 1,2 ;

-- Highest cases according to location and its percentage with population.
--This shows that Andorra had highest infected people though it had a smaller population. 


select location, population, max(total_cases) as max_cases, max(total_cases/population)* 100 as Per_Pop_Infected	
from Covid_project_SK..CovidDeaths
--where location like '%India%'
group by location, population
order by 4 desc ;

-- Max cases in Inida

select location, population, max(total_cases) as max_cases, max(total_cases/population)* 100 as Per_Pop_Infected_India
from Covid_project_SK..CovidDeaths
where location like '%India%'
group by location, population
order by 4 ;

-- Countries having highest cases of covid according to their population
-- Andorra with its sevety thousand population has the highest cases of 17%. 
-- TOP 10 Countires also include United States at 9th Position. Israel on 10th. 
--Comparetively India with Huge Population had a lower cases rate which is 1.38%

select location, population, max(total_cases) as max_cases, max(total_cases/population)* 100 as Per_Pop_Cases	
from Covid_project_SK..CovidDeaths
--where location like '%India%'
group by location, population
order by 4 desc ;

-- Countries having highest death rates per population.
-- United States has the hightest death counts
-- India is in top 5 list at 4th position which shows the hardships that people of India faces during Covid.

select location, max(cast(Total_deaths as int)) as Totol_death_count	
from Covid_project_SK..CovidDeaths
where continent is not null 
group by location
order by 2 desc ;

-- LET'S BREAK DOWN THINGS DOWN TO CONTINENTS. 

-- Continents having highest death rates per population.
select continent, max(cast(Total_deaths as int)) as Totol_death_count 	
from Covid_project_SK..CovidDeaths
where continent is not null 
group by continent
order by 2 desc ;

--GLOBAL NUMBERS
-- total cases : 15 crores | Total Deaths : 31 lakh | Death_Rate : 2.11%


select  sum(new_cases) as Total_cases, sum(cast(new_deaths as int )) as Total_deaths, 
sum(cast(new_deaths as int ))/ sum(new_cases)*100 as Death_Percenatage
from Covid_project_SK..CovidDeaths
where continent is not null
--group by date
order by 1 ;

select date, sum(new_cases) as Total_cases, sum(cast(new_deaths as int )) as Total_deaths, 
sum(cast(new_deaths as int ))/ sum(new_cases)*100 as Death_Percenatage
from Covid_project_SK..CovidDeaths
where continent is not null
group by date
order by 1 ;

--JOINING TWO TABLES TO GET MORE INFO AND INSIGHT

select *
from Covid_project_SK..CovidDeaths d
join Covid_project_SK..CovidVaccinations v
   on d.location = v.location
   and d.date = v.date ;


-- Total Population vc. Vaccination
-- Inida's vaccination started in 2021 with 1 lakh new vaccinations


select d.continent, d.location, d.date, d.population, v.new_vaccinations
from Covid_project_SK..CovidDeaths d
join Covid_project_SK..CovidVaccinations v
   on d.location = v.location
   and d.date = v.date
where d.continent is not null and d.location = 'India'
order by 2,3

-- Showing when did vaccination starte for the first time and where

select d.continent, d.location, d.date, d.population , v.new_vaccinations
from Covid_project_SK..CovidDeaths d
join Covid_project_SK..CovidVaccinations v
   on d.location = v.location
   and d.date = v.date
where d.continent is not null and new_vaccinations is not null
order by  3

-- The above analysis shows that vaccinations started initially in Canada on 15th December, 2020

select d.continent, d.location, d.date, d.population, v.new_vaccinations
from Covid_project_SK..CovidDeaths d
join Covid_project_SK..CovidVaccinations v
   on d.location = v.location
   and d.date = v.date
where d.continent is not null and d.location = 'India' and new_vaccinations is not null
order by 3
--However, the above query tells that Inida's vaccinations started on 16th January 2020; It had 191181 vaccinations on that day.

-- Total Population vc. Vaccination

-- 12% of Albania is vaccinated.

-- USING CTE

with POPvsVacc (continent, location, date, population, new_vaccinations, vacc_per_day)
as

(select d.continent, d.location, d.date, d.population, v.new_vaccinations, 
       sum(convert(int,v.new_vaccinations))
	   over (partition by d.location order by d.location, d.date) as vacc_per_day
from Covid_project_SK..CovidDeaths d
join Covid_project_SK..CovidVaccinations v
   on d.location = v.location
   and d.date = v.date
where d.continent is not null 
--order by 2,3
)

select  *,(vacc_per_day/ population) *100 as vacc_per_pop
from POPvsVacc
order by 2,3

--Showing Inida's first day that 191181 vaccinations as we have analysed before. Furthermore 10% was the rate of vaccination there.
-- Using Sub Query 

Select *, (vacc_per_day / population)*100 as vacc_per_pop
from (select d.continent, d.location, d.date, d.population, v.new_vaccinations, 
       sum(convert(int,v.new_vaccinations))
	   over (partition by d.location order by d.location, d.date) as vacc_per_day
from Covid_project_SK..CovidDeaths d
join Covid_project_SK..CovidVaccinations v
   on d.location = v.location
   and d.date = v.date
where d.continent is not null and d.location = 'India'
--order by 2,3
) a
order by 2,3

--USING TEMP TABLE 

Drop table if exists #vaccination_per_day_sum
Create table #vaccination_per_day_sum
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
vacc_per_day numeric
)
insert into #vaccination_per_day_sum
select d.continent, d.location, d.date, d.population, v.new_vaccinations, 
       sum(convert(int,v.new_vaccinations))
	   over (partition by d.location order by d.location, d.date) as vacc_per_day
from Covid_project_SK..CovidDeaths d
join Covid_project_SK..CovidVaccinations v
   on d.location = v.location
   and d.date = v.date
--where d.continent is not null 
--order by 2,3

select  *,(vacc_per_day/ population) *100 as vacc_per_pop
from #vaccination_per_day_sum
order by 2,3

--Creating Views for important highlights and later visualizations

create view global_numbers as
select  sum(new_cases) as Total_cases, 
sum(cast(new_deaths as int )) as Total_deaths, 
sum(cast(new_deaths as int ))/ sum(new_cases)*100 as Death_Percenatage
from Covid_project_SK..CovidDeaths
where continent is not null
--group by date
--order by 1 
