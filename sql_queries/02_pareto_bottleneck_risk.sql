-- ==============================================================================
-- Query: Network Bottleneck Risk (Pareto Analysis)
-- Description: Calculates the cumulative running sum of tonnage to 
--              identify which top ports carry 80% of the network's capacity.
-- ==============================================================================
use port0499;
WITH PortTotals AS (
    SELECT 
        Major_Port,
        SUM(Tonnage_thousands) AS port_tonnage
    FROM 
        port0499_clean_final
    GROUP BY 
        Major_Port
),
TotalNetwork AS (
    SELECT SUM(port_tonnage) AS grand_total FROM PortTotals
)

SELECT 
    pt.Major_Port,
    pt.port_tonnage,
    SUM(pt.port_tonnage) OVER (ORDER BY pt.port_tonnage DESC) AS cumulative_tonnage,
    ROUND(
        SUM(pt.port_tonnage) OVER (ORDER BY pt.port_tonnage DESC) * 100.0 / tn.grand_total, 
    1) AS cumulative_pct
FROM 
    PortTotals pt
CROSS JOIN 
    TotalNetwork tn
ORDER BY 
    pt.port_tonnage DESC;