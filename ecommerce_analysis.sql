-- ============================================================
-- E-COMMERCE SALES ANALYSIS
-- Clean SQL Analysis
-- ============================================================

USE practice;


-- ============================================================
-- 01. DATA QUALITY CHECKS
-- ============================================================

-- Check table structure
DESCRIBE orders_data;

-- Check total rows
SELECT COUNT(*) AS total_rows
FROM orders_data;

-- Check NULL values in important columns
SELECT COUNT(*) AS null_revenue_difference
FROM orders_data
WHERE revenue_difference IS NULL;

SELECT COUNT(*) AS null_revenue
FROM orders_data
WHERE revenue_usd IS NULL;

SELECT COUNT(*) AS null_order_id
FROM orders_data
WHERE order_id IS NULL;

-- Check missing/invalid transaction values
SELECT COUNT(*) AS invalid_values
FROM orders_data
WHERE items_purchased IS NULL
   OR price_usd IS NULL
   OR items_purchased <= 0
   OR price_usd <= 0
   OR cogs_usd < 0;

-- Check orders with multiple rows
SELECT
    order_id,
    COUNT(*) AS row_count
FROM orders_data
GROUP BY order_id
HAVING COUNT(*) > 1;


-- ============================================================
-- 02. BASIC BUSINESS METRICS
-- ============================================================

-- Total orders, items sold, revenue and profit
SELECT
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(items_purchased) AS total_items_sold,
    ROUND(SUM(items_purchased * price_usd), 2) AS total_revenue,
    ROUND(
        SUM(
            (items_purchased * price_usd) -
            (items_purchased * cogs_usd)
        ), 2
    ) AS total_profit
FROM orders_data;

-- Unique customers
SELECT
    COUNT(DISTINCT user_id) AS unique_customers
FROM orders_data;


-- ============================================================
-- 03. PRODUCT ANALYSIS
-- ============================================================

-- Top 5 products by revenue
SELECT
    primary_product_id AS product_id,
    ROUND(SUM(items_purchased * price_usd), 2) AS total_revenue
FROM orders_data
GROUP BY primary_product_id
ORDER BY total_revenue DESC
LIMIT 5;

-- Top 5 products by profit
SELECT
    primary_product_id AS product_id,
    ROUND(
        SUM(
            (items_purchased * price_usd) -
            (items_purchased * cogs_usd)
        ), 2
    ) AS total_profit
FROM orders_data
GROUP BY primary_product_id
ORDER BY total_profit DESC
LIMIT 5;
