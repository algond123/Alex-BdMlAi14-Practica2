
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
