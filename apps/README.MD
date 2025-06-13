# Import python packages
import streamlit as st
from snowflake.snowpark.context import get_active_session
from snowflake.snowpark.functions import *
from snowflake.snowpark.types import *
import json
import pandas as pd
import numpy as np
from snowflake.snowpark.files import SnowflakeFile
from snowflake.snowpark.functions import col
from streamlit.components.v1 import html

st.set_page_config(layout="wide")

st.title(f"New York City")

session = get_active_session()

traffic_latlon = session.table('DEMO.DEMO.VWRAWTRAFFIC')
 
st.markdown('#### Traffic Camera Locations')

for row in traffic_latlon.collect():
    col1, col2 = st.columns([1, 2])
    
    with col1:
        st.subheader(row['ROADWAYNAME'])
        st.write(f"📍 Location: ({row['LATITUDE']}, {row['LONGITUDE']})")
        st.write(f"🎥 Camera: {row['VIDEONAME']}")
        st.write(f"➡️ Direction: {row['DIRECTIONOFTRAVEL']}")
        with st.expander("View JSON Data"):
            st.json(row['JSON_DATA'])
    
    with col2:
        with st.spinner('Loading image...'):
            st.image(row['IMG_URL'])
    
    st.divider()  


   # formattedRow = "\n#### " +  row['ROADWAYNAME'] + " \n(" + row['LATITUDE'] + ", " + row['LONGITUDE'] + ") " + row['VIDEONAME'] + " " + row['DIRECTIONOFTRAVEL']
    
    #st.markdown( formattedRow )
    #st.json(row['JSON_DATA'])
    #st.image(row['IMG_URL'])
    #trafficimglist.append(row['IMG'])
    # st.write( str(row['RELATIVE_PATH']) )
   # result = session.call('DEMO.DEMO.COUNT_VEHICLES_IN_IMAGE', str(row['RELATIVE_PATH'])) 
   # st.json(result)
   # st.image(row['IMG']) 

# R.UUID, R.FILENAME, R.JSON_DATA, 
#       get_presigned_url(@TRAFFIC, R.FILENAME) as IMG_URL,
#       N.CREATED_TS, N.DIRECTIONOFTRAVEL, N.ENDING, N.LATITUDE, N.longitude, N.ROADWAYNAME,
#       N.URL2, N.VIDEOID, N.VIDEONAME, DT.relative_path, DT.size as file_size, DT.last_modified

# st.image(trafficimglist, width=250)
# 



import streamlit as st
from snowflake.snowpark.context import get_active_session
import pandas as pd

st.set_page_config(layout="wide")
st.title("New York City")

# Cache the data fetch
@st.cache_data
def load_traffic_data():
    session = get_active_session()
    traffic_latlon = session.table('DEMO.DEMO.VWRAWTRAFFIC')
    return traffic_latlon.collect()

# Load data with progress bar
with st.spinner('Loading traffic camera data...'):
    traffic_data = load_traffic_data()
    total_cameras = len(traffic_data)

# Pagination controls
cameras_per_page = st.select_slider("Cameras per page", options=[3,5,10,20], value=5)
total_pages = -(-total_cameras // cameras_per_page)  # Ceiling division
current_page = st.number_input("Page", min_value=1, max_value=total_pages, value=1)

# Calculate slice indices
start_idx = (current_page - 1) * cameras_per_page
end_idx = min(start_idx + cameras_per_page, total_cameras)

# Show progress
st.progress(current_page / total_pages)
st.write(f"Showing cameras {start_idx + 1} to {end_idx} of {total_cameras}")

# Display cameras for current page
for idx, row in enumerate(traffic_data[start_idx:end_idx]):
    col1, col2 = st.columns([1, 2])
    
    with col1:
        st.subheader(row['ROADWAYNAME'])
        st.write(f"📍 Location: ({row['LATITUDE']}, {row['LONGITUDE']})")
        st.write(f"🎥 Camera: {row['VIDEONAME']}")
        st.write(f"➡️ Direction: {row['DIRECTIONOFTRAVEL']}")
        with st.expander("View JSON Data"):
            st.json(row['JSON_DATA'])
    
    with col2:
        try:
            with st.spinner('Loading image...'):
                placeholder = st.empty()
                placeholder.text("Loading image...")
                img = row['IMG_URL']
                placeholder.image(img)
        except Exception as e:
            st.error(f"Failed to load image: {str(e)}")
    
    st.divider()

# Navigation buttons
col1, col2 = st.columns(2)
with col1:
    if current_page > 1:
        if st.button("Previous Page"):
            current_page -= 1
with col2:
    if current_page < total_pages:
        if st.button("Next Page"):
            current_page += 1








import streamlit as st
from snowflake.snowpark.context import get_active_session
import pandas as pd

st.set_page_config(layout="wide")

# Dark/Light mode toggle
theme = st.sidebar.radio("Theme", ["Light", "Dark"])
if theme == "Dark":
    st.markdown("""
        <style>
        .stApp {
            background-color: #262730;
            color: white;
        }
        </style>
    """, unsafe_allow_html=True)

st.title("New York City")

# Cache data loading
@st.cache_data
def load_traffic_data():
    session = get_active_session()
    traffic_latlon = session.table('DEMO.DEMO.VWRAWTRAFFIC')
    return traffic_latlon.to_pandas()

# Load data
if 'data' not in st.session_state or st.sidebar.button('🔄 Refresh Data'):
    with st.spinner('Loading traffic camera data...'):
        st.session_state.data = load_traffic_data()

df = st.session_state.data

# Filters and controls
col1, col2, col3 = st.columns(3)
with col1:
    sort_by = st.selectbox("Sort by", ["Road Name", "Direction"])
with col2:
    road_filter = st.multiselect("Filter by Road", options=sorted(df['ROADWAYNAME'].unique()))
with col3:
    direction_filter = st.multiselect("Filter by Direction", options=sorted(df['DIRECTIONOFTRAVEL'].unique()))

# Apply filters
filtered_df = df.copy()
if road_filter:
    filtered_df = filtered_df[filtered_df['ROADWAYNAME'].isin(road_filter)]
if direction_filter:
    filtered_df = filtered_df[filtered_df['DIRECTIONOFTRAVEL'].isin(direction_filter)]

# Sort data
if sort_by == "Road Name":
    filtered_df = filtered_df.sort_values('ROADWAYNAME')
else:
    filtered_df = filtered_df.sort_values('DIRECTIONOFTRAVEL')

# Map view toggle
show_map = st.checkbox("Show Map View")
if show_map:
    st.map(filtered_df[['LATITUDE', 'LONGITUDE']])

# Image size control
image_size = st.slider("Image Size", 200, 800, 400)

# Display cameras
for _, row in filtered_df.iterrows():
    col1, col2 = st.columns([1, 2])
    
    with col1:
        st.subheader(row['ROADWAYNAME'])
        st.write(f"📍 Location: ({row['LATITUDE']}, {row['LONGITUDE']})")
        st.write(f"🎥 Camera: {row['VIDEONAME']}")
        st.write(f"➡️ Direction: {row['DIRECTIONOFTRAVEL']}")
        with st.expander("View JSON Data"):
            st.json(row['JSON_DATA'])
        
        # Download button
        st.download_button(
            label="Download Image",
            data=row['IMG_URL'],
            file_name=f"camera_{row['VIDEONAME']}.jpg",
            mime="image/jpeg"
        )
    
    with col2:
        with st.spinner('Loading image...'):
            st.image(row['IMG_URL'], width=image_size)
    
    st.divider()
import streamlit as st
from snowflake.snowpark.context import get_active_session
import pandas as pd

st.set_page_config(layout="wide")

# Dark/Light mode toggle
theme = st.sidebar.radio("Theme", ["Light", "Dark"])
if theme == "Dark":
    st.markdown("""
        <style>
        .stApp {
            background-color: #262730;
            color: white;
        }
        </style>
    """, unsafe_allow_html=True)

st.title("New York City")

# Cache data loading
@st.cache_data
def load_traffic_data():
    session = get_active_session()
    traffic_latlon = session.table('DEMO.DEMO.VWRAWTRAFFIC')
    return traffic_latlon.to_pandas()

# Load data
if 'data' not in st.session_state or st.sidebar.button('🔄 Refresh Data'):
    with st.spinner('Loading traffic camera data...'):
        st.session_state.data = load_traffic_data()

df = st.session_state.data

# Filters and controls
col1, col2, col3 = st.columns(3)
with col1:
    sort_by = st.selectbox("Sort by", ["Road Name", "Direction"])
with col2:
    road_filter = st.multiselect("Filter by Road", options=sorted(df['ROADWAYNAME'].unique()))
with col3:
    direction_filter = st.multiselect("Filter by Direction", options=sorted(df['DIRECTIONOFTRAVEL'].unique()))

# Apply filters
filtered_df = df.copy()
if road_filter:
    filtered_df = filtered_df[filtered_df['ROADWAYNAME'].isin(road_filter)]
if direction_filter:
    filtered_df = filtered_df[filtered_df['DIRECTIONOFTRAVEL'].isin(direction_filter)]

# Sort data
if sort_by == "Road Name":
    filtered_df = filtered_df.sort_values('ROADWAYNAME')
else:
    filtered_df = filtered_df.sort_values('DIRECTIONOFTRAVEL')

# Map view toggle
show_map = st.checkbox("Show Map View")
if show_map:
    st.map(filtered_df[['LATITUDE', 'LONGITUDE']])

# Image size control
image_size = st.slider("Image Size", 200, 800, 400)

# Display cameras
for _, row in filtered_df.iterrows():
    col1, col2 = st.columns([1, 2])
    
    with col1:
        st.subheader(row['ROADWAYNAME'])
        st.write(f"📍 Location: ({row['LATITUDE']}, {row['LONGITUDE']})")
        st.write(f"🎥 Camera: {row['VIDEONAME']}")
        st.write(f"➡️ Direction: {row['DIRECTIONOFTRAVEL']}")
        with st.expander("View JSON Data"):
            st.json(row['JSON_DATA'])
        
        # Download button
        st.download_button(
            label="Download Image",
            data=row['IMG_URL'],
            file_name=f"camera_{row['VIDEONAME']}.jpg",
            mime="image/jpeg"
        )
    
    with col2:
        with st.spinner('Loading image...'):
            st.image(row['IMG_URL'], width=image_size)
    
    st.divider()




import streamlit as st
from snowflake.snowpark.context import get_active_session
import pandas as pd
import altair as alt
from PIL import Image, ImageEnhance
import io
import requests

st.set_page_config(layout="wide")

# Initialize session state for favorites and image settings
if 'favorites' not in st.session_state:
    st.session_state.favorites = set()
if 'brightness' not in st.session_state:
    st.session_state.brightness = 1.0
if 'contrast' not in st.session_state:
    st.session_state.contrast = 1.0

# Cache data loading
@st.cache_data
def load_traffic_data():
    session = get_active_session()
    traffic_latlon = session.table('DEMO.DEMO.VWRAWTRAFFIC')
    return traffic_latlon.to_pandas()

# Image processing function
def process_image(image_url, brightness, contrast):
    response = requests.get(image_url)
    img = Image.open(io.BytesIO(response.content))
    img = ImageEnhance.Brightness(img).enhance(brightness)
    img = ImageEnhance.Contrast(img).enhance(contrast)
    return img

# Load data
if 'data' not in st.session_state or st.sidebar.button('🔄 Refresh Data'):
    with st.spinner('Loading traffic camera data...'):
        st.session_state.data = load_traffic_data()

df = st.session_state.data

# Sidebar controls
with st.sidebar:
    st.subheader("Search & Filters")
    search_query = st.text_input("🔍 Search Cameras", "")
    view_mode = st.radio("View Mode", ["List", "Grid", "Map"])
    show_favorites = st.checkbox("Show Favorites Only")
    
    st.subheader("Image Settings")
    st.session_state.brightness = st.slider("Brightness", 0.0, 2.0, 1.0)
    st.session_state.contrast = st.slider("Contrast", 0.0, 2.0, 1.0)
    
    st.download_button(
        "Export Camera Metadata",
        df.to_csv(index=False).encode('utf-8'),
        "traffic_cameras.csv",
        "text/csv"
    )

# Main filters
col1, col2, col3 = st.columns(3)
with col1:
    sort_by = st.selectbox("Sort by", ["Road Name", "Direction"])
with col2:
    road_filter = st.multiselect("Filter by Road", options=sorted(df['ROADWAYNAME'].unique()))
with col3:
    direction_filter = st.multiselect("Filter by Direction", options=sorted(df['DIRECTIONOFTRAVEL'].unique()))

# Apply filters
filtered_df = df.copy()
if search_query:
    filtered_df = filtered_df[
        filtered_df['ROADWAYNAME'].str.contains(search_query, case=False) |
        filtered_df['VIDEONAME'].str.contains(search_query, case=False)
    ]
if road_filter:
    filtered_df = filtered_df[filtered_df['ROADWAYNAME'].isin(road_filter)]
if direction_filter:
    filtered_df = filtered_df[filtered_df['DIRECTIONOFTRAVEL'].isin(direction_filter)]
if show_favorites:
    filtered_df = filtered_df[filtered_df['VIDEONAME'].isin(st.session_state.favorites)]

# Display cameras based on view mode
if view_mode == "Map":
    st.map(filtered_df[['LATITUDE', 'LONGITUDE']])

elif view_mode == "Grid":
    cols = st.columns(3)
    for idx, row in filtered_df.iterrows():
        with cols[idx % 3]:
            st.subheader(row['ROADWAYNAME'])
            if st.button("⭐", key=f"fav_{row['VIDEONAME']}"):
                if row['VIDEONAME'] in st.session_state.favorites:
                    st.session_state.favorites.remove(row['VIDEONAME'])
                else:
                    st.session_state.favorites.add(row['VIDEONAME'])
            
            with st.expander("Details"):
                st.write(f"📍 ({row['LATITUDE']}, {row['LONGITUDE']})")
                st.write(f"➡️ {row['DIRECTIONOFTRAVEL']}")
            
            try:
                img = process_image(
                    row['IMG_URL'],
                    st.session_state.brightness,
                    st.session_state.contrast
                )
                st.image(img)
            except Exception as e:
                st.error("Failed to load image")

else:  # List view
    for _, row in filtered_df.iterrows():
        col1, col2 = st.columns([1, 2])
        with col1:
            st.subheader(row['ROADWAYNAME'])
            if st.button("⭐", key=f"fav_{row['VIDEONAME']}"):
                if row['VIDEONAME'] in st.session_state.favorites:
                    st.session_state.favorites.remove(row['VIDEONAME'])
                else:
                    st.session_state.favorites.add(row['VIDEONAME'])
            st.write(f"📍 ({row['LATITUDE']}, {row['LONGITUDE']})")
            st.write(f"➡️ {row['DIRECTIONOFTRAVEL']}")
        
        with col2:
            try:
                img = process_image(
                    row['IMG_URL'],
                    st.session_state.brightness,
                    st.session_state.contrast
                )
                st.image(img)
            except Exception as e:
                st.error(e)
                st.error("Failed to load image")
        
        st.divider()


