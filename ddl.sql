CREATE OR REPLACE TABLE DEMO.DEMO.NYCTRAFFICEVENTS (
ID VARCHAR(20) PRIMARY KEY,                    
UUID VARCHAR(255) NOT NULL,                     
EVENT_TYPE VARCHAR(255),                     
EVENT_SUB_TYPE VARCHAR(255),                   
DESCRIPTION TEXT,                              
SEVERITY VARCHAR(255),                          

-- Location Information
LATITUDE STRING,                        
LONGITUDE STRING,                       
REGION_NAME STRING,                      
COUNTY_NAME STRING,                       
ROADWAY_NAME STRING,                     
DIRECTION_OF_TRAVEL STRING,              
PRIMARY_LOCATION STRING,
SECONDARY_LOCATION STRING,
FIRST_ARTICLE_CITY STRING,
SECOND_CITY STRING,
NAVTEQ_LINK_ID VARCHAR(255),                   
MAP_ENCODED_POLYLINE TEXT,  
                  
-- Status Information
LANES_AFFECTED STRING,                   
LANES_STATUS STRING,

-- Temporal Information
LAST_UPDATED STRING,                       
REPORTED STRING,                           
START_DATE STRING,                         
PLANNED_END_DATE STRING,   
                
-- System Information
 TS STRING                                
);
