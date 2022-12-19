/*
COVID 19 Data Exploration 

Skills used: Joins, CTE's, Aggregate Functions, Creating Views, Converting Data Types
*/

USE [Portfolio Project];

--SELECT * FROM CovidDeaths
--SELECT * FROM CovidVaccinations

SELECT * FROM CovidDeaths
WHERE continent is NOT null
ORDER BY 3,4;



-- Deleting duplicate values from CovidDeaths

--WITH CTE AS
--(
--SELECT *,ROW_NUMBER() OVER (PARTITION BY continent,location,date ORDER BY continent,location,date) AS RN
--FROM CovidDeaths
--)
--Select * from cte
--DELETE FROM CTE WHERE RN<>1



-- Selecting data which we will be using for analysis

SELECT location, 
	date,
	total_cases,
	new_cases,
	total_deaths,
	population
FROM CovidDeaths
WHERE continent is not null
ORDER BY 1,2;


--Total Cases vs Total Deaths
-- Represents likelihood of dying if you contract covid in your country

SELECT location, 
	date,
	total_cases,total_deaths,
	(total_deaths/total_cases)*100 AS Death_Percentage
FROM CovidDeaths
WHERE location like 'india'
AND continent is not null 
ORDER BY 1,2;


-- Total Cases vs Population
-- Represents percentage of population infected with Covid

SELECT location, 
	date,
	population,
	total_cases,
	(total_cases/population)*100 AS percent_population_infected
FROM CovidDeaths
--Where location = 'india'
WHERE continent is not null
ORDER BY 1,2;


-- Countries with Highest Infection Rate compared to Population

SELECT location, 
	population,
	MAX(total_cases) AS Highest_Infection_Count,
	Max((total_cases/population))*100 AS Percent_Population_Infected
FROM CovidDeaths
--Where location like 'india'
GROUP BY location, population
ORDER BY Percent_Population_Infected DESC;


--Countries with Highest Death Count 

SELECT continent,location,
	MAX(cast(Total_deaths as int)) AS Death_Count
FROM CovidDeaths
WHERE continent is not null
GROUP BY continent,location
ORDER BY Death_Count DESC;


-- Understanding data on Continent level

-- Showing contintents with the highest death count 

WITH CONT AS (
	SELECT continent,
			location,
			MAX(cast(Total_deaths as int)) AS Death_Count
	FROM CovidDeaths
	WHERE continent is not null 
	GROUP BY continent,location
)
SELECT continent,SUM(Death_Count) AS Total_Death_Count
FROM CONT
GROUP BY continent
ORDER BY Total_Death_Count DESC;


-- GLOBAL NUMBERS

SELECT SUM(new_cases) AS total_cases,
	SUM(cast(new_deaths as int)) AS total_deaths,
	SUM(cast(new_deaths as int))/SUM(New_Cases)*100 AS Death_Percentage
FROM CovidDeaths
WHERE continent is not null 
ORDER BY 1,2;


-- Creating View to store data for later visualizations


CREATE VIEW V_Global_Numbers AS
SELECT SUM(new_cases) AS total_cases,
	SUM(cast(new_deaths as int)) AS total_deaths,
	SUM(cast(new_deaths as int))/SUM(New_Cases)*100 AS Death_Percentage
FROM CovidDeaths
WHERE continent is not null ;


CREATE VIEW V_Highest_Death_Count AS
WITH CONT AS (
	SELECT continent,
			location,
			MAX(cast(Total_deaths as int)) AS Death_Count
	FROM CovidDeaths
	WHERE continent is not null 
	GROUP BY continent,location

)
SELECT continent,SUM(Death_Count) AS Total_Death_Count
FROM CONT
GROUP BY continent;
--ORDER BY Total_Death_Count DESC


CREATE VIEW V_Highest_Infection_Rate AS
 SELECT location, 
	population,
	MAX(total_cases) AS Highest_Infection_Count,
	Max((total_cases/population))*100 AS Percent_Population_Infected
FROM CovidDeaths
--Where location like 'india'
GROUP BY location, population;
