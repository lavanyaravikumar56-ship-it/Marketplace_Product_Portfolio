create database project;
use project;
select * from CUSTOMER;
select * from products;



SELECT
    order_id,
    COUNT(*) AS row_count
FROM orders_dirty
GROUP BY order_id
HAVING COUNT(*) > 1
ORDER BY row_count DESC;

DESCRIBE orders_dirty;

ALTER TABLE orders_dirty
CHANGE COLUMN `ï»¿order_id` order_id TEXT;

DESCRIBE orders_dirty;

SELECT *
FROM orders_dirty
LIMIT 1;

SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = DATABASE()
  AND TABLE_NAME = 'orders_dirty';
  
SELECT
    order_id,
    COUNT(*) AS row_count
FROM orders_dirty
GROUP BY order_id
HAVING COUNT(*) > 1
ORDER BY row_count DESC
LIMIT 10;

SELECT
    order_id,
    COUNT(*) AS row_count
FROM orders_dirty
GROUP BY order_id
HAVING COUNT(*) > 1;

SELECT COUNT(*) AS missing_records
FROM orders_dirty
WHERE order_id IS NULL
   OR customer_id IS NULL
   OR sku_id IS NULL
   OR gmv IS NULL;
   
SELECT
    o.order_id,
    o.customer_id,
    c.city,
    c.segment
FROM orders_dirty o
LEFT JOIN customers c
    ON o.customer_id = c.customer_id
LIMIT 10;

SHOW TABLES;

SELECT
    o.order_id,
    o.customer_id,
    c.city,
    c.segment
FROM orders_dirty o
LEFT JOIN customer c
    ON o.customer_id = c.customer_id
LIMIT 10;

DESCRIBE customer;

SELECT
    c.city,
    c.segment
FROM customer c
LIMIT 10;

ALTER TABLE customer
CHANGE COLUMN `ï»¿customer_id` customer_id TEXT;

DESCRIBE customer;

SELECT
    o.order_id,
    o.customer_id,
    c.city,
    c.segment
FROM orders_dirty o
LEFT JOIN customer c
    ON o.customer_id = c.customer_id
LIMIT 10;

DESCRIBE products;

ALTER TABLE products
CHANGE COLUMN `ï»¿sku_id` sku_id TEXT;

DESCRIBE products;

SELECT
    o.order_id,
    o.customer_id,
    c.city,
    c.segment,
    p.sku_id,
    p.category,
    p.subcategory
FROM orders_dirty o
LEFT JOIN customer c
    ON o.customer_id = c.customer_id
LEFT JOIN products p
    ON o.sku_id = p.sku_id
LIMIT 10;

DESCRIBE delivery_cx;

SELECT
    order_id,
    MAX(delay_days) AS delay_days
FROM delivery_cx
GROUP BY order_id
LIMIT 10;

WITH delivery_summary AS (
    SELECT
        order_id,
        MAX(delay_days) AS delay_days
    FROM delivery_cx
    GROUP BY order_id
)
SELECT
    o.order_id,
    o.customer_id,
    c.city,
    c.segment,
    p.sku_id,
    p.category,
    p.subcategory,
    d.delay_days
FROM orders_dirty o
LEFT JOIN customer c
    ON o.customer_id = c.customer_id
LEFT JOIN products p
    ON o.sku_id = p.sku_id
LEFT JOIN delivery_summary d
    ON o.order_id = d.order_id
LIMIT 10;

DESCRIBE support_tickets;

SELECT
    order_id,
    COUNT(*) AS ticket_count,
    AVG(csat) AS avg_csat
FROM support_tickets
GROUP BY order_id
LIMIT 10;

WITH delivery_summary AS (
    SELECT
        order_id,
        MAX(delay_days) AS delay_days
    FROM delivery_cx
    GROUP BY order_id
),
ticket_summary AS (
    SELECT
        order_id,
        COUNT(*) AS ticket_count,
        AVG(csat) AS avg_csat
    FROM support_tickets
    GROUP BY order_id
)
SELECT
    o.order_id,
    o.customer_id,
    c.city,
    c.segment,
    p.sku_id,
    p.category,
    p.subcategory,
    d.delay_days,
    COALESCE(t.ticket_count, 0) AS ticket_count,
    t.avg_csat
FROM orders_dirty o
LEFT JOIN customer c
    ON o.customer_id = c.customer_id
LEFT JOIN products p
    ON o.sku_id = p.sku_id
LEFT JOIN delivery_summary d
    ON o.order_id = d.order_id
LEFT JOIN ticket_summary t
    ON o.order_id = t.order_id
LIMIT 10;

WITH customer_orders AS (
    SELECT
        customer_id,
        COUNT(*) AS total_orders,
        SUM(CAST(REPLACE(gmv, '₹', '') AS DECIMAL(12,2))) AS total_gmv
    FROM orders_dirty
    GROUP BY customer_id
)
SELECT *
FROM customer_orders
LIMIT 10;

SELECT gmv
FROM orders_dirty
LIMIT 10;

SELECT
    gmv,
    CAST(
        REPLACE(
            REPLACE(gmv, 'â‚¹', ''),
            ',', ''
        ) AS DECIMAL(12,2)
    ) AS gmv_number
FROM orders_dirty
LIMIT 10;

WITH customer_orders AS (
    SELECT
        customer_id,
        COUNT(*) AS total_orders,
        SUM(
            CAST(
                REPLACE(REPLACE(gmv, 'â‚¹', ''), ',', '')
                AS DECIMAL(12,2)
            )
        ) AS total_gmv
    FROM orders_dirty
    GROUP BY customer_id
)
SELECT *
FROM customer_orders
LIMIT 10;

WITH customer_orders AS (
    SELECT
        customer_id,
        COUNT(*) AS total_orders,
        SUM(
            CAST(
                REPLACE(REPLACE(gmv, 'â‚¹', ''), ',', '')
                AS DECIMAL(12,2)
            )
        ) AS total_gmv
    FROM orders_dirty
    GROUP BY customer_id
)
SELECT
    c.customer_id,
    c.city,
    c.segment,
    o.total_orders,
    o.total_gmv
FROM customer c
LEFT JOIN customer_orders o
    ON c.customer_id = o.customer_id
LIMIT 10;

WITH product_sales AS (
    SELECT
        sku_id,
        category,
        SUM(
            CAST(
                REPLACE(REPLACE(gmv, 'â‚¹', ''), ',', '')
                AS DECIMAL(12,2)
            )
        ) AS total_gmv
    FROM orders_dirty
    GROUP BY sku_id, category
)
SELECT
    sku_id,
    category,
    total_gmv,
    RANK() OVER (ORDER BY total_gmv DESC) AS gmv_rank
FROM product_sales
ORDER BY gmv_rank
LIMIT 10;

WITH product_sales AS (
    SELECT
        sku_id,
        category,
        SUM(
            CAST(
                REPLACE(REPLACE(gmv, 'â‚¹', ''), ',', '')
                AS DECIMAL(12,2)
            )
        ) AS total_gmv
    FROM orders_dirty
    GROUP BY sku_id, category
)
SELECT
    sku_id,
    category,
    total_gmv,
    RANK() OVER (
        PARTITION BY category
        ORDER BY total_gmv DESC
    ) AS category_rank
FROM product_sales
ORDER BY category, category_rank
LIMIT 20;

WITH category_metrics AS (
    SELECT
        category,
        COUNT(*) AS orders,
        COUNT(DISTINCT sku_id) AS unique_skus,
        SUM(
            CAST(
                REPLACE(REPLACE(gmv, 'â‚¹', ''), ',', '')
                AS DECIMAL(12,2)
            )
        ) AS total_gmv,
        AVG(rating) AS avg_rating
    FROM orders_dirty
    GROUP BY category
)
SELECT
    category,
    orders,
    unique_skus,
    total_gmv,
    avg_rating,
    RANK() OVER (ORDER BY total_gmv DESC) AS category_rank
FROM category_metrics
ORDER BY category_rank;

WITH customer_orders AS (
    SELECT
        customer_id,
        COUNT(*) AS total_orders,
        SUM(
            CAST(
                REPLACE(REPLACE(gmv, 'â‚¹', ''), ',', '')
                AS DECIMAL(12,2)
            )
        ) AS total_gmv
    FROM orders_dirty
    GROUP BY customer_id
),
customer_tickets AS (
    SELECT
        customer_id,
        COUNT(*) AS ticket_count,
        AVG(csat) AS avg_csat
    FROM support_tickets
    GROUP BY customer_id
)
SELECT
    c.segment,
    COUNT(*) AS customers,
    SUM(COALESCE(o.total_orders, 0)) AS total_orders,
    SUM(COALESCE(o.total_gmv, 0)) AS total_gmv,
    SUM(COALESCE(t.ticket_count, 0)) AS tickets,
    AVG(t.avg_csat) AS avg_csat
FROM customer c
LEFT JOIN customer_orders o
    ON c.customer_id = o.customer_id
LEFT JOIN customer_tickets t
    ON c.customer_id = t.customer_id
GROUP BY c.segment
ORDER BY total_gmv DESC;

WITH search_metrics AS (
    SELECT
        search_term,
        COUNT(*) AS searches,
        SUM(zero_result_flag) AS zero_result_searches,
        AVG(zero_result_flag) AS zero_result_rate
    FROM search_events
    GROUP BY search_term
)
SELECT
    search_term,
    searches,
    zero_result_searches,
    zero_result_rate,
    RANK() OVER (
        ORDER BY zero_result_searches DESC
    ) AS opportunity_rank
FROM search_metrics
ORDER BY opportunity_rank
LIMIT 10;

WITH city_metrics AS (
    SELECT
        city,
        SUM(orders) AS total_orders,
        SUM(gmv) AS total_gmv,
        SUM(contribution_margin) AS total_contribution_margin,
        AVG(delivery_success_pct) AS avg_delivery_success,
        AVG(repeat_rate_pct) AS avg_repeat_rate
    FROM city_economics
    GROUP BY city
)
SELECT
    city,
    total_orders,
    total_gmv,
    total_contribution_margin,
    avg_delivery_success,
    avg_repeat_rate,
    RANK() OVER (ORDER BY total_gmv DESC) AS gmv_rank
FROM city_metrics
ORDER BY gmv_rank;

SELECT
    city,
    gmv,
    contribution_margin
FROM city_economics
LIMIT 10;

WITH city_metrics AS (
    SELECT
        city,
        SUM(orders) AS total_orders,
        SUM(
            CAST(
                REPLACE(REPLACE(gmv, 'â‚¹', ''), ',', '')
                AS DECIMAL(15,2)
            )
        ) AS total_gmv,
        SUM(
            CAST(
                REPLACE(REPLACE(contribution_margin, 'â‚¹', ''), ',', '')
                AS DECIMAL(15,2)
            )
        ) AS total_contribution_margin,
        AVG(delivery_success_pct) AS avg_delivery_success,
        AVG(repeat_rate_pct) AS avg_repeat_rate
    FROM city_economics
    GROUP BY city
)
SELECT
    city,
    total_orders,
    total_gmv,
    total_contribution_margin,
    avg_delivery_success,
    avg_repeat_rate,
    RANK() OVER (ORDER BY total_gmv DESC) AS gmv_rank
FROM city_metrics
ORDER BY gmv_rank;

WITH order_metrics AS (
    SELECT
        COUNT(*) AS total_orders,
        SUM(
            CAST(
                REPLACE(REPLACE(gmv, 'â‚¹', ''), ',', '')
                AS DECIMAL(15,2)
            )
        ) AS total_gmv,
        AVG(rating) AS avg_rating
    FROM orders_dirty
),
delivery_metrics AS (
    SELECT
        COUNT(*) AS delivery_records,
        SUM(CASE WHEN delay_days > 0 THEN 1 ELSE 0 END) AS delayed_deliveries
    FROM delivery_cx
),
search_metrics AS (
    SELECT
        COUNT(*) AS total_searches,
        SUM(zero_result_flag) AS zero_result_searches
    FROM search_events
),
ticket_metrics AS (
    SELECT
        COUNT(*) AS total_tickets,
        AVG(csat) AS avg_csat
    FROM support_tickets
)
SELECT
    o.total_orders,
    o.total_gmv,
    o.avg_rating,
    d.delivery_records,
    d.delayed_deliveries,
    d.delayed_deliveries * 1.0 / NULLIF(d.delivery_records, 0) AS delayed_rate,
    s.total_searches,
    s.zero_result_searches,
    s.zero_result_searches * 1.0 / NULLIF(s.total_searches, 0) AS zero_result_rate,
    t.total_tickets,
    t.avg_csat
FROM order_metrics o
CROSS JOIN delivery_metrics d
CROSS JOIN search_metrics s
CROSS JOIN ticket_metrics t;

SELECT
    c.customer_id,
    c.source,
    COUNT(DISTINCT s.session_id) AS sessions,
    COUNT(DISTINCT o.order_id) AS orders,
    SUM(o.gmv) AS total_gmv,
    AVG(o.margin) AS avg_margin,
    AVG(r.active) AS retention_rate,
    COUNT(DISTINCT p.promo_id) AS promo_uses
FROM Customers c
LEFT JOIN Sessions s
    ON c.customer_id = s.customer_id
LEFT JOIN Orders o
    ON c.customer_id = o.customer_id
LEFT JOIN Retention r
    ON c.customer_id = r.customer_id
LEFT JOIN Promo_Usage p
    ON c.customer_id = p.customer_id
GROUP BY
    c.customer_id,
    c.source
ORDER BY
    total_gmv DESC;
    
SHOW TABLES;

DESCRIBE customer;
DESCRIBE orders_dirty;
DESCRIBE delivery_cx;
DESCRIBE products;
DESCRIBE support_tickets;
DESCRIBE search_events;
DESCRIBE city_economics;
DESCRIBE experiments;
DESCRIBE experiments;
SHOW COLUMNS FROM experiments;

SELECT
    c.customer_id,
    c.city,
    c.segment,
    c.acquisition_channel,
    o.order_id,
    o.sku_id,
    p.category,
    p.subcategory,
    o.gmv,
    o.rating,
    d.actual_days,
    d.delay_days,
    d.delivery_status,
    s.issue_type,
    s.csat
FROM customer c
JOIN orders_dirty o
    ON c.customer_id = o.customer_id
JOIN products p
    ON o.sku_id = p.sku_id
LEFT JOIN delivery_cx d
    ON o.order_id = d.order_id
LEFT JOIN support_tickets s
    ON o.order_id = s.order_id
LIMIT 20;

WITH customer_orders AS (
    SELECT
        c.customer_id,
        c.city,
        c.segment,
        COUNT(DISTINCT o.order_id) AS total_orders,
        SUM(CAST(REPLACE(REPLACE(o.gmv, '₹', ''), ',', '') AS DECIMAL(12,2))) AS total_gmv
    FROM customer c
    JOIN orders_dirty o
        ON c.customer_id = o.customer_id
    GROUP BY
        c.customer_id,
        c.city,
        c.segment
)
SELECT *
FROM customer_orders
ORDER BY total_gmv DESC
LIMIT 20;

SELECT gmv
FROM orders_dirty
LIMIT 10;

WITH customer_orders AS (
    SELECT
        c.customer_id,
        c.city,
        c.segment,
        COUNT(DISTINCT o.order_id) AS total_orders,
        SUM(
            CAST(
                REPLACE(
                    REPLACE(o.gmv, 'â‚¹', ''),
                    ',',
                    ''
                ) AS DECIMAL(12,2)
            )
        ) AS total_gmv
    FROM customer c
    JOIN orders_dirty o
        ON c.customer_id = o.customer_id
    GROUP BY
        c.customer_id,
        c.city,
        c.segment
)
SELECT *
FROM customer_orders
ORDER BY total_gmv DESC
LIMIT 20;

WITH customer_orders AS (
    SELECT
        c.customer_id,
        c.city,
        c.segment,
        COUNT(DISTINCT o.order_id) AS total_orders,
        SUM(
            CAST(
                REPLACE(
                    REPLACE(o.gmv, 'â‚¹', ''),
                    ',',
                    ''
                ) AS DECIMAL(12,2)
            )
        ) AS total_gmv
    FROM customer c
    JOIN orders_dirty o
        ON c.customer_id = o.customer_id
    GROUP BY
        c.customer_id,
        c.city,
        c.segment
)
SELECT
    customer_id,
    city,
    segment,
    total_orders,
    total_gmv,
    RANK() OVER (ORDER BY total_gmv DESC) AS gmv_rank
FROM customer_orders
ORDER BY gmv_rank
LIMIT 20;

SELECT
    p.sku_id,
    p.category,
    p.subcategory,
    SUM(
        CAST(
            REPLACE(
                REPLACE(o.gmv, 'â‚¹', ''),
                ',',
                ''
            ) AS DECIMAL(12,2)
        )
    ) AS total_gmv,
    RANK() OVER (
        ORDER BY SUM(
            CAST(
                REPLACE(
                    REPLACE(o.gmv, 'â‚¹', ''),
                    ',',
                    ''
                ) AS DECIMAL(12,2)
            )
        ) DESC
    ) AS product_rank
FROM products p
JOIN orders_dirty o
    ON p.sku_id = o.sku_id
GROUP BY
    p.sku_id,
    p.category,
    p.subcategory
ORDER BY product_rank
LIMIT 20;

SELECT
    category,
    SUM(
        CAST(
            REPLACE(
                REPLACE(gmv, 'â‚¹', ''),
                ',',
                ''
            ) AS DECIMAL(12,2)
        )
    ) AS total_gmv,
    RANK() OVER (
        ORDER BY SUM(
            CAST(
                REPLACE(
                    REPLACE(gmv, 'â‚¹', ''),
                    ',',
                    ''
                ) AS DECIMAL(12,2)
            )
        ) DESC
    ) AS category_rank
FROM orders_dirty
GROUP BY category
ORDER BY category_rank;

SELECT
    city,
    SUM(
        CAST(
            REPLACE(
                REPLACE(gmv, 'â‚¹', ''),
                ',',
                ''
            ) AS DECIMAL(12,2)
        )
    ) AS total_gmv,
    RANK() OVER (
        ORDER BY SUM(
            CAST(
                REPLACE(
                    REPLACE(gmv, 'â‚¹', ''),
                    ',',
                    ''
                ) AS DECIMAL(12,2)
            )
        ) DESC
    ) AS city_rank
FROM city_economics
GROUP BY city
ORDER BY city_rank;

SELECT
    c.customer_id,
    c.city,
    c.segment,
    c.acquisition_channel,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(
        CAST(
            REPLACE(
                REPLACE(o.gmv, 'â‚¹', ''),
                ',',
                ''
            ) AS DECIMAL(12,2)
        )
    ) AS total_gmv,
    ROUND(
        SUM(
            CAST(
                REPLACE(
                    REPLACE(o.gmv, 'â‚¹', ''),
                    ',',
                    ''
                ) AS DECIMAL(12,2)
            )
        ) / COUNT(DISTINCT o.order_id),
        2
    ) AS average_order_value,
    ROUND(AVG(o.rating), 2) AS average_rating
FROM customer c
JOIN orders_dirty o
    ON c.customer_id = o.customer_id
GROUP BY
    c.customer_id,
    c.city,
    c.segment,
    c.acquisition_channel
ORDER BY total_gmv DESC
LIMIT 20;
SELECT
    d.delivery_status,
    COUNT(DISTINCT d.order_id) AS total_orders,
    ROUND(AVG(d.delay_days), 2) AS average_delay_days,
    ROUND(AVG(o.rating), 2) AS average_rating
FROM delivery_cx d
JOIN orders_dirty o
    ON d.order_id = o.order_id
GROUP BY d.delivery_status
ORDER BY average_rating;

SELECT
    search_term,
    COUNT(*) AS total_searches,
    SUM(zero_result_flag) AS zero_result_searches,
    ROUND(
        SUM(zero_result_flag) * 100.0 / COUNT(*),
        2
    ) AS zero_result_rate_pct
FROM search_events
GROUP BY search_term
ORDER BY zero_result_rate_pct DESC;

CREATE OR REPLACE VIEW executive_kpi AS
SELECT
    COUNT(DISTINCT o.order_id) AS total_orders,
    COUNT(DISTINCT o.customer_id) AS total_customers,
    SUM(
        CAST(
            REPLACE(
                REPLACE(o.gmv, 'â‚¹', ''),
                ',',
                ''
            ) AS DECIMAL(12,2)
        )
    ) AS total_gmv,
    ROUND(AVG(o.rating), 2) AS average_rating,
    ROUND(
        SUM(
            CAST(
                REPLACE(
                    REPLACE(o.gmv, 'â‚¹', ''),
                    ',',
                    ''
                ) AS DECIMAL(12,2)
            )
        ) / COUNT(DISTINCT o.order_id),
        2
    ) AS average_order_value
FROM orders_dirty o;
SELECT *
FROM executive_kpi;

SELECT
    'orders_dirty' AS table_name,
    COUNT(*) AS total_rows,
    SUM(order_id IS NULL OR order_id = '') AS missing_order_id,
    SUM(customer_id IS NULL OR customer_id = '') AS missing_customer_id,
    SUM(sku_id IS NULL OR sku_id = '') AS missing_sku_id,
    SUM(gmv IS NULL OR gmv = '') AS missing_gmv
FROM orders_dirty;



