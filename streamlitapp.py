# Import python packages
import streamlit as st
from snowflake.snowpark.context import get_active_session
from snowflake.snowpark.functions import *
from snowflake.snowpark.types import *
import json
import pandas as pd
import numpy as np
import pydeck as pdk
from snowflake.snowpark.files import SnowflakeFile
from snowflake.snowpark.functions import col

st.title(f"New York City")

session = get_active_session()

traffic_latlon = session.table('DEMO.DEMO.VWNYCTRAFFIC')

st.markdown('#### A dataframe which shows all the traffic stations')
#st.dataframe(traffic_latlon)
st.map(traffic_latlon, latitude='latitude', longitude='longitude')

#image=session.file.get_stream("@DEMO.DEMO.TRAFFIC/NoLiveCamera.jpg" , decompress=False).read()

#st.image(image, width=250)

trafficimglist = []
datal = session.sql("SELECT get_presigned_url(@TRAFFIC, RELATIVE_PATH) as img FROM DIRECTORY(@TRAFFIC) order by last_modified desc LIMIT 25;").to_local_iterator()

for row in datal:
    trafficimglist.append( row['IMG'])

st.image(trafficimglist,width-250)
    
