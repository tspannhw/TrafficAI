CREATE OR REPLACE VIEW VWRAWTRAFFIC
AS 
select R.UUID, R.FILENAME, R.JSON_DATA, 
       get_presigned_url(@TRAFFIC, R.FILENAME) as IMG_URL,
       N.CREATED_TS, N.DIRECTIONOFTRAVEL, N.ENDING, N.LATITUDE, N.longitude, N.ROADWAYNAME,
       N.URL2, N.VIDEOID, N.VIDEONAME, DT.relative_path, DT.size as file_size, DT.last_modified
from RAWNYCTRAFFICIMAGES R LEFT OUTER JOIN nyctrafficimages N ON R.FILENAME = N.FILENAME
     INNER JOIN DIRECTORY(@TRAFFIC) DT ON DT.relative_path = N.FILENAME
     order by DT.last_modified desc;
