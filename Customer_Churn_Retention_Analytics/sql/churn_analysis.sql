-- Customer Churn & Retention Analytics
-- Compatible with MySQL 8+
-- Load customer_churn.csv into a table named customer_churn.

CREATE DATABASE IF NOT EXISTS churn_analytics;
USE churn_analytics;

CREATE TABLE IF NOT EXISTS customer_churn (
    CustomerID VARCHAR(20) PRIMARY KEY,
    Age INT,
    Gender VARCHAR(20),
    Region VARCHAR(30),
    Plan VARCHAR(30),
    TenureMonths INT,
    MonthlyCharges DECIMAL(10,2),
    TotalSpend DECIMAL(12,2),
    PaymentMethod VARCHAR(50),
    SupportInteractions INT,
    Churn VARCHAR(5)
);

-- 1. Overall KPIs
SELECT
    COUNT(*) AS total_customers,
    SUM(Churn = 'Yes') AS churned_customers,
    ROUND(100 * AVG(Churn = 'Yes'), 2) AS churn_rate_pct,
    ROUND(100 * AVG(Churn = 'No'), 2) AS retention_rate_pct
FROM customer_churn;

-- 2. Churn by region
SELECT Region,
       COUNT(*) AS customers,
       SUM(Churn='Yes') AS churned_customers,
       ROUND(100*AVG(Churn='Yes'),2) AS churn_rate_pct
FROM customer_churn
GROUP BY Region
ORDER BY churn_rate_pct DESC;

-- 3. Churn by plan
SELECT Plan,
       COUNT(*) AS customers,
       SUM(Churn='Yes') AS churned_customers,
       ROUND(100*AVG(Churn='Yes'),2) AS churn_rate_pct
FROM customer_churn
GROUP BY Plan
ORDER BY churn_rate_pct DESC;

-- 4. Churn by tenure band
SELECT
    CASE
        WHEN TenureMonths <= 12 THEN '0-12 Months'
        WHEN TenureMonths <= 24 THEN '13-24 Months'
        WHEN TenureMonths <= 36 THEN '25-36 Months'
        WHEN TenureMonths <= 48 THEN '37-48 Months'
        ELSE '49+ Months'
    END AS TenureBand,
    COUNT(*) AS customers,
    SUM(Churn='Yes') AS churned_customers,
    ROUND(100*AVG(Churn='Yes'),2) AS churn_rate_pct
FROM customer_churn
GROUP BY TenureBand
ORDER BY MIN(TenureMonths);

-- 5. Churn by payment method
SELECT PaymentMethod,
       COUNT(*) AS customers,
       SUM(Churn='Yes') AS churned_customers,
       ROUND(100*AVG(Churn='Yes'),2) AS churn_rate_pct
FROM customer_churn
GROUP BY PaymentMethod
ORDER BY churn_rate_pct DESC;

-- 6. Revenue lost due to churn
SELECT
    ROUND(SUM(CASE WHEN Churn='Yes' THEN TotalSpend ELSE 0 END),2) AS revenue_at_risk
FROM customer_churn;

-- 7. High-value churned customers
SELECT CustomerID, Region, Plan, TenureMonths,
       MonthlyCharges, TotalSpend, PaymentMethod, SupportInteractions
FROM customer_churn
WHERE Churn='Yes'
  AND TotalSpend >= (SELECT AVG(TotalSpend) FROM customer_churn)
ORDER BY TotalSpend DESC;

-- 8. Support interactions vs churn
SELECT SupportInteractions,
       COUNT(*) AS customers,
       ROUND(100*AVG(Churn='Yes'),2) AS churn_rate_pct
FROM customer_churn
GROUP BY SupportInteractions
ORDER BY SupportInteractions;

-- 9. Monthly recurring revenue lost from churn
SELECT ROUND(SUM(CASE WHEN Churn='Yes' THEN MonthlyCharges ELSE 0 END),2)
       AS monthly_revenue_at_risk
FROM customer_churn;
