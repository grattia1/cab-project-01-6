#! /bin/bash

drop EnergySupply;
createDB EnergySupply;


#Generates the Database
psql - U postgres -d EnergySupply -c
"CREATE TABLE Month (
        Name DATE PRIMARY KEY,
        Num_days int
);"

