SELECT SYSTEM$CLUSTERING_INFORMATION('NYTRAFFIC');


WITH latest_forecast AS (
  SELECT
    time_init_utc,
    hour_utc,
    temperature_air_2m_f,
    humidity_specific_2m_gpkg,
    wind_speed_10m_mph,
    precipitation_in,
    pressure_mean_sea_level_mb
  FROM
    weatherforecastus
  WHERE
    city_name = 'New York'
  ORDER BY
    time_init_utc DESC,
    hour_utc DESC NULLS LAST
  LIMIT
    1
)
SELECT 
  time_init_utc AS forecast_time,
  hour_utc,
  temperature_air_2m_f AS temperature_f,
  humidity_specific_2m_gpkg AS humidity_gpkg,
  wind_speed_10m_mph AS wind_speed_mph,
  precipitation_in,
  pressure_mean_sea_level_mb AS pressure_mb
FROM
  latest_forecast;


SELECT *
  FROM SNOWFLAKE.ACCOUNT_USAGE.CORTEX_FUNCTIONS_USAGE_HISTORY
  WHERE START_TIME > '2025-03-17 09:00:00-08:00'
  ORDER BY START_TIME DESC;

  --- traffic

  SELECT SNOWFLAKE.CORTEX.COMPLETE('pixtral-large', 
'Return a count the number of distinct vehicles in this image.
Do not provide any other details. 
Do not provide any other words or commentary.',
TO_FILE('@IMAGE_ANALYSIS','2025_04_24/carling_traffic_east_lane_2025-04-24_15_00_15.png')) AS COUNT_VEHICLES



  SELECT SNOWFLAKE.CORTEX.COMPLETE('pixtral-large', 
'Return a count the number of distinct vehicles in this image.
Some of the vehicles may appear small. 
Pay particular attention to the vehicles in the upper part of the image.
Do not provide any other details. 
Do not provide any other words or commentary.',
TO_FILE('@IMAGE_ANALYSIS','2025_04_24/carling_traffic_east_lane_2025-04-24_15_00_15.png')) AS COUNT_VEHICLES


  SELECT SNOWFLAKE.CORTEX.COMPLETE('pixtral-large', 'This is an image of a freeway with lanes.
Categorize the intensity of the overall traffic in the lanes as one of either light or medium or heavy. 
Only reply with a single word.
Do not provide any other details. 
Do not provide any other words or commentary',TO_FILE('@IMAGE_ANALYSIS',
'2025_04_24/carling_traffic_east_lane_2025-04-24_15_00_15.png')) AS TRAFFIC_INTENSITY

SELECT SNOWFLAKE.CORTEX.COMPLETE('pixtral-large', 
'This is a photograph of a traffic intersection.
Determine if a traffic accident is visible in 
this image. Respond with yes or no only. 
Do not include any other information',
TO_FILE('@IMAGE_ANALYSIS',
'traffic_intersection_1.png')) AS ITEM
;


  SELECT SNOWFLAKE.CORTEX.COMPLETE('pixtral-large', 

  --- multimodal
  -- https://docs.snowflake.com/en/user-guide/snowflake-cortex/complete-multimodal#process-images
-- pixtral-large
-- claude-3-5-sonnet
  SELECT SNOWFLAKE.CORTEX.COMPLETE('pixtral-large',
    'Fully describe the image in at least 100 words',
    TO_FILE('@images', 'IMG_3116.jpg'));


  --- https://medium.com/snowflake/analyzing-car-traffic-with-snowflake-cortex-complete-multimodal-393fbf48cd7c

  SELECT SNOWFLAKE.CORTEX.COMPLETE('pixtral-large', 
'Return a count the number of distinct vehicles in this image.
Do not provide any other details. 
Do not provide any other words or commentary.',
TO_FILE('@TRAFFIC','cam.path.0a9f1346-5f4a-424c-bdac-3fd6c16e099920250529094328.jpg20250529115868.jpg')) AS COUNT_VEHICLES;


SELECT SNOWFLAKE.CORTEX.COMPLETE('pixtral-large', 
'Return a count the number of distinct vehicles in this image.
Some of the vehicles may appear small. 
Pay particular attention to the vehicles in the upper part of the image.
Do not provide any other details. 
Do not provide any other words or commentary.',
TO_FILE('@TRAFFIC','cam.path.0a9f1346-5f4a-424c-bdac-3fd6c16e099920250529094328.jpg20250529115868.jpg')) AS COUNT_VEHICLES

SELECT SNOWFLAKE.CORTEX.COMPLETE('pixtral-large', 'This is an image of a freeway with lanes.
Categorize the intensity of the overall traffic in the lanes as one of either light or medium or heavy. 
Only reply with a single word.
Do not provide any other details. 
Do not provide any other words or commentary',TO_FILE('@TRAFFIC',
'cam.path.0a9f1346-5f4a-424c-bdac-3fd6c16e099920250529094328.jpg20250529115868.jpg')) AS TRAFFIC_INTENSITY


SELECT SNOWFLAKE.CORTEX.COMPLETE('pixtral-large', 
'This is a photograph of a traffic intersection.
Determine if a traffic accident is visible in 
this image. Respond with yes or no only. 
Do not include any other information',
TO_FILE('@TRAFFIC',
'cam.path.0a9f1346-5f4a-424c-bdac-3fd6c16e099920250529094328.jpg20250529115868.jpg')) AS ITEM

-- https://docs.snowflake.com/en/user-guide/snowflake-cortex/complete-multimodal
-- https://docs.snowflake.com/en/sql-reference/functions/prompt

--NoLiveCamera.jpg

SELECT SNOWFLAKE.CORTEX.COMPLETE('claude-3-5-sonnet',PROMPT('Compare these two traffic camera images {0} {1}',TO_FILE('@Traffic','NoLiveCamera.jpg'),
TO_FILE('@Traffic','cam.path.0a9f1346-5f4a-424c-bdac-3fd6c16e099920250529094328.jpg20250529115868.jpg')));


CREATE OR REPLACE TABLE DEMO.DEMO.RAWNYCTRAFFICIMAGES 
(
    json_data VARIANT
);

select * from RAWNYCTRAFFICIMAGES;


WITH traffic_data AS (
    SELECT n.*,
           r.json_data,
           JSON_DATA:direction::STRING as direction,
           JSON_DATA:environment.surroundings::ARRAY as surroundings,
           JSON_DATA:environment.visibility::STRING as visibility,
           JSON_DATA:environment.weather::STRING as weather,
           JSON_DATA:image_quality::STRING as image_quality,
           JSON_DATA:location::STRING as location,
           JSON_DATA:road_features.bike_lane::STRING as bike_lane,
           JSON_DATA:road_features.lanes::STRING as lanes,
           JSON_DATA:road_features.markings::ARRAY as road_markings,
           JSON_DATA:road_features.traffic_signals::STRING as traffic_signals,
           JSON_DATA:timestamp::STRING as traffictimestamp,
           JSON_DATA:traffic_conditions::STRING as traffic_conditions,
           n.latitude as traffic_lat,
           n.longitude as traffic_long
    FROM DEMO.DEMO.NYCTRAFFICIMAGES n
    LEFT OUTER JOIN DEMO.DEMO.RAWNYCTRAFFICIMAGES r
    ON n.filename = r.filename
)
SELECT 
    t.*,
    a.number || ' ' || a.street || ' ' || a.street_type as street_address,
    a.city,
    a.state,
    a.zip,
    a.latitude as address_lat,
    a.longitude as address_long,
    ST_DISTANCE(
        ST_MAKEPOINT(t.traffic_long, t.traffic_lat),
        ST_MAKEPOINT(a.longitude, a.latitude)
    ) as distance_in_meters
FROM traffic_data t
LEFT OUTER JOIN US_REAL_ESTATE.CYBERSYN.US_ADDRESSES a
ON a.state = 'NY' 
AND ST_DISTANCE(
    ST_MAKEPOINT(t.traffic_long, t.traffic_lat),
    ST_MAKEPOINT(a.longitude, a.latitude)
) <= 100
QUALIFY ROW_NUMBER() OVER (
    PARTITION BY t.filename 
   ORDER BY ST_DISTANCE(
        ST_MAKEPOINT(t.traffic_long, t.traffic_lat),
        ST_MAKEPOINT(a.longitude, a.latitude)
    )
) = 1;


select * from US_REAL_ESTATE.CYBERSYN.US_ADDRESSES LIMIT 1;


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

alter stage traffic refresh;

LIST  @traffic;


