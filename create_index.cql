// Drop already created indexes
DROP INDEX ON :Driver(name)

// Create Indexes
CREATE INDEX driver For (d: Driver) ON (d.driver);
CREATE INDEX country For (c:Country) ON (c.country);
CREATE INDEX grandprix For (gp:GrapndPrix) ON (gp.grandprix);
CREATE INDEX circuit For (cir:CircuitLocation) ON (cir.circuit);
CREATE INDEX resultid For (rd:resultId) ON (rd.resultid);
CREATE INDEX circuitname For (cn:CircuitName) ON (cn.circuitname);

// Check all indexes
CALL db.indexes()

//Create constraints
CREATE CONSTRAINT ON (rd:resultId) ASSERT rd.resultId IS UNIQUE;

// Main Load script
:auto USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM'file:///Users/olgascrivner/Documents/IU-DataScience/Database/Spring2021/slides/week11/HospitalGeneralInformation.csv' AS row
WITH row
WHERE row.State = 'NY'// state name is unique
MERGE (state:State{name:row.State}) // merge by pattern with their parents
MERGE (state)<-[:IS_IN]-(county:County{name:row.County_Name})
MERGE (county)<-[:IS_IN]-(city:City{name:row.City})
MERGE (city)<-[:IS_IN]-(zip:ZipCode{name:row.ZIPCode})
MERGE (zip)<-[:IS_IN]-(address:Address{name:row.Address}) // for entities, it is best to have an id system
MERGE (h:Hospital{id:row.Provider_ID})
MERGE (h)-[:IS_IN]->(address)