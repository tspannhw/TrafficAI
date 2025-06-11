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

st.set_page_config(layout="wide")

st.title(f"New York City")

session = get_active_session()

traffic_latlon = session.table('DEMO.DEMO.VWNYCTRAFFIC')
 
st.markdown('#### Traffic Station Locations')

# Convert to pandas DataFrame
df = traffic_latlon.to_pandas()

# Create PyDeck layer
layer = pdk.Layer(
    "ScatterplotLayer",
    df,
    get_position=["LONGITUDE", "LATITUDE"],
    get_color=[255, 0, 0, 160],
    get_radius=100,
    pickable=True
)

# Create view state centered on NYC
view_state = pdk.ViewState(
    latitude=40.7128,
    longitude=-74.0060,
    zoom=10,
    pitch=0
)

# Create deck with view state
deck = pdk.Deck(
    layers=[layer],
    initial_view_state=view_state,
    map_style="mapbox://styles/mapbox/light-v9",
        tooltip = {
       "html": "<b>Roadway:</b> {ROADWAYNAME} <br/> <b>Camera:</b> {VIDEONAME}  <b>Direction of Travel:</b> {DIRECTIONOFTRAVEL}",
       "style": {
            "backgroundColor": "steelblue",
            "color": "black"
       }
    }
)

st.pydeck_chart(deck)

trafficimglist = []
datal = session.sql("SELECT get_presigned_url(@TRAFFIC, RELATIVE_PATH) as img FROM DIRECTORY(@TRAFFIC) order by last_modified desc LIMIT 25;").to_local_iterator()

for row in datal:
    trafficimglist.append(row['IMG'])

st.image(trafficimglist, width=250)
