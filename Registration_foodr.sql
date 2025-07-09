--Registrations running total - query
WITH reg_dates AS
(SELECT user_id, MIN(order_date) 
AS reg_date
FROM orders
GROUP BY user_id),
registrations AS
(SELECT 
DATE_TRUNC('month',reg_date)::DATE AS foodr_month,
COUNT(DISTINCT user_id) AS regs
FROM reg_dates
GROUP BY foodr_month)
SELECT foodr_month,regs,
SUM(regs) OVER (ORDER BY foodr_month ASC) AS regs_rt
FROM registrations
ORDER BY foodr_month ASC
LIMIT 5;

--Lagged MAU - query
WITH maus AS
(
SELECT
DATE_TRUNC('month',order_date)::DATE AS foodr_month,
COUNT(DISTINCT user_id) AS mau
FROM orders
GROUP BY foodr_month)
SELECT 
foodr_month,mau, 
COALESCE(LAG(mau) OVER(ORDER BY foodr_month ASC),1)
 AS last_mau
FROM maus
ORDER BY foodr_month ASC
LIMIT 3;

--Deltas-query
WITH maus AS
(
SELECT 
DATE_TRUNC('month',order_date)::DATE AS foodr_month,
COUNT(DISTINCT user_id) AS mau
FROM orders
GROUP BY foodr_month),
maus_lags AS (
SELECT 
foodr_month, mau,
COALESCE(
LAG(mau) OVER(ORDER BY foodr_month ASC),1) AS last_mau
FROM maus
)
SELECT 
foodr_month,mau,mau-last_mau AS mau_delta
FROM maus_lag
ORDER BY foodr_month
LIMIT 3;
)
