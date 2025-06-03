WITH pictures AS 
(SELECT RELATIVE_PATH as img, size, last_modified, file_url,
    get_presigned_url(@TRAFFIC, RELATIVE_PATH) as preurl 
   FROM DIRECTORY(@TRAFFIC) LIMIT 3)
SELECT img AS file_path, preurl, size, last_modified
FROM pictures
WHERE AI_FILTER(PROMPT('{0} is a traffic picture', img));

SELECT AI_COMPLETE('claude-3-5-sonnet',
    PROMPT('Compare this image {0} to this image {1} and tell me if they are the same, if not what is different',
    TO_FILE('@TRAFFIC', 'cam.trimg.cameralist.json518bb5e7-9308-4212-9f15-d22312ae410e.jpg20250530133715.jpg'),
    TO_FILE('@TRAFFIC', 'NoLiveCamera.jpg')
));



CREATE OR REPLACE VIEW VWNYCTRAFFIC
AS 
SELECT TO_DOUBLE(LATITUDE) as Latitude,TO_DOUBLE(LONGITUDE) as Longitude,ROADWAYNAME,VIDEONAME,DIRECTIONOFTRAVEL,FILENAME
FROM DEMO.DEMO.NYCTRAFFICIMAGES
WHERE LATITUDE IS NOT NULL 
AND LONGITUDE IS NOT NULL;

