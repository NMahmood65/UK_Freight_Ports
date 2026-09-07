-- ==============================================================================
-- Query: Top 10 Port Concentration KPI
-- Description: Calculates the total market share of the top 10 UK ports combined.
-- ==============================================================================
use port0499;
WITH RankedPorts AS (
    SELECT 
        Major_Port,
        SUM(Tonnage_thousands) AS port_tonnage,
        RANK() OVER (ORDER BY SUM(Tonnage_thousands) DESC) as port_rank
    FROM 
        port0499_clean_final
    GROUP BY 
        Major_Port
)

SELECT 
    SUM(CASE WHEN port_rank <= 10 THEN port_tonnage ELSE 0 END) AS top_10_tonnage,
    SUM(port_tonnage) AS total_network_tonnage,
    ROUND(
        SUM(CASE WHEN port_rank <= 10 THEN port_tonnage ELSE 0 END) * 100.0 / SUM(port_tonnage),
    1) AS top_10_market_share_pct
FROM 
    RankedPorts;