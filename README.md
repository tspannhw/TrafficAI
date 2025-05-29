### TrafficAI

AI App for Traffic management in NYC with Apache NiFi, Cortex AI, Claude, LLM, Images, REST



### SQL

```

CREATE OR REPLACE PROCEDURE DEMO.DEMO.ANALYZETRAFFICIMAGE(IMAGE_NAME STRING)
RETURNS STRING
LANGUAGE SQL
EXECUTE AS OWNER
AS $$
DECLARE
  result STRING;
BEGIN
  ALTER STAGE TRAFFIC REFRESH; 
  
  SELECT SNOWFLAKE.CORTEX.COMPLETE('claude-3-5-sonnet', 
    'Analyze this traffic image and describe what you see. Respond in JSON format.',
    TO_FILE('@TRAFFIC', :IMAGE_NAME)) INTO :result;
  RETURN result;
END;
$$

```
