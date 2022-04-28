CREATE VIEW Meter_month_cost_with_energy_type AS
SELECT Energy_type, Month_name, Amount, Units, Total_monetary_cost, total_environmental_cost
FROM Meter_month_cost
INNER JOIN Meter
ON Meter_month_cost.Meter_name = Meter.name;

DELETE FROM Meter_month_cost
WHERE Total_monetary_cost IS NULL;

CREATE VIEW Meter_month_cost_aggragated_by_energy_type (Energy_type, Month_name, Amount, Units, Total_monetary_cost, Total_environmental_cost) AS
SELECT Energy_type, Month_name, SUM(Amount), Units, SUM(Total_monetary_cost), SUM(Total_environmental_cost)
FROM Meter_month_cost_with_energy_type
GROUP BY Energy_type, Month_name, Units
ORDER BY Energy_type, SUM(Amount);



