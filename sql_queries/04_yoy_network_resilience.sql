-- To analyze network resilience during the 2008-2009 financial crisis and the 2020 pandemic, you need a Year-over-Year 
-- (YoY) calculation. This query uses MySQL's LAG() window function to calculate the exact percentage drop and 
-- subsequent recovery for every year.
use port0499;
WITH YearlyTotals AS (
    SELECT 
        Year,
        SUM(Tonnage_thousands) AS Total_Tonnage,
        SUM(TEU_thousands) AS Total_TEU
    FROM port0499_clean_final
    GROUP BY Year
)
SELECT 
    Year,
    ROUND(Total_Tonnage, 2) AS Total_Tonnage,
    ROUND(((Total_Tonnage - LAG(Total_Tonnage) OVER (ORDER BY Year)) / 
           LAG(Total_Tonnage) OVER (ORDER BY Year)) * 100, 2) AS Tonnage_YoY_Growth_Pct,
    ROUND(Total_TEU, 2) AS Total_TEU,
    ROUND(((Total_TEU - LAG(Total_TEU) OVER (ORDER BY Year)) / 
           LAG(Total_TEU) OVER (ORDER BY Year)) * 100, 2) AS TEU_YoY_Growth_Pct
FROM YearlyTotals
ORDER BY Year;