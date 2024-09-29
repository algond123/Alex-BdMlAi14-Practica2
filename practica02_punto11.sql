
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
