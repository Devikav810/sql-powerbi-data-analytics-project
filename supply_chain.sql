public.supply_chainCREATE TABLE supply_chain (
    "Product type" VARCHAR(50),
    "SKU" VARCHAR(50),
    "Price" NUMERIC(10,2),
    "Availability" INT,
    "Number of products sold" INT,
    "Revenue generated" NUMERIC(12,2),
    "Customer demographics" VARCHAR(50),
    "Stock levels" INT,
    "Lead times" INT,
    "Order quantities" INT,
    "Shipping times" INT,
    "Shipping carriers" VARCHAR(50),
    "Shipping costs" NUMERIC(10,2),
    "Supplier name" VARCHAR(100),
    "Location" VARCHAR(100),
    "Lead time" INT,
    "Production volumes" INT,
    "Manufacturing lead time" INT,
    "Manufacturing costs" NUMERIC(10,2),
    "Inspection results" VARCHAR(50),
    "Defect rates" NUMERIC(10,2),
    "Transportation modes" VARCHAR(50),
    "Routes" VARCHAR(50),
    "Costs" NUMERIC(12,2)
);
SELECT COUNT(*)
FROM supply_chain;
SELECT* FROM supply_chain LIMIT 10;
--null vlues
SELECT COUNT(*) AS total_rows,COUNT(*) FILTER (WHERE "Product type" IS NULL) AS product_type_null,COUNT(*) FILTER (WHERE "SKU" IS NULL) AS sku_null,
COUNT(*) FILTER (WHERE "Price" IS NULL) AS price_null,COUNT(*) FILTER (WHERE "Revenue generated" IS NULL) AS revenue_null,COUNT(*) FILTER (WHERE "Stock levels" IS NULL) AS stock_null,COUNT(*) FILTER (WHERE "Supplier name" IS NULL) AS supplier_null
FROM supply_chain;
-- duplictae
SELECT
    "SKU", COUNT(*) AS duplicate_count
FROM supply_chain
GROUP BY "SKU"
HAVING COUNT(*) > 1;
--basics
SELECT sum("Revenue generated") AS total_revenue FROM supply_chain;
SELECT sum( "Number of products sold" )AS total_product_sold FROM supply_chain;
SELECT
    AVG("Price") AS average_price
FROM supply_chain;
SELECT
    AVG("Defect rates") AS average_defect_rate
FROM supply_chain;

SELECT
    "Product type",
    SUM("Revenue generated") AS total_revenue
FROM supply_chain
GROUP BY "Product type"
ORDER BY total_revenue DESC;
SELECT
    "Product type",
    SUM("Number of products sold") AS total_sold
FROM supply_chain
GROUP BY "Product type"
ORDER BY total_sold DESC;
SELECT
    "Product type",
    ROUND(AVG("Price"), 2) AS average_price
FROM supply_chain
GROUP BY "Product type"
ORDER BY average_price DESC;
SELECT
    "Supplier name",
    SUM("Revenue generated") AS total_revenue
FROM supply_chain
GROUP BY "Supplier name"
ORDER BY total_revenue DESC;
SELECT
    "Supplier name",
    SUM("Revenue generated") AS total_revenue
FROM supply_chain
GROUP BY "Supplier name"
ORDER BY total_revenue DESC;
SELECT
    "Location",
    SUM("Revenue generated") AS total_revenue,
    SUM("Number of products sold") AS total_products_sold
FROM supply_chain
GROUP BY "Location"
ORDER BY total_revenue DESC;
SELECT
    "Shipping carriers",
    SUM("Revenue generated") AS total_revenue
FROM supply_chain
GROUP BY "Shipping carriers"
ORDER BY total_revenue DESC;
SELECT
    "Shipping carriers",
    ROUND(AVG("Shipping costs"), 2) AS avg_shipping_cost
FROM supply_chain
GROUP BY "Shipping carriers"
ORDER BY avg_shipping_cost DESC;
SELECT
    "Shipping carriers",
    ROUND(AVG("Shipping times"), 2) AS avg_shipping_time
FROM supply_chain
GROUP BY "Shipping carriers"
ORDER BY avg_shipping_time;
SELECT
    "Transportation modes",
    COUNT(*) AS number_of_orders,
    ROUND(AVG("Shipping costs"), 2) AS avg_shipping_cost,
    ROUND(AVG("Shipping times"), 2) AS avg_shipping_time
FROM supply_chain
GROUP BY "Transportation modes"
ORDER BY number_of_orders DESC;

SELECT
    "SKU",
    "Product type",
    "Stock levels"
FROM supply_chain
WHERE "Stock levels" < 20
ORDER BY "Stock levels";
SELECT
    "SKU",
    "Product type",
    "Stock levels"
FROM supply_chain
ORDER BY "Stock levels" DESC
LIMIT 10;

SELECT
    "SKU",
    "Product type",
    "Stock levels",
    CASE
        WHEN "Stock levels" < 20 THEN 'Low Stock'
        WHEN "Stock levels" BETWEEN 20 AND 50 THEN 'Medium Stock'
        ELSE 'High Stock'
    END AS stock_status
FROM supply_chain;

SELECT
    "SKU",
    "Product type",
    "Defect rates"
FROM supply_chain
WHERE "Defect rates" > 3
ORDER BY "Defect rates" DESC;

SELECT
    "Inspection results",
    COUNT(*) AS product_count
FROM supply_chain
GROUP BY "Inspection results"
ORDER BY product_count DESC;

WITH avg_revenue AS (
    SELECT AVG("Revenue generated") AS average_revenue
    FROM supply_chain
)
SELECT
    "SKU",
    "Product type",
    "Revenue generated"
FROM supply_chain
WHERE "Revenue generated" >
      (SELECT average_revenue FROM avg_revenue)
ORDER BY "Revenue generated" DESC;

SELECT
    "SKU",
    "Product type",
    "Revenue generated",
    RANK() OVER (
        ORDER BY "Revenue generated" DESC
    ) AS revenue_rank
FROM supply_chain;

WITH ranked_products AS (
    SELECT
        "SKU",
        "Product type",
        "Revenue generated",
        RANK() OVER (
            ORDER BY "Revenue generated" DESC
        ) AS revenue_rank
    FROM supply_chain
)
SELECT *
FROM ranked_products
WHERE revenue_rank <= 10;

CREATE VIEW vw_supply_chain_analysis AS
SELECT
    "Product type",
    "SKU",
    "Price",
    "Availability",
    "Number of products sold",
    "Revenue generated",
    "Customer demographics",
    "Stock levels",
    "Lead times",
    "Order quantities",
    "Shipping times",
    "Shipping carriers",
    "Shipping costs",
    "Supplier name",
    "Location",
    "Lead time",
    "Production volumes",
    "Manufacturing lead time",
    "Manufacturing costs",
    "Inspection results",
    "Defect rates",
    "Transportation modes",
    "Routes",
    "Costs",

    CASE
        WHEN "Stock levels" < 20 THEN 'Low Stock'
        WHEN "Stock levels" BETWEEN 20 AND 50 THEN 'Medium Stock'
        ELSE 'High Stock'
    END AS stock_status,

    CASE
        WHEN "Defect rates" > 3 THEN 'High Defect'
        WHEN "Defect rates" BETWEEN 1 AND 3 THEN 'Medium Defect'
        ELSE 'Low Defect'
    END AS defect_status

FROM supply_chain;
SELECT *
FROM vw_supply_chain_analysis
LIMIT 10;
