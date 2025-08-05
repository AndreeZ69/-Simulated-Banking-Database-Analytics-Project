-- analysis_queries.sql
-- Sample SQL queries for simulated banking database

-- 1. Average transaction value per account type
SELECT 
    a.account_type,
    AVG(t.amount) AS avg_transaction_value
FROM transactions t
JOIN accounts a ON t.account_id = a.account_id
GROUP BY a.account_type
ORDER BY avg_transaction_value DESC;

-- 2. Monthly account closures (churn rate proxy)
SELECT
    DATE_TRUNC('month', opened_date) AS month,
    COUNT(*) FILTER (WHERE status = 'closed') AS closed_accounts
FROM accounts
GROUP BY month
ORDER BY month;

-- 3. Customers with delinquent credit accounts (latest credit score < 600)
WITH latest_scores AS (
    SELECT DISTINCT ON (customer_id)
        customer_id, score, recorded_date
    FROM credit_scores
    ORDER BY customer_id, recorded_date DESC
)
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    ls.score AS latest_credit_score
FROM latest_scores ls
JOIN customers c ON ls.customer_id = c.customer_id
WHERE ls.score < 600
ORDER BY ls.score;

-- 4. Net monthly inflow/outflow
SELECT
    DATE_TRUNC('month', t.transaction_date) AS month,
    SUM(CASE WHEN t.transaction_type = 'deposit' THEN t.amount 
             WHEN t.transaction_type = 'withdrawal' THEN -t.amount
             ELSE 0 END) AS net_flow
FROM transactions t
GROUP BY month
ORDER BY month;

-- 5. Top 5 customers by total transaction volume
SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    SUM(t.amount) AS total_volume
FROM transactions t
JOIN accounts a ON t.account_id = a.account_id
JOIN customers c ON a.customer_id = c.customer_id
GROUP BY c.customer_id, customer_name
ORDER BY total_volume DESC
LIMIT 5;

-- 6. Average credit score over the past 6 months
SELECT
    DATE_TRUNC('month', recorded_date) AS month,
    AVG(score) AS avg_credit_score
FROM credit_scores
WHERE recorded_date >= (CURRENT_DATE - INTERVAL '6 months')
GROUP BY month
ORDER BY month;
