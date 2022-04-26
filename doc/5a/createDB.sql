CREATE TABLE Energy_type (
            Name VARCHAR(40) PRIMARY KEY,
Environmental_unit_cost money,
Units VARCHAR(40)
);


CREATE TABLE Month (
        Name DATE PRIMARY KEY,
        Num_days int
);


CREATE TABLE Meter (
        Name Varchar(40) PRIMARY KEY,
        Energy_type Varchar(40),
        Units Varchar(40),
        FOREIGN KEY (Energy_type) REFERENCES Energy_type(Name)
);


CREATE TABLE Meter_month_cost (
        Month_name DATE,
        Meter_name varchar(40),
        Amount Decimal(10,2),
        Total_monetary_cost money,
        Total_environmental_cost money,
        PRIMARY KEY (Month_name, Meter_name),
        FOREIGN KEY (Month_name) REFERENCES MONTH(Name),
        FOREIGN KEY (Meter_name) REFERENCES Meter(Name)
);


CREATE TABLE Weather_month (
        Name DATE PRIMARY KEY,
        Num_heat_days int,
        Num_cool_days int,
        FOREIGN KEY (Name) REFERENCES MONTH(Name)
);

