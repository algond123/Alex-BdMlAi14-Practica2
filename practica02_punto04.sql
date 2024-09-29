
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
