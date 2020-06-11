/*
This tutorial looks at how we can use SELECT statements within SELECT statements to perform more complex queries.
name	continent	area	population	gdp
Afghanistan	Asia	652230	25500100	20343000000
Albania	Europe	28748	2831741	12960000000
Algeria	Africa	2381741	37100000	188681000000
Andorra	Europe	468	78115	3712000000
Angola	Africa	1246700	20609294	100990000000
...
*/
--1.
--List each country name where the population is larger than that of 'Russia'.
--world(name, continent, area, population, gdp)
SELECT name FROM world
  WHERE population >
     (SELECT population FROM world
      WHERE name='Russia')

--2.
--Show the countries in Europe with a per capita GDP greater than 'United Kingdom'.
--Per Capita GDP
select name from World 
where gdp/population > (select gdp/population from world where name = 'United Kingdom')
Neighbours of Argentina and Australia
--3.
--List the name and continent of countries in the continents containing either Argentina or Australia. Order by name of the country.
select name, continent from world
where continent in (select continent from world where name = 'Argentina' or name = 'Australia')
order by name
Between Canada and Poland
--4.
--Which country has a population that is more than Canada but less than Poland? Show the name and the population.
select name from world 
where population > ( select population from world where name = 'Canada')
And
 population < ( select population from world where name = 'Poland')
Percentages of Germany
--5.
--Germany (population 80 million) has the largest population of the countries in Europe. Austria (population 8.5 million) has 11% of the population of Germany.
--Show the name and the population of each country in Europe. Show the population as a percentage of the population of Germany.
--The format should be Name, Percentage for example:
--name	percentage
--Albania	3%
--Andorra	0%
--Austria	11%
--...	...
--Decimal places
--Percent symbol %
select name, Concat(Round(population / (select population from world where name = 'Germany') * 100,0),'%')   as percentage 
from world where continent = 'Europe'
--To get a well rounded view of the important features of SQL you should move on to the next tutorial concerning aggregates.
--To gain an absurdly detailed view of one insignificant feature of the language, read on.
--We can use the word ALL to allow >= or > or < or <=to act over a list. For example, you can find the largest country in the world, by population with this query:
SELECT name
  FROM world
 WHERE population >= ALL(SELECT population
                           FROM world
                          WHERE population>0)
--You need the condition population>0 in the sub-query as some countries have null for population.


--6.
--Which countries have a GDP greater than every country in Europe? [Give the name only.] (Some countries may have NULL gdp values)
select name from world
 where gdp > All(select gdp from world where gdp>0 and continent = 'Europe')
--We can refer to values in the outer SELECT within the inner SELECT. We can name the tables so that we can tell the difference between the inner and outer versions.
--Largest in each continent
--7.
--Find the largest country (by area) in each continent, show the continent, the name and the area:
SELECT continent, name, population FROM world x
  WHERE population >= ALL
    (SELECT population FROM world y
        WHERE y.continent=x.continent
          AND population>0)
--The above example is known as a correlated or synchronized sub-query.
--Using correlated subqueries
--First country of each continent (alphabetically)
--8.
--List each continent and the name of the country that comes first alphabetically.
select continent, name from world x
where x.name = all(select top(1) name from world y where y.continent = x.continent order by name )
Difficult Questions That Utilize Techniques Not Covered In Prior Sections
--9.
--Find the continents where all countries have a population <= 25000000. Then find the names of the countries associated with these continents. Show name, continent and population.
SELECT name, continent, population FROM world WHERE continent IN (SELECT continent FROM world  x WHERE 25000000 >= (SELECT MAX(population) FROM world y WHERE x.continent = y.continent));
--10.
--Some countries have populations more than three times that of any of their neighbours (in the same continent). Give the countries and continents.
SELECT name, continent FROM world x
  WHERE population > ALL(SELECT 3*population FROM world y WHERE x.continent = y.continent AND x.name <> y.name)
Nested SELECT Quiz


