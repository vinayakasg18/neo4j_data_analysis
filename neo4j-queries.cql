// Number of times Hamilton participated in the GP where the status of GP is 'Finished'
MATCH (s:Status)--(gp:GrapndPrix)<-[p:PARTICIPATES_IN]-(d:Driver {name: 'HAMILTON'}) WHERE s.stat='Finished' RETURN gp.name AS GP, COUNT(d) AS participated_count ORDER BY participated_count DESC;

// Return all GP organized greater than or equal to 'year' 2000 where Hamilton won and number of times he participated in
MATCH (gp:GrapndPrix)<-[p:PARTICIPATES_IN]-(d:Driver) WHERE d.driverWin='TRUE' AND toInteger(gp.year) >= 2000 AND d.name='HAMILTON' RETURN gp.name AS GP, count(d) AS win_and_part_count

// Return distinct count of drivers part of the circuits
MATCH (d:Driver)--(cn:CircuitName) RETURN COUNT(DISTINCT d) AS driver_count, cn.name AS circuit_name

// Return the drivers who won the grand prix post 'Year' 2010 and limit to 10 records
MATCH (gp:GrapndPrix)<-[:PARTICIPATES_IN]-(driver) WHERE driver.driverWin='TRUE' AND toInteger(gp.year) > 2010 RETURN gp.name AS GrandPrix, toInteger(gp.year) AS Year, driver.name as Driver LIMIT 10

// Average number of laps completed by driver and order by descending order
MATCH (l:Laps)<-[:COMPLETED_LAPS]-(driver) RETURN driver.name as driver, avg(toInteger(l.laps)) AS laps ORDER BY laps DESC

// Return all the distinct circuits in the grand prix
MATCH (gp:GrapndPrix)-[:HAS_CIRCUITS]->(c:CircuitName) RETURN gp.name AS GrandPrix, COLLECT(DISTINCT c.name) AS circuits

// Manipulate data to update the property of the node/label
MATCH (c:CircuitName)
FOREACH (i in CASE WHEN c.country='USA' THEN [1] ELSE [] END |
  SET c.country = 'United States')
WHERE c.country='USA'
RETURN COUNT(c)

// Interesting facts
    // Hamilton won more number of different grandPrix organized post 2010-2017 comparing to other drivers
    // As per the data which has been reduced to 3500 rows for simplicity
    MATCH (g:GrapndPrix)<-[:PARTICIPATES_IN]-(d:Driver{driverWin:'TRUE'})
    WHERE g.year >="2010" AND g.year <="2017"
    return d.name AS driver, count(d.name) AS win_count ORDER BY win_count DESC;

    // Most grand prix wins since inception by Hamilton 
    // As per the data which has been reduced to 3500 rows for simplicity
    MATCH (g:GrapndPrix)<-[:PARTICIPATES_IN]-(d:Driver{driverWin:'TRUE'})
    return d.name AS driver, count(d.name) AS win_count ORDER BY win_count DESC;