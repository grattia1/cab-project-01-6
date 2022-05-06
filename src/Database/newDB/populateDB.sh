#! /bin/bash

#populates the Energy_type table
psql energydb -c "\COPY Energy_type(Name, Environmental_unit_cost, Units)
FROM '/home/lion/Desktop/EnergyProject/newDB/Energy_Type.csv'
DELIMITER ','
CSV HEADER;
"

#If I try to populate the Month table directly from Month.csv,
#I get a constraint error, as Month.csv has multiple entries of the same month.
#Since month name is a primary key in the month relation, this would violate the primary
#kkey constraint. So what I did instead was make a MonthTemp table
#Equiviliant to the Month table, excepmt without the primary key constraint.
# I then poopulated the data to the monthtemp table. Finally, I insert the data
#from the month_temp table to/populate.sh the month table using a cleanup querry.
psql energydb -c "CREATE TABLE Month_Temp(
        Name DATE,
        Num_days int
);" 

#copying data to month_temp table
psql energydb -c "\COPY Month_Temp(Name, Num_days)
FROM '/home/lion/Desktop/EnergyProject/newDB/Month.csv'
DELIMITER ','
CSV HEADER;"


#Cleanup querry
psql energydb -c "
INSERT INTO Month
SELECT DISTINCT NAME, NUM_DAYS
FROM Month_Temp
ORDER BY name;
"
#drops the temp_month relation
psql energydb -c "
DROP TABLE month_temp
"
#populates the meter table
psql energydb -c "\COPY Meter(Name, Energy_type, Units)
FROM '/home/lion/Desktop/EnergyProject/newDB/Meter.csv'
DELIMITER ','
CSV HEADER;"

#I have a similar problem with the copying the data to the meter_month_cost 
#relation, since meter_month_cost.csv has multiple tuples with the same date,
#which violates the date primary key constraint. I think. Either way, I am still
#working on this final table, and deciding how it should go in. I, so nothing is in stone. The next step foreward,
#is to get rid of the 38 incorrectly labled meter_name entries, and then go 
#from there.

#creates the temporary table
psql energydb -c "CREATE TABLE Temp_meter_month_cost (
        Month_name DATE,
        Meter_name varchar(40),
        Amount Decimal(13,2),
        Total_monetary_cost money,
        Total_environmental_cost money,
		Total_cost money,
        FOREIGN KEY (Meter_name) REFERENCES Meter(Name)
);"


#populates the temp_meter_month_cost table
psql energydb -c "\COPY Temp_meter_month_cost(Month_name, Meter_name, Amount, Total_monetary_cost, Total_environmental_cost, Total_cost)
FROM '/home/lion/Desktop/EnergyProject/newDB/Meter_Month_Cost5.csv'
DELIMITER ','
CSV HEADER;"

#The cleanup function, looks as follows:

psql energydb -c "
INSERT INTO meter_month_cost 
SELECT month_name, meter_name, SUM(amount), SUM(total_monetary_cost), SUM(total_environmental_cost), SUM(Total_cost)
FROM temp_meter_month_cost
GROUP BY meter_name, month_name
ORDER BY meter_name, month_name;
"

#drops the temp_meter_month_cost relation
#psql project1 -c "
#DROP TABLE temp_meter_month_cost;
#"

