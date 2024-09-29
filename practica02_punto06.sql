
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
