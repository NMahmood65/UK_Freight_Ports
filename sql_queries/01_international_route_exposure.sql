-- ==============================================================================
-- Query: Port Exposure to International Trade Routes
-- Description: Calculates the ratio of international vs. domestic freight 
--              for each major UK port to identify global supply chain risk.
-- ==============================================================================
use port0499;
SELECT 
    Major_Port,
    SUM(Tonnage_thousands) AS total_tonnage,
    SUM(CASE WHEN Port_of_Load_Unload_Region != 'Domestic' THEN Tonnage_thousands ELSE 0 END) AS international_tonnage,
    SUM(CASE WHEN Port_of_Load_Unload_Region = 'Domestic' THEN Tonnage_thousands ELSE 0 END) AS domestic_tonnage,
    -- Calculate the percentage of international volume
    ROUND(
        SUM(CASE WHEN Port_of_Load_Unload_Region != 'Domestic' THEN Tonnage_thousands ELSE 0 END) * 100.0 / SUM(Tonnage_thousands), 
    1) AS pct_international
FROM 
    port0499_clean_final
GROUP BY 
    Major_Port
ORDER BY 
    pct_international DESC;