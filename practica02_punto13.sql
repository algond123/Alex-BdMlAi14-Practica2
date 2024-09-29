
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
