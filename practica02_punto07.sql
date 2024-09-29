
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
