----------
--Punto 3

DROP TABLE IF EXISTS `keepcoding.ivr_detail`;

CREATE TABLE `keepcoding.ivr_detail` AS
SELECT 
    c.ivr_id AS calls_ivr_id,
    c.phone_number AS calls_phone_number,
    c.ivr_result AS calls_ivr_result,
    c.vdn_label AS calls_vdn_label,
    c.start_date AS calls_start_date,
    FORMAT_TIMESTAMP('%Y%m%d', c.start_date) AS calls_start_date_id,
    c.end_date AS calls_end_date,
    FORMAT_TIMESTAMP('%Y%m%d', c.end_date) AS calls_end_date_id,
    c.total_duration AS calls_total_duration,
    c.customer_segment AS calls_customer_segment,
    c.ivr_language AS calls_ivr_language,
    m.module_sequece AS calls_steps_module,
    m.module_name AS calls_module_aggregation,
    m.module_sequece AS module_sequence,
    m.module_name AS module_name,
    m.module_duration AS module_duration,
    m.module_result AS module_result,
    s.step_sequence AS step_sequence,
    s.step_name AS step_name,
    s.step_result AS step_result,
    s.step_description_error AS step_description_error,
    s.document_type AS document_type,
    s.document_identification AS document_identification,
    s.customer_phone AS customer_phone,
    s.billing_account_id AS billing_account_id
FROM 
    `keepcoding.ivr_calls` c
JOIN 
    `keepcoding.ivr_modules` m 
ON 
    c.ivr_id = m.ivr_id
JOIN 
    `keepcoding.ivr_steps` s 
ON 
    m.ivr_id = s.ivr_id 
    AND m.module_sequece = s.module_sequece
ORDER BY calls_ivr_id;

SELECT *
FROM `keepcoding.ivr_detail`
ORDER BY calls_ivr_id ASC;

----------
--Punto 4

--ALTER TABLE `keepcoding.ivr_detail`
--DROP COLUMN vdn_aggregation;

ALTER TABLE `keepcoding.ivr_detail`
ADD COLUMN vdn_aggregation STRING;

UPDATE `keepcoding.ivr_detail` d
SET d.vdn_aggregation = CASE 
        WHEN STARTS_WITH(d.calls_vdn_label, 'ATC') THEN 'FRONT'
        WHEN STARTS_WITH(d.calls_vdn_label, 'TECH') THEN 'TECH'
        WHEN d.calls_vdn_label = 'ABSORPTION' THEN 'ABSORPTION'
        ELSE 'RESTO'
    END
WHERE TRUE;

SELECT calls_ivr_id, calls_vdn_label, vdn_aggregation
FROM `keepcoding.ivr_detail`
ORDER BY calls_ivr_id ASC;

----------
--Punto 5

--ALTER TABLE `keepcoding.ivr_detail`
--DROP COLUMN document_type_2,
--DROP COLUMN document_identification_2;

ALTER TABLE `keepcoding.ivr_detail`
ADD COLUMN document_type_2 STRING,
ADD COLUMN document_identification_2 STRING;

UPDATE `keepcoding.ivr_detail` d
SET 
    d.document_type_2 = (
        SELECT MAX(d2.document_type)
        FROM `keepcoding.ivr_detail` d2
        WHERE d2.calls_ivr_id = d.calls_ivr_id
          AND d2.document_type IS NOT NULL
          AND d2.document_type != 'UNKNOWN'
    ),
    d.document_identification_2 = (
        SELECT MAX(d2.document_identification)
        FROM `keepcoding.ivr_detail` d2
        WHERE d2.calls_ivr_id = d.calls_ivr_id
          AND d2.document_identification IS NOT NULL
          AND d2.document_identification != 'UNKNOWN'
    )
WHERE TRUE;

SELECT calls_ivr_id, document_type, document_identification, document_type_2, document_identification_2
FROM `keepcoding.ivr_detail`
ORDER BY calls_ivr_id ASC;

----------
--Punto 6

--ALTER TABLE `keepcoding.ivr_detail`
--DROP COLUMN customer_phone_2;

ALTER TABLE `keepcoding.ivr_detail`
ADD COLUMN customer_phone_2 STRING;

UPDATE `keepcoding.ivr_detail` d
SET 
    d.customer_phone_2 = (
        SELECT MAX(d2.customer_phone)
        FROM `keepcoding.ivr_detail` d2
        WHERE d2.calls_ivr_id = d.calls_ivr_id
          AND d2.customer_phone IS NOT NULL
          AND d2.customer_phone != 'UNKNOWN'
    )
WHERE TRUE;

SELECT calls_ivr_id, customer_phone, customer_phone_2
FROM `keepcoding.ivr_detail`
ORDER BY calls_ivr_id ASC;

----------
--Punto 7

--ALTER TABLE `keepcoding.ivr_detail`
--DROP COLUMN billing_account_id_2;

ALTER TABLE `keepcoding.ivr_detail`
ADD COLUMN billing_account_id_2 STRING;

UPDATE `keepcoding.ivr_detail` d
SET 
    d.billing_account_id_2 = (
        SELECT MAX(d2.billing_account_id)
        FROM `keepcoding.ivr_detail` d2
        WHERE d2.calls_ivr_id = d.calls_ivr_id
          AND d2.billing_account_id IS NOT NULL
          AND d2.billing_account_id != 'UNKNOWN'
    )
WHERE TRUE;

SELECT calls_ivr_id, billing_account_id, billing_account_id_2
FROM `keepcoding.ivr_detail`
ORDER BY calls_ivr_id ASC;

----------
--Punto 8

--ALTER TABLE `keepcoding.ivr_detail`
--DROP COLUMN masiva_lg;

ALTER TABLE `keepcoding.ivr_detail`
ADD COLUMN masiva_lg INT64;

UPDATE `keepcoding.ivr_detail` d
SET d.masiva_lg = CASE 
    WHEN EXISTS (
        SELECT 1
        FROM `keepcoding.ivr_detail` d2
        WHERE d2.calls_ivr_id = d.calls_ivr_id
            AND d2.module_name = 'AVERIA_MASIVA'
    ) THEN 1
    ELSE 0
    END
WHERE TRUE;

SELECT calls_ivr_id, module_name, masiva_lg
FROM `keepcoding.ivr_detail`
ORDER BY calls_ivr_id ASC;

----------
--Punto 9

--ALTER TABLE `keepcoding.ivr_detail`
--DROP COLUMN info_by_phone_lg;

ALTER TABLE `keepcoding.ivr_detail`
ADD COLUMN info_by_phone_lg INT64;

UPDATE `keepcoding.ivr_detail` d
SET d.info_by_phone_lg = CASE 
    WHEN EXISTS (
        SELECT 1
        FROM `keepcoding.ivr_detail` d2
        WHERE d2.calls_ivr_id = d.calls_ivr_id
            AND d2.step_name = 'CUSTOMERINFOBYPHONE.TX'
            AND d2.step_result = 'OK'
    ) THEN 1
    ELSE 0
    END
WHERE TRUE;

SELECT calls_ivr_id, step_name, step_result, info_by_phone_lg
FROM `keepcoding.ivr_detail`
WHERE info_by_phone_lg = 0
ORDER BY calls_ivr_id ASC;

----------
--Punto 10

--ALTER TABLE `keepcoding.ivr_detail`
--DROP COLUMN info_by_dni_lg;

ALTER TABLE `keepcoding.ivr_detail`
ADD COLUMN info_by_dni_lg INT64;

UPDATE `keepcoding.ivr_detail` d
SET d.info_by_dni_lg = CASE 
        WHEN EXISTS (
            SELECT 1
            FROM `keepcoding.ivr_detail` d2
            WHERE d2.calls_ivr_id = d.calls_ivr_id
            AND d2.step_name = 'CUSTOMERINFOBYDNI.TX'
            AND d2.step_result = 'OK'
        ) THEN 1
        ELSE 0
    END
WHERE TRUE;

SELECT calls_ivr_id, step_name, step_result, info_by_dni_lg
FROM `keepcoding.ivr_detail`
ORDER BY calls_ivr_id ASC;

----------
--Punto 11

--ALTER TABLE `keepcoding.ivr_detail`
--DROP COLUMN repeated_phone_24H_aux,
--DROP COLUMN cause_recall_phone_24H_aux,
--DROP COLUMN repeated_phone_24H,
--DROP COLUMN cause_recall_phone_24H;

ALTER TABLE `keepcoding.ivr_detail`
ADD COLUMN repeated_phone_24H_aux INT64,
ADD COLUMN cause_recall_phone_24H_aux INT64,
ADD COLUMN repeated_phone_24H INT64,
ADD COLUMN cause_recall_phone_24H INT64;

UPDATE `keepcoding.ivr_detail` d
SET 
    d.repeated_phone_24H_aux = CASE 
            WHEN EXISTS (
                SELECT 1
                FROM `keepcoding.ivr_detail` d2
                WHERE d2.calls_phone_number = d.calls_phone_number
                    AND TIMESTAMP_DIFF(d2.calls_start_date, d.calls_start_date, HOUR) <= 24
                    AND d2.calls_start_date != d.calls_start_date
            ) THEN 1
            ELSE 0
        END,
    d.cause_recall_phone_24H_aux = CASE 
            WHEN EXISTS (
                SELECT 1
                FROM `keepcoding.ivr_detail` d2
                WHERE d2.calls_phone_number = d.calls_phone_number
                    AND TIMESTAMP_DIFF(d2.calls_start_date, d.calls_start_date, HOUR) >= 24
                    AND d2.calls_start_date != d.calls_start_date
            ) THEN 1
            ELSE 0
        END
WHERE TRUE;

UPDATE `keepcoding.ivr_detail` d
SET d.repeated_phone_24H = (
    SELECT MAX(d2.repeated_phone_24H_aux)
    FROM `keepcoding.ivr_detail` d2
    WHERE d2.calls_phone_number = d.calls_phone_number
),
d.cause_recall_phone_24H = (
    SELECT MAX(d2.cause_recall_phone_24H_aux)
    FROM `keepcoding.ivr_detail` d2
    WHERE d2.calls_phone_number = d.calls_phone_number
)
WHERE TRUE;

WITH unique_calls AS (
    SELECT 
        calls_ivr_id, 
        calls_phone_number, 
        calls_start_date, 
        repeated_phone_24H_aux, 
        cause_recall_phone_24H_aux,
        repeated_phone_24H, 
        cause_recall_phone_24H,
        ROW_NUMBER() OVER (PARTITION BY calls_phone_number, calls_start_date) AS row_num
    FROM `keepcoding.ivr_detail`
)
SELECT 
    calls_ivr_id, 
    calls_phone_number, 
    calls_start_date, 
    repeated_phone_24H_aux, 
    cause_recall_phone_24H_aux,
    repeated_phone_24H, 
    cause_recall_phone_24H
FROM unique_calls
WHERE row_num = 1
ORDER BY calls_phone_number ASC, calls_start_date ASC;

----------
--Punto 12

DROP TABLE IF EXISTS `keepcoding.ivr_summary`;

CREATE TABLE `keepcoding.ivr_summary` AS
SELECT
    d.calls_ivr_id AS ivr_id,
    MAX(d.calls_phone_number) AS phone_number,
    MAX(d.calls_ivr_result) AS ivr_result,
    MAX(d.vdn_aggregation) AS vdn_aggregation,
    MAX(d.calls_start_date) AS start_date,
    MAX(d.calls_end_date) AS end_date,
    MAX(d.calls_total_duration) AS total_duration,
    MAX(d.calls_customer_segment) AS customer_segment,
    MAX(d.calls_ivr_language) AS ivr_language,
    COUNT(DISTINCT d.module_name) AS steps_module,
    STRING_AGG(DISTINCT d.module_name, ', ') AS module_aggregation,
    MAX(d.document_type_2) AS document_type,
    MAX(d.document_identification_2) AS document_identification,
    MAX(d.customer_phone_2) AS customer_phone,
    MAX(d.billing_account_id_2) AS billing_account_id,
    MAX(d.masiva_lg) AS masiva_lg,
    MAX(d.info_by_phone_lg) AS info_by_phone_lg,
    MAX(d.info_by_dni_lg) AS info_by_dni_lg,
    MAX(d.repeated_phone_24H) AS repeated_phone_24H,
    MAX(d.cause_recall_phone_24H) AS cause_recall_phone_24H
FROM
    `keepcoding.ivr_detail` d
GROUP BY
    d.calls_ivr_id
ORDER BY
    d.calls_ivr_id ASC;

SELECT *
FROM `keepcoding.ivr_summary`
ORDER BY ivr_id ASC;

----------
--Punto 13

CREATE OR REPLACE FUNCTION `keepcoding.clean_integer`(input_value INT64)
RETURNS INT64
AS (
  IFNULL(input_value, -999999)
);

WITH sample_data AS (
  SELECT NULL AS test_value UNION ALL
  SELECT 123 AS test_value UNION ALL
  SELECT -456 AS test_value UNION ALL
  SELECT 0 AS test_value
)
SELECT 
  test_value, 
  `keepcoding.clean_integer`(test_value) AS cleaned_value
FROM sample_data;



