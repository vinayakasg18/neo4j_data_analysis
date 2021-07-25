//count data rows in products.csv (no headers)
LOAD CSV WITH HEADERS FROM 'file:///Users/vinayakgadag/IU/FirstSemester/SQL-NOSQL/neo4j-project-manisha/Project_02_Ecommerce_dataset.csv' AS row
RETURN count(row);