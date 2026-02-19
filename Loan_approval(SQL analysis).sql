Create Database Project;
Use Project;
select * from loan_approval;

-- 1. Which customer segments (age_group + occupation_status) have the highest loan approval rate?

SELECT 
    age_group,
    occupation_status,
    COUNT(*) AS total_customers,
    SUM(loan_status) AS approved_loans,
    ROUND(100 * SUM(loan_status) / COUNT(*), 2) AS approval_rate
FROM loan_approval
GROUP BY age_group , occupation_status
ORDER BY approval_rate DESC;

-- 2. What product types generate the most approved loan volume?

SELECT product_type, COUNT(*) AS Total_customers, ROUND(AVG(loan_amount), 2) AS Avg_loan_amount,
    SUM(loan_status) AS loans_approved,
    SUM(CASE
        WHEN loan_status = 1 THEN loan_amount
    END) AS Total_approved_volume
FROM loan_approval
GROUP BY product_type
ORDER BY loans_approved DESC;

-- 3. Which credit score range brings the highest revenue potential?

SELECT credit_tier, COUNT(*) AS Total_customers, SUM(loan_status) AS loans_approved,
    100 * SUM(loan_status) / COUNT(*) AS loan_approved_PCT
FROM loan_approval
GROUP BY credit_tier
ORDER BY loans_approved DESC;

-- 4. Which loan intent (purpose) has the lowest default risk?

SELECT loan_intent, COUNT(*) AS Total_customers, SUM(defaults_on_file) AS sum_of_defaults,
    ROUND(100 * SUM(defaults_on_file) / COUNT(*),1) AS default_PCT
FROM loan_approval
GROUP BY loan_intent
ORDER BY default_PCT;

-- 5. Do high-income customers still default? (revenue protection)

SELECT income_bucket, ROUND(AVG(annual_income), 2) AS Avg_income, COUNT(*) AS Total_customers,
	SUM(defaults_on_file) AS defaults, 100 * SUM(defaults_on_file) / COUNT(*) AS Default_rate
FROM loan_approval
GROUP BY income_bucket
ORDER BY Default_rate;

-- 6. Which customer groups pay the highest interest rate on approved loans?

SELECT age_group, occupation_status, ROUND(AVG(interest_rate), 1) AS avg_interest_rate
FROM loan_approval
GROUP BY age_group , occupation_status
ORDER BY avg_interest_rate DESC;

-- 7. Which customers have capacity to borrow more? (low debt-to-income + approved)

SELECT customer_id, annual_income, debt_to_income_ratio, loan_amount
FROM loan_approval
WHERE loan_status = 1
ORDER BY debt_to_income_ratio
LIMIT 10;

-- 8. Do credit score and interest rate align? (pricing leakage detection)

SELECT credit_score, ROUND(AVG(interest_rate), 2) AS Avg_interest_rate
FROM loan_approval
GROUP BY credit_score
ORDER BY credit_score;

-- 9. Which age groups default the most?  middle aged 11336

SELECT age_group, COUNT(*) AS Total_customers, SUM(defaults_on_file) AS defaulters,
    ROUND(100 * SUM(defaults_on_file) / COUNT(*), 2) AS Default_rate
FROM loan_approval
GROUP BY age_group
ORDER BY default_rate DESC;

-- 10. Which occupation group brings the most loan revenue?

SELECT occupation_status,COUNT(*) AS Total_customers,SUM(loan_status) AS loan_approval, 
ROUND(AVG(payment_to_income_ratio), 2) AS Avg_payment_to_income_ratio
FROM loan_approval
GROUP BY occupation_status
ORDER BY Avg_payment_to_income_ratio DESC;
 
-- 11. Which customers are likely underpriced? (High risk but low interest rate)

SELECT customer_id, credit_score, credit_tier,delinquencies_last_2yrs,
defaults_on_file, interest_rate
FROM loan_approval
WHERE credit_score < 600 AND delinquencies_last_2yrs > 2 AND defaults_on_file = 1
ORDER BY interest_rate ;
