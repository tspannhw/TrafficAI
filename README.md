### TrafficAI

AI App for Traffic management in NYC with Apache NiFi, Cortex AI, Claude, LLM, Images, REST



### SQL

```

CREATE OR REPLACE PROCEDURE DEMO.DEMO.ANALYZETRAFFICIMAGE(IMAGE_NAME STRING)
RETURNS OBJECT
LANGUAGE SQL
EXECUTE AS OWNER
AS $$
DECLARE
  result VARIANT;
BEGIN
  ALTER STAGE TRAFFIC REFRESH; 
  
  SELECT SNOWFLAKE.CORTEX.COMPLETE('claude-3-5-sonnet', 
    'Analyze this traffic image and describe what you see. Respond in compact JSON format.',
    TO_FILE('@TRAFFIC', :IMAGE_NAME)) INTO :result;

   RETURN result;
END;
$$



CREATE OR REPLACE PROCEDURE count_vehicles_in_image(IMAGE_NAME STRING)
RETURNS OBJECT
LANGUAGE SQL
AS
$$
DECLARE
    result VARIANT;
BEGIN
-- Use claude-3-5-sonnet model for image analysis with structured output
ALTER STAGE TRAFFIC REFRESH; 

SELECT SNOWFLAKE.CORTEX.COMPLETE('claude-3-5-sonnet','Analyze this traffic image and count the number of vehicles. Return the result in JSON format with these fields: total_count (number), vehicle_types (array of strings with vehicle categories), confidence_level (string: high, medium, or low). Only include clearly visible vehicles.',TO_FILE('@Traffic', :IMAGE_NAME)) INTO :result;

RETURN result;

END;
$$
```
