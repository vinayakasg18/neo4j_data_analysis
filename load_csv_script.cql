LOAD CSV WITH HEADERS FROM 'file:///Users/vinayakgadag/IU/FirstSemester/SQL-NOSQL/neo4j-project/out.csv' AS f1 WITH f1 LIMIT 1 RETURN f1

// Main Load script
:auto USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM 'file:///Users/vinayakgadag/IU/FirstSemester/SQL-NOSQL/neo4j-project/out.csv' AS f1
WITH f1
WHERE row.State = 'NY'// state name is unique
MERGE (state:State{name:row.State})// merge by pattern with their parents
MERGE (state)<-[:IS_IN]-(county:County{name:row.County_Name})
MERGE (county)<-[:IS_IN]-(city:City{name:row.City})
MERGE (city)<-[:IS_IN]-(zip:ZipCode{name:row.ZIPCode})
MERGE (zip)<-[:IS_IN]-(address:Address{name:row.Address})// for entities, it is best to have an id system
MERGE (h:Hospital{id:row.Provider_ID})
MERGE (h)-[:IS_IN]->(address)


// Main Load script

:auto USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM 'file:///Users/vinayakgadag/IU/FirstSemester/SQL-NOSQL/neo4j-project/out.csv' AS f1
WITH f1
WHERE f1.GrapndPrix = 'Abu Dhabi Grand Prix'
MERGE (grandprix:GrapndPrix{grandprix:f1.GPName})
MERGE (grandprix)<-[:HAS_CIRCUITS]-(circuitname:CircuitName{circuitname:f1.CircuitName})
MERGE (circuitname)<-[:HAS_PARTICIPANTS]-(driver:Driver{driver:f1.Driver})
MERGE (driver)<-[:FROM_COUNTRY]-(country:Country{country:f1.Country})
MERGE (grandprix)<-[:HAPPENED_IN]-(year:Year{year:f1.Year})
MERGE (driver)<-[:HAS_POINTS]-(points:Points{points:f1.points})
MERGE (d:Driver{rd:f1.resultId})
MERGE (circuitname)-[:HAPPENED_IN]->(country)


:auto USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM 'file:///Users/vinayakgadag/IU/FirstSemester/SQL-NOSQL/neo4j-project/out.csv' AS f1
WITH f1
WHERE f1.GPName = 'Abu Dhabi Grand Prix'
MERGE (grandprix:GrapndPrix{grandprix:f1.GPName})
MERGE (grandprix)<-[:HAS_CIRCUITS]-(circuitname:CircuitName{circuitname:f1.CircuitName})
MERGE (circuitname)<-[:HAS_PARTICIPANTS]-(driver:Driver{driver:f1.Driver})
MERGE (driver)<-[:FROM_COUNTRY]-(country:Country{country:f1.CircuitCountry})
MERGE (grandprix)<-[:HAPPENED_IN]-(year:Year{year:f1.Year})
MERGE (driver)<-[:HAS_POINTS]-(points:Points{points:f1.points})
MERGE (d:Driver{rd:f1.resultId})
MERGE (circuitname)-[:HAPPENED_IN]->(country)

---------------------------------------------------------------------------------------------------------------------

// Update properties of existing nodes
LOAD CSV WITH HEADERS FROM 'file:///Users/vinayakgadag/IU/FirstSemester/SQL-NOSQL/neo4j-project/out.csv' AS row // load csv
WITH row 
MERGE(circuit:CircuitName{name:row.CircuitName,location:row.CircuitLocation})
SET circuit = {name:row.CircuitName,location:row.CircuitLocation,country:row.CircuitCountry}
RETURN circuit

---------------------------------------------------------------------------------------------------------------------

// Create Indexes
CREATE INDEX driver For (d: Driver) ON (d.driver);
CREATE INDEX country For (c:Country) ON (c.country);
CREATE INDEX grandprix For (gp:GrapndPrix) ON (gp.grandprix);
CREATE INDEX circuit For (cir:CircuitLocation) ON (cir.circuit);
CREATE INDEX resultid For (rd:resultId) ON (rd.resultid);
CREATE INDEX circuitname For (cn:CircuitName) ON (cn.circuitname);

//Create unique constraint
CREATE CONSTRAINT ON (rd:resultId) ASSERT rd.resultId IS UNIQUE;

// Load file into db
LOAD CSV WITH HEADERS FROM 'file:///Users/vinayakgadag/IU/FirstSemester/SQL-NOSQL/neo4j-project/out.csv' AS row // load csv

WITH row // accessible object
// Create nodes, set properties and merge
MERGE(grandprix:GrapndPrix{name:row.GPName,date:row.GPDate,year:row.Year})
MERGE(driver:Driver{name:row.Driver,notionality:row.DriverNationality,dob:row.DriverDOB,driverWin:row.DriverWin})
MERGE(circuit:CircuitName{name:row.CircuitName,location:row.CircuitLocation,country:row.CircuitCountry})
MERGE(result:Result{id:row.resultId})
MERGE(points:Points{driverPoints:row.points,constructorPoints:row.ConstructorPoints})
MERGE(rank:Rank{driverRank:row.rank,constructorRank:row.ConstructorRank})
MERGE(constructor:Constructor{name:row.Constructor,country:row.ConstructorNationality})
MERGE(status:Status{stat: row.Status})
MERGE(laps:Laps{laps:row.laps})

// Create relationships between nodes
MERGE (grandprix)-[:HAS_CIRCUITS]->(circuit)
MERGE (grandprix)-[:CURRENT_STATUS]->(status)
MERGE (grandprix)-[:RESULT{resultid:row.resultId}]->(result)
MERGE (driver)-[:DRIVES]->(constructor)
MERGE (driver)-[:PARTICIPATES_IN]->(grandprix)
MERGE (driver)-[:HAS_POINTS]->(points)
MERGE (driver)-[:RANKED_AT]->(rank)
MERGE (driver)-[:PART_OF]->(circuit)
MERGE (driver)-[:COMPLETED_LAPS]->(laps)
MERGE (constructor)-[:CONSTRUCTOR_RANKED_AT]->(rank)
MERGE (constructor)-[:CONSTRUCTOR_POINTS]->(points)
MERGE (constructor)-[:CONSTRUCTOR_COMPLETED_LAPS]->(laps)