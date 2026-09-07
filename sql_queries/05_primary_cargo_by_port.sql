-- What is the primary cargo type for each major port?
use port0499;
WITH RankedCargo AS (
    SELECT 
        Major_Port, 
        Cargo_Group, 
        SUM(Tonnage_thousands) AS Total_Tonnage,
        RANK() OVER(PARTITION BY Major_Port ORDER BY SUM(Tonnage_thousands) DESC) as CargoRank
    FROM port0499_clean_final
    GROUP BY Major_Port, Cargo_Group
)
SELECT Major_Port, Cargo_Group, ROUND(Total_Tonnage, 2) AS Top_Cargo_Tonnage
FROM RankedCargo
WHERE CargoRank = 1
ORDER BY Top_Cargo_Tonnage DESC;