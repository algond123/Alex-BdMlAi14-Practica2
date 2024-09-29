
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
