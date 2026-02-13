-- Kimia Farma Sales Performance Analysis
-- Final Task Project Based Internship

CREATE OR REPLACE TABLE `rakamin-kf-analytics-487210.kimia_farma.kf_analysis` AS

WITH base_calculation AS (
    SELECT
        ft.transaction_id,
        ft.date,
        ft.branch_id,
        kc.branch_name,
        kc.kota,
        kc.provinsi,
        kc.rating AS rating_cabang,
        ft.customer_name,
        ft.product_id,
        p.product_name,
        ft.price AS actual_price,
        ft.discount_percentage,
        ft.rating AS rating_transaksi,

        -- Gross Profit Percentage
        CASE
            WHEN ft.price <= 50000 THEN 0.10
            WHEN ft.price <= 100000 THEN 0.15
            WHEN ft.price <= 300000 THEN 0.20
            WHEN ft.price <= 500000 THEN 0.25
            ELSE 0.30
        END AS persentase_gross_laba

    FROM `rakamin-kf-analytics-487210.kimia_farma.kf_final_transaction` ft
    LEFT JOIN `rakamin-kf-analytics-487210.kimia_farma.kf_product` p
        ON ft.product_id = p.product_id
    LEFT JOIN `rakamin-kf-analytics-487210.kimia_farma.kf_kantor_cabang` kc
        ON ft.branch_id = kc.branch_id
)

SELECT
    *,
    
    -- Nett Sales
    (actual_price - (actual_price * discount_percentage)) AS nett_sales,

    -- Nett Profit
    (
        (actual_price - (actual_price * discount_percentage))
        * persentase_gross_laba
    ) AS nett_profit

FROM base_calculation;
