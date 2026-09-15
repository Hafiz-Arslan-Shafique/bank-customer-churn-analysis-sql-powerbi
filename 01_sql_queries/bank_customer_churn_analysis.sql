CREATE DATABASE BankChurnDB;
-- Churn means leave the bank permanently
-- Confirm all 10000 customers are imported. This is always the first step.
SELECT COUNT(*) AS Total_Customers 
FROM dbo.Bank_Customer_Churn;

---(Primary Key Test) Is CustomerId unique? 
SELECT CustomerId, COUNT(*) AS Duplicate_Count
FROM dbo.Bank_Customer_Churn
GROUP BY CustomerId
HAVING COUNT(*) > 1;

-- Overall Churn Rate - Your Main KPI (We calculate how many customers left out of 10000)
SELECT
    COUNT(*) AS Total_Customers,
    SUM(CAST(Exited AS INT)) AS Customers_Who_Left,
    CAST(SUM(CAST(Exited AS INT)) * 100.0 / COUNT(*) AS DECIMAL(5,2)) AS Churn_Percent
FROM dbo.Bank_Customer_Churn;

-- Who leaves more - Active (1) or Inactive (0) members?
SELECT 
    IsActiveMember,
    COUNT(*) AS Total_Customers,
    SUM(CAST(Exited AS INT)) AS Customers_Left,
    CAST(SUM(CAST(Exited AS INT)) * 100.0 / COUNT(*) AS DECIMAL(5,2)) AS Churn_Percent
FROM dbo.Bank_Customer_Churn
GROUP BY IsActiveMember
ORDER BY IsActiveMember DESC;

-- Does Complaint cause churn? (Check if Complain = 1 is the strongest reason for leaving.)
SELECT 
    Complain,
    COUNT(*) AS Total_Customers,
    SUM(CAST(Exited AS INT)) AS Customers_Left,
    CAST(SUM(CAST(Exited AS INT)) * 100.0 / COUNT(*) AS DECIMAL(5,2)) AS Churn_Percent
FROM dbo.Bank_Customer_Churn
GROUP BY Complain
ORDER BY Complain DESC;

-- Which country is failing (which country has more churn rate?)
SELECT Geography, COUNT(*) AS Total,
    SUM(CAST(Exited AS INT)) AS Customers_Left,
    CAST(SUM(CAST(Exited AS INT)) * 100.0 / COUNT(*) AS DECIMAL(5,2)) AS Churn_Percent
FROM dbo.Bank_Customer_Churn
GROUP BY Geography
ORDER BY Churn_Percent DESC;

-- Does your card type save customer? This is your unique column.
SELECT Card_Type, COUNT(*) AS Total,
    SUM(CAST(Exited AS INT)) AS Customers_Left,
    CAST(SUM(CAST(Exited AS INT)) * 100.0 / COUNT(*) AS DECIMAL(5,2)) AS Churn_Percent
FROM dbo.Bank_Customer_Churn
GROUP BY Card_Type
ORDER BY Churn_Percent DESC;

-- Does low satisfaction = high churn? This is perfect for Power BI line chart.
SELECT Satisfaction_Score, COUNT(*) AS Total,
    SUM(CAST(Exited AS INT)) AS Customers_Left,
    CAST(SUM(CAST(Exited AS INT)) * 100.0 / COUNT(*) AS DECIMAL(5,2)) AS Churn_Percent
FROM dbo.Bank_Customer_Churn
GROUP BY Satisfaction_Score
ORDER BY Satisfaction_Score;

-- Riskiest Customer Profile (FINAL CHECK)
SELECT 
    Geography,
    Complain,
    IsActiveMember,
    COUNT(*) AS Total,
    SUM(CAST(Exited AS INT)) AS Customers_Left,
    CAST(SUM(CAST(Exited AS INT)) * 100.0 / COUNT(*) AS DECIMAL(5,2)) AS Churn_Percent
FROM dbo.Bank_Customer_Churn
GROUP BY Geography, Complain, IsActiveMember
ORDER BY Churn_Percent DESC;
