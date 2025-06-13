import streamlit as st
from snowflake.snowpark.context import get_active_session
import pandas as pd
import altair as alt
from PIL import Image, ImageEnhance
import io
import requests

st.set_page_config(layout="wide")

def load_traffic_data():
    session = get_active_session()
    traffic_latlon = session.table('DEMO.DEMO.VWRAWTRAFFIC')
    return traffic_latlon.to_pandas()

# Load data
if 'data' not in st.session_state or st.sidebar.button('🔄 Refresh Data'):
    with st.spinner('Loading traffic camera data...'):
        st.session_state.data = load_traffic_data()

df = st.session_state.data

# Sidebar controls
with st.sidebar:
    st.subheader("Search & Filters")
    search_query = st.text_input("🔍 Search Cameras", "")
    view_mode = st.radio("View Mode", ["List", "Grid"])
    
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

# Display cameras based on view mode
if view_mode == "Grid":
    cols = st.columns(3)
    for idx, row in filtered_df.iterrows():
        with cols[idx % 3]:
            st.subheader(row['ROADWAYNAME'])

            with st.expander("Details"):
                st.write(f"📍 Location: ({row['LATITUDE']}, {row['LONGITUDE']})")
                st.write(f"🎥 Camera: {row['VIDEONAME']}")
                st.write(f"➡️ Direction: {row['DIRECTIONOFTRAVEL']}")
                st.json(row['JSON_DATA'], expanded=False)
            
            try:
                st.image(row['IMG_URL'])
            except Exception as e:
                st.error("Failed to load image")

else:  # List view
    for _, row in filtered_df.iterrows():
        col1, col2 = st.columns([1, 2])
        with col1:
            st.subheader(row['ROADWAYNAME'])
            st.write(f"📍({row['LATITUDE']}, {row['LONGITUDE']})")
            st.write(f"🎥 {row['VIDEONAME']}")
            st.write(f"➡️ {row['DIRECTIONOFTRAVEL']}")
            st.json(row['JSON_DATA'], expanded=False)
            
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
