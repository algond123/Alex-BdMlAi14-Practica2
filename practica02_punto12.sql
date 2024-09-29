
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
