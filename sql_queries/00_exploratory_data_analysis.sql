-- ==============================================================================
-- Query: Container Utilization KPI (Empty-Unit Rate)
-- Description: Calculates the percentage of empty freight units processed per port.
--              High empty-unit rates indicate operational inefficiencies and wasted 
--              network capacity, highlighting areas for supply chain optimization.
-- ==============================================================================
use port0499;
SELECT 
    Major_Port,
    ROUND(SUM(Empty_Units_thousands), 2) AS Total_Empty_Units,
    ROUND(SUM(Total_Units_thousands), 2) AS Total_Units,
    -- NULLIF prevents 'divide by zero' errors if a port only handles bulk freight (no units)
    ROUND((SUM(Empty_Units_thousands) / NULLIF(SUM(Total_Units_thousands), 0)) * 100, 2) AS Empty_Unit_Rate_Pct
FROM port0499_clean_final
GROUP BY Major_Port
HAVING Total_Units > 0
ORDER BY Empty_Unit_Rate_Pct DESC;




-- How has total cargo volume evolved year-over-year for each major port broken down into different cargo groups?
use port0499;
SELECT 
    Year, 
    Major_Port, 
    Cargo_Group, 
    ROUND(SUM(Tonnage_thousands), 2) AS Total_Tonnage
FROM port0499_clean_final
GROUP BY Year, Major_Port, Cargo_Group
ORDER BY Major_Port ASC, Cargo_Group ASC, Year ASC;




-- Efficiency & Utilization
-- Which ports suffer from the highest rate of empty container routing?
use port0499;
SELECT 
    Major_Port, 
    ROUND(SUM(Empty_Units_thousands), 2) AS Total_Empty_Units, 
    ROUND(SUM(Total_Units_thousands), 2) AS Total_Units, 
    ROUND((SUM(Empty_Units_thousands) / NULLIF(SUM(Total_Units_thousands), 0)) * 100, 2) AS Empty_Ratio_Pct 
FROM port0499_clean_final 
GROUP BY Major_Port 
HAVING Total_Units > 0
ORDER BY Empty_Ratio_Pct DESC;




-- Cargo Profiling
-- What cargo groups drive the most volume globally?
use port0499;
SELECT 
    Cargo_Group, 
    ROUND(SUM(Tonnage_thousands), 2) AS Total_Tonnage,
    ROUND((SUM(Tonnage_thousands) / (SELECT SUM(Tonnage_thousands) FROM port0499_clean_final)) * 100, 2) AS Pct_of_Total_Volume
FROM port0499_clean_final
GROUP BY Cargo_Group 
ORDER BY Total_Tonnage DESC;



-- Trade Routes & Global Markets
-- Who are the top 10 international trading partners by volume?
use port0499;
SELECT 
    Port_of_Load_Unload_Country, 
    ROUND(SUM(Tonnage_thousands), 2) AS Total_Tonnage 
FROM port0499_clean_final
GROUP BY Port_of_Load_Unload_Country 
ORDER BY Total_Tonnage DESC 
LIMIT 10;



-- Port Performance & Benchmarking
-- Which ports handle the highest overall tonnage?
use port0499;
SELECT 
    Major_Port, 
    ROUND(SUM(Tonnage_thousands), 2) AS Total_Tonnage,
    ROUND(SUM(Total_Units_thousands), 2) AS Total_Units
FROM port0499_clean_final
GROUP BY Major_Port 
ORDER BY Total_Tonnage DESC;




-- What is the balance of trade (Inwards vs. Outwards)?
use port0499;
SELECT 
    Year, 
    Direction, 
    ROUND(SUM(Tonnage_thousands), 2) AS Total_Tonnage 
FROM port0499_clean_final
GROUP BY Year, Direction 
ORDER BY Year ASC, Direction ASC;




-- Volume & Growth Trends
-- How has total cargo volume evolved year-over-year?
use port0499;
SELECT 
    Year, 
    ROUND(SUM(Tonnage_thousands), 2) AS Total_Tonnage, 
    ROUND(SUM(TEU_thousands), 2) AS Total_TEU 
FROM port0499_clean_final
GROUP BY Year 
ORDER BY Year ASC;

