--SELECT CovidPatientsandDeaths

SELECT * FROM CovidPatientsandDeaths

--change datatype
ALTER TABLE CovidPatientsandDeaths
ALTER COLUMN [total_cases] float;

-- Total cases,tests,deaths GROUP BY country
SELECT location AS COUNTRY,SUM(new_cases) AS TOTAL_CASES,SUM(new_deaths) AS TOTAL_DEATHS,SUM(new_tests) TOTAL_TESTS
FROM CovidPatientsandDeaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY location;

--Test confirmed total cases  
SELECT location AS Country ,SUM(new_cases) AS Test_Confirmed_cases
FROM CovidPatientsandDeaths
WHERE continent IS NOT NULL AND tests_units IS NOT NULL
GROUP BY location
ORDER BY SUM(new_cases) DESC;

--Total cases,deaths and test group by continent
SELECT continent,SUM(new_cases) AS TOTAL_CASES,SUM(new_deaths) AS TOTAL_DEATHS,SUM(new_tests) TOTAL_TESTS
FROM CovidPatientsandDeaths
WHERE continent IS NOT NULL
GROUP BY continent;

--Highest TPR
SELECT location,MAX((new_cases/new_tests)*100) AS TPR
FROM CovidPatientsandDeaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY TPR DESC

--TPR in India
SELECT location AS Country,date,(new_cases/new_tests)*100 AS TPR
FROM CovidPatientsandDeaths
WHERE continent IS NOT NULL AND location='India'
ORDER BY TPR DESC;


--Daily Confirmed cases per million
SELECT date,location,(new_cases/1000000)*100 AS Daily_Confirmed_Cases_Per_Million
FROM CovidPatientsandDeaths
WHERE continent IS NOT NULL
ORDER BY date;

--death percentage in each country
SELECT location,(SUM(new_deaths)/SUM(new_cases))*100 AS DeathPercentage
FROM CovidPatientsandDeaths
WHERE continent IS NOT NULL
GROUP BY location;


SELECT * FROM CovidVaccination;

--JOINS two tables
SELECT CPD.date,CPD.location AS Country,CV.new_vaccinations,CV.population,CV.gdp_per_capita
FROM CovidPatientsandDeaths AS CPD
INNER JOIN CovidVaccination AS CV ON
CV.date=CPD.date
WHERE CPD.continent IS NOT NULL;




--Countries with high infection rate compared to population

SELECT CPD.location AS Country,(MAX(CPD.total_cases)/MAX(CV.population))*100 AS Percentage_of_population_got_covid
FROM CovidPatientsandDeaths AS CPD
INNER JOIN CovidVaccination AS CV ON
CV.date=CPD.date
WHERE CPD.continent IS NOT NULL
GROUP BY CPD.location
ORDER BY Percentage_of_population_got_covid DESC;


--Total cases,test and death vs poulation, Percentage of population in INDIA
SELECT CPD.date,CPD.location AS Country,(CPD.total_cases/CV.population)*100 AS Percentage_of_population_got_covid,
(CPD.total_tests/CV.population)*100 AS Percentage_of_population_got_tested,
(CV.people_fully_vaccinated/CV.population) AS Percentage_of_people_fully_vaccinated,
(CPD.total_deaths/CV.population)*100 AS Percentage_of_population_died ,
(CPD.new_cases/CPD.new_tests)*100 AS TPR
FROM CovidPatientsandDeaths AS CPD
INNER JOIN CovidVaccination AS CV ON
CV.date=CPD.date
WHERE CPD.continent IS NOT NULL AND CPD.location='India'
ORDER BY CPD.date;

--Temp Table

DROP TABLE IF EXISTS COVIDPERCENTAGE
CREATE TABLE COVIDPERCENTAGE
(
 date datetime,
 location nvarchar(255),
 Percentage_of_population_got_covid numeric,
 Percentage_of_population_got_tested numeric,
 Percentage_of_people_fully_vaccinated numeric,
 Percentage_of_population_died numeric,
 TPR numeric
 )

INSERT INTO COVIDPERCENTAGE
SELECT CPD.date,CPD.location AS Country,(CPD.total_cases/CV.population)*100 AS Percentage_of_population_got_covid,
(CPD.total_tests/CV.population)*100 AS Percentage_of_population_got_tested,
(CV.people_fully_vaccinated/CV.population) AS Percentage_of_people_fully_vaccinated,
(CPD.total_deaths/CV.population)*100 AS Percentage_of_population_died ,
(CPD.new_cases/CPD.new_tests)*100 AS TPR
FROM CovidPatientsandDeaths AS CPD
INNER JOIN CovidVaccination AS CV ON
CV.date=CPD.date
WHERE CPD.continent IS NOT NULL AND CPD.location='India'
ORDER BY CPD.date;


--Create View

CREATE VIEW COVID_PERCENTAGE AS
SELECT CPD.date,CPD.location AS Country,(CPD.total_cases/CV.population)*100 AS Percentage_of_population_got_covid,
(CPD.total_tests/CV.population)*100 AS Percentage_of_population_got_tested,
(CV.people_fully_vaccinated/CV.population) AS Percentage_of_people_fully_vaccinated,
(CPD.total_deaths/CV.population)*100 AS Percentage_of_population_died ,
(CPD.new_cases/CPD.new_tests)*100 AS TPR
FROM CovidPatientsandDeaths AS CPD
INNER JOIN CovidVaccination AS CV ON
CV.date=CPD.date
WHERE CPD.continent IS NOT NULL AND CPD.location='India'
--ORDER BY CPD.date;


SELECT * FROM COVID_PERCENTAGE;