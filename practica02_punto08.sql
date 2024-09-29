
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
