
--1.
--List the films where the yr is 1962 [Show id, title]

SELECT id
	,title
FROM movie
WHERE yr = 1962

--When was Citizen Kane released?
--2.
--Give year of 'Citizen Kane'.
SELECT yr
FROM movie
WHERE title = 'Citizen Kane'

--Star Trek movies
--3.
--List all of the Star Trek movies, include the id, title and yr (all of these movies include the words Star Trek in the title). Order results by year.
SELECT id
	,title
	,yr
FROM movie
WHERE title LIKE '%Star Trek%'

--id for actor Glenn Close
--4.
--What id number does the actor 'Glenn Close' have?
SELECT id
FROM actor
WHERE name = 'Glenn Close'

--id for Casablanca
--5.
--What is the id of the film 'Casablanca'
SELECT id
FROM movie
WHERE title = 'Casablanca'

--Cast list for Casablanca
--6.
--Obtain the cast list for 'Casablanca'.
--what is a cast list?
--Use movieid=11768, (or whatever value you got from the previous question)
SELECT ac.name
FROM actor ac
JOIN casting c ON ac.id = c.actorid
WHERE c.movieid = 27



--Alien cast list
--7.
--Obtain the cast list for the film 'Alien'
SELECT ac.name
FROM actor ac
JOIN casting c ON ac.id = c.actorid
JOIN movie m ON c.movieid = m.id
WHERE m.title = 'Alien'

--Harrison Ford movies
--8.
--List the films in which 'Harrison Ford' has appeared
SELECT m.title
FROM movie m
JOIN casting c ON m.id = c.movieid
JOIN actor ac ON c.actorid = ac.id
WHERE ac.name = 'Harrison Ford'

--Harrison Ford as a supporting actor
--9.
--List the films where 'Harrison Ford' has appeared - but not in the starring role. [Note: the ord field of casting gives the position of the actor. If ord=1 then this actor is in the starring role]
SELECT m.title
FROM movie m
JOIN casting c ON m.id = c.movieid
JOIN actor ac ON c.actorid = ac.id
WHERE ac.name = 'Harrison Ford'
	AND c.ord <> 1

--Lead actors in 1962 movies
--10.
--List the films together with the leading star for all 1962 films.
SELECT m.title
	,ac.name
FROM movie m
JOIN casting c ON m.id = c.movieid
JOIN actor ac ON c.actorid = ac.id
WHERE c.ord = 1
	AND m.yr = 1962

--Harder Questions
--________________________________________
--Busy years for Rock Hudson
--11.
--Which were the busiest years for 'Rock Hudson', show the year and the number of movies he made each year for any year in which he made more than 2 movies.
SELECT yr
	,COUNT(title)
FROM movie
JOIN casting ON movie.id = movieid
JOIN actor ON actorid = actor.id
WHERE name = 'Rock Hudson'
GROUP BY yr
HAVING COUNT(title) > 1


--Lead actor in Julie Andrews movies
--12.
--List the film title and the leading actor for all of the films 'Julie Andrews' played in.
--Did you get "Little Miss Marker twice"?
--Julie Andrews starred in the 1980 remake of Little Miss Marker and not the original(1934).
--Title is not a unique field, create a table of IDs in your subquery
SELECT DISTINCT m.title
	,ac.name
FROM movie m
JOIN casting c ON m.id = c.movieid
JOIN actor ac ON c.actorid = ac.id
WHERE m.id IN (
		SELECT movieid
		FROM casting
		WHERE actorid IN (
				SELECT id
				FROM actor
				WHERE name = 'Julie Andrews'
				)
		)
	AND c.ord = 1


--Actors with 15 leading roles
--13.
--Obtain a list, in alphabetical order, of actors who've had at least 15 starring roles.
SELECT ac.name
FROM actor ac
JOIN casting c ON ac.id = c.actorid
JOIN movie m ON c.movieid = m.id
WHERE c.ord = 1
GROUP BY ac.name
HAVING count(c.ord) >= 15



--14.
--List the films released in the year 1978 ordered by the number of actors in the cast, then by title.
SELECT m.title
	,count(ac.name)
FROM movie m
JOIN casting c ON m.id = c.movieid
JOIN actor ac ON c.actorid = ac.id
WHERE m.yr = 1978
GROUP BY m.title
ORDER BY count(ac.name) DESC
	,m.title



--15.
--List all the people who have worked with 'Art Garfunkel'.
SELECT DISTINCT ac.name
FROM actor ac
JOIN casting c ON ac.id = c.actorid
JOIN movie m ON c.movieid = m.id
WHERE m.title IN (
		SELECT title
		FROM movie
		JOIN casting ON movie.id = casting.movieid
		JOIN actor ON casting.actorid = actor.id
		WHERE actor.name = 'Art Garfunkel'
		)
	AND ac.name <> 'Art Garfunkel'
ORDER BY ac.name


