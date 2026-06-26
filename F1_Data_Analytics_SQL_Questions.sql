SELECT * FROM drivers;
SELECT * FROM results;

-- Q1 Which drivers have won the most Formula 1 races?

SELECT
	d.forename || ' ' || d.surname AS driver_name,
COUNT(*) AS wins
FROM results r
JOIN drivers d
	ON r.driverid = d.driverid
WHERE r.positionorder = 1
GROUP BY driver_name
ORDER BY wins DESC;

-- Q2 Which drivers have achieved the most podium finishes?

SELECT
	d.forename || ' ' || d.surname AS driver_name,
COUNT(*) AS podiums
FROM results r
JOIN drivers d
	ON r.driverid = d.driverid
WHERE r.positionorder <= 3
GROUP BY driver_name
ORDER BY podiums DESC;

-- Q3 Which Formula 1 teams have won the most races?

SELECT
	c.name AS constructor_name,
COUNT(*) AS wins
FROM results r
JOIN constructors c
	ON r.constructorid = c.constructorid
WHERE r.positionorder = 1
GROUP BY constructor_name
ORDER BY wins DESC;

-- Q4 Which drivers have scored the most championship points throughout their careers?

SELECT
d.forename || ' ' || d.surname AS driver_name,
SUM(r.points) AS total_points
FROM results r
JOIN drivers d
	ON r.driverid = d.driverid
GROUP BY driver_name
ORDER BY total_points DESC;

-- Q5 Which circuits have hosted the highest number of Formula 1 races?

SELECT
	c.name AS circuit_name,
	COUNT(*) AS races_held
FROM races r
JOIN circuits c
	ON r.circuitid = c.circuitid
GROUP BY circuit_name
ORDER BY races_held DESC;

-- Q6 Which countries have hosted the most Formula 1 races?

SELECT
	c.country,
	COUNT(*) AS races_hosted
FROM races r
JOIN circuits c
	ON r.circuitid = c.circuitid
GROUP BY c.country
ORDER BY races_hosted DESC;

-- Q7 Which drivers gain the most positions during races compared to their starting grid position?

SELECT
	d.forename || ' ' || d.surname AS driver_name,
	ROUND(AVG(r.grid - r.positionorder), 2) AS avg_positions_gained
FROM results r
JOIN drivers d
ON r.driverid = d.driverid
WHERE r.grid > 0
GROUP BY driver_name
HAVING COUNT(*) >= 20
ORDER BY avg_positions_gained DESC;

-- Q8 How often does starting from pole position result in winning the race?

SELECT
	ROUND(100.0 *SUM(CASE WHEN r.positionorder = 1 THEN 1 ELSE 0 END)/ COUNT(*),2
	) AS pole_position_conversion_rate
FROM qualifying q
JOIN results r
	ON q.raceid = r.raceid
AND q.driverid = r.driverid
WHERE q.position = 1;

-- Q9 Which Formula 1 seasons had the greatest variety of race winners?

SELECT
	ra.year,
	COUNT(DISTINCT r.driverid) AS unique_winners
FROM results r
JOIN races ra
	ON r.raceid = ra.raceid
WHERE r.positionorder = 1
GROUP BY ra.year
ORDER BY unique_winners DESC;

-- Q10 Which drivers have the best average finishing position across their careers?

SELECT
	d.forename || ' ' || d.surname AS driver_name,
	ROUND(AVG(r.positionorder), 2) AS average_finish_position
FROM results r
JOIN drivers d
	ON r.driverid = d.driverid
GROUP BY driver_name
HAVING COUNT(*) >= 50
ORDER BY average_finish_position ASC;

-- Q11 Which drivers have scored more championship points than the average Formula 1 driver?

WITH driver_points AS (
    SELECT
        driverid,
        SUM(points) AS total_points
    FROM results
    GROUP BY driverid
)

SELECT
    d.forename || ' ' || d.surname AS driver_name,
    dp.total_points
FROM driver_points dp
JOIN drivers d
    ON dp.driverid = d.driverid
WHERE dp.total_points >
      (SELECT AVG(total_points) FROM driver_points)
ORDER BY dp.total_points DESC;

-- Which drivers consistently outperform their starting grid position?

SELECT
    d.forename || ' ' || d.surname AS driver_name,
    ROUND(AVG(r.grid - r.positionorder), 2) AS avg_positions_gained,
    COUNT(*) AS races
FROM results r
JOIN drivers d
    ON r.driverid = d.driverid
WHERE r.grid > 0
GROUP BY driver_name
HAVING COUNT(*) >= 50
ORDER BY avg_positions_gained DESC;



-- Which drivers have a higher win rate than the average Formula 1 driver?
-- Uses: CTE


WITH driver_stats AS (
SELECT
	d.forename || ' ' || d.surname AS driver_name,
	COUNT(*) AS races,
	SUM(CASE
			WHEN r.positionorder = 1 THEN 1
			ELSE 0
			END
		) AS wins
FROM results r
JOIN drivers d
	ON r.driverid = d.driverid
GROUP BY driver_name
)

SELECT
	driver_name,
	races,
	wins,
	ROUND(100.0 * wins / races, 2) AS win_rate
FROM driver_stats
WHERE ROUND(100.0 * wins / races, 2) >
	(
	SELECT
		AVG(100.0 * wins / races)
	FROM driver_stats
	)
ORDER BY win_rate DESC;


-- Which Formula 1 teams have the highest race win rates?
-- Uses: CTE

WITH constructor_stats AS (
SELECT
	c.name AS constructor_name,
	COUNT(*) AS races_entered,
SUM(CASE
		WHEN r.positionorder = 1 THEN 1
		ELSE 0
		END
	) AS wins
FROM results r
JOIN constructors c
	ON r.constructorid = c.constructorid
GROUP BY c.name
)

SELECT
	constructor_name,
	races_entered,
	wins,
	ROUND(100.0 * wins / races_entered, 2) AS win_rate
FROM constructor_stats
WHERE races_entered >= 100
ORDER BY win_rate DESC;


-- Which drivers score the most points per race?
-- Uses: CTE

WITH driver_points AS (
	SELECT
	d.forename || ' ' || d.surname AS driver_name,
	COUNT(*) AS races,
	SUM(r.points) AS total_points
FROM results r
JOIN drivers d
	ON r.driverid = d.driverid
GROUP BY
driver_name
)

SELECT
	driver_name,
	races,
	total_points,
	ROUND(total_points / races) AS points_per_race
FROM driver_points
WHERE races >= 50
ORDER BY points_per_race DESC;


-- How do drivers rank based on their total race wins?
-- Uses: Window Function (RANK)

WITH driver_wins AS (
SELECT
	d.forename || ' ' || d.surname AS driver_name,
	SUM(CASE
			WHEN r.positionorder = 1 THEN 1
			ELSE 0
		END) AS wins
FROM results r
JOIN drivers d
	ON r.driverid = d.driverid
GROUP BY driver_name
)

SELECT
	driver_name,
	wins,
RANK() OVER (ORDER BY wins DESC) AS win_rank
FROM driver_wins
ORDER BY win_rank;


-- Who were the top three drivers in each season?
-- Uses: Window Function (DENSE_RANK)


WITH season_points AS (
	SELECT
	ra.year,
	d.forename || ' ' || d.surname AS driver_name,
	SUM(r.points) AS total_points
FROM results r
JOIN drivers d
	ON r.driverid = d.driverid
JOIN races ra
ON r.raceid = ra.raceid
GROUP BY ra.year, driver_name
)

SELECT
	year,
	driver_name,
	total_points,
	season_rank
FROM (
	SELECT
		year,
		driver_name,
		total_points,
	DENSE_RANK() OVER ( PARTITION BY year ORDER BY total_points DESC) AS season_rank
	FROM season_points) ranked
WHERE season_rank <= 3
ORDER BY year, season_rank;

-- Which constructors improved the most from one season to the next?

WITH constructor_points AS (
    SELECT
        ra.year,
        c.name AS constructor_name,
        SUM(r.points) AS total_points
    FROM results r
    JOIN races ra
        ON r.raceid = ra.raceid
    JOIN constructors c
        ON r.constructorid = c.constructorid
    GROUP BY ra.year, c.name
)

SELECT
    year,
    constructor_name,
    total_points,
    total_points -
    LAG(total_points) OVER (
        PARTITION BY constructor_name
        ORDER BY year
    ) AS points_change
FROM constructor_points
ORDER BY points_change DESC;