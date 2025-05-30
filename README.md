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

alter stage traffic refresh;

LIST  @traffic;


CREATE OR REPLACE TABLE DEMO.DEMO.NYCTRAFFIC (
  "ID" text,
  speed text,
  travel_time text,
  status text,
  data_as_of text,
  link_id text,
  link_points text,
  encoded_poly_line text,
  encoded_poly_line_lvls text,
  "OWNER" text,
  transcom_id text,
  borough text,
  link_name text,
  "TS" text,
  uuid text
);


  
  
describe table demo.demo.nyctraffic;

select * from nyctraffic;

CREATE OR REPLACE PROCEDURE insert_json_data(JSON_STRING STRING)
RETURNS STRING
LANGUAGE SQL
AS
$$
DECLARE
    result STRING;
BEGIN   
    INSERT INTO RAWNYCTRAFFICIMAGES (json_data)
    SELECT PARSE_JSON(:JSON_STRING);

    RETURN 'JSON data inserted successfully';
EXCEPTION   
WHEN OTHER THEN
    RETURN 'Error inserting JSON: ' || SQLSTATE || ' - ' || SQLERRM;
END;
$$;



CREATE OR REPLACE TABLE DEMO.DEMO.NYCTRAFFICIMAGES (
  videoid text,
  videoname text,
  videourl text,
  filename text,
  directionoftravel text,
  latitude text,
  longitude text,
  roadwayname text,
  url2 text,
  ending text,
  stagemessage text,
  stagestatus text,
  targetsize text,
  uuid text
);


CREATE OR REPLACE TABLE DEMO.DEMO.RAWNYCTRAFFICIMAGES 
(
    uuid text,
    filename text,
    json_data VARIANT
);


CREATE OR REPLACE PROCEDURE DEMO.DEMO.ANALYZETRAFFICIMAGE("IMAGE_NAME" STRING, "UUID" STRING)
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

   INSERT INTO DEMO.DEMO.RAWNYCTRAFFICIMAGES 
   (json_data, filename, uuid)
   SELECT PARSE_JSON(:result ) as json_data, :IMAGE_NAME, :UUID;
    
   RETURN result;
EXCEPTION
    WHEN OTHER THEN
        RETURN 'Error: ' || SQLSTATE || ' - '|| SQLERRM;   
END;
$$;

```

### Cortex AI SQL

````

SELECT SNOWFLAKE.CORTEX.COMPLETE('claude-3-5-sonnet',PROMPT('Compare these two traffic camera images {0} {1}',TO_FILE('@Traffic','NoLiveCamera.jpg'),
TO_FILE('@Traffic','cam.path.0a9f1346-5f4a-424c-bdac-3fd6c16e099920250529094328.jpg20250529115868.jpg')));


The first image shows an error message indicating "No live camera feed at this time" with an exclamation mark icon. The second image shows an active traffic camera view of an urban street scene, labeled as "Facing North" with a timestamp of Thu May 29 2025 11:32:50 AM. The active camera captures a typical city street with vehicles, buildings on both sides, trees lining the street, and what appears to be a bike lane or bus lane marked in red. The image quality is typical of traffic cameras, with a somewhat grainy, monochromatic appearance.


````



### Resources

* https://docs.snowflake.com/en/user-guide/snowflake-cortex/complete-multimodal
* https://docs.snowflake.com/en/sql-reference/functions/prompt



