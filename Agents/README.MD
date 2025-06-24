### Snowflake Cortex AI Agents

 
![img](https://github.com/tspannhw/TrafficAI/blob/main/Agents/trimg.c26a348d-77c4-4424-9728-cf969866a3669a924cc4-6515-4be0-a452-bfd4af0798c6.jpg?raw=true)



### Let's call MCP Server from Cursor IDE

Download from:
https://www.cursor.com/

### MCP Snowflake Labs Server

https://github.com/Snowflake-Labs/mcp


#### Server Config on Mac PC - /Users/tspann/Downloads/code/mcp/services/service_config.yaml

````
cortex_complete: # Set default model if one is not specified by user in Cortex Copmlete tool
  default_model: "snowflake-llama-3.3-70b"
search_services: # List all Cortex Search services
  - service_name: "TRAFFICIMAGESEARCH"
    description: > # Should start with "Search service that ..."
      "trafficsearch service"
    database_name: "DEMO"
    schema_name: "DEMO"
analyst_services: # List all Cortex Analyst semantic models/views
  - service_name: "cortextraffic" # Create descriptive name for the service
    semantic_model: "@DEMO.DEMO.SEMANTIC_MODELS/TRAFFIC.yaml"
    description: 
      "Semantic Model for Traffic Tables"

````

#### Configure Connection

````
{
  "mcpServers": {
    "mcp-server-snowflake": {
      "command": "uvx",
      "args": [
        "--from",
        "git+https://github.com/Snowflake-Labs/mcp",
        "mcp-server-snowflake",
        "--service-config-file",
        "/Users/tspann/Downloads/code/mcp/services/service_config.yaml",
        "--account-identifier",
        "sfsenorthamerica-tspann-aws1",
        "--username",
        "NIFIGUY",
        "--pat",
        "snowflakepatencryptedvalue"
      ]
    }
  }
}

````

### Cursor IDE Run


# Retrieve camera data from 5th Avenue
_Exported on 6/23/2025 at 15:47:55 EDT from Cursor (1.1.3)_

---

**User**

Use cortextraffic and trafficimagesearch tools to answer Show me camera data from 5th Avenue

---

**Cursor**

Here is recent camera data from 5th Avenue, New York, combining both traffic camera feeds and image search results:

---

### Latest Traffic Camera Feeds (Sampled Intersections)

1. **5 Avenue @ 72 Street**
   - **Timestamp:** 2025-06-23 08:51:35 AM
   - **Direction:** Facing North
   - **Traffic:** Light to moderate, 3-4 cars visible, no pedestrians in frame
   - **Weather:** Clear, sunny day
   - **Image:** ![5 Ave @ 72 St](https://sfc-va3-ds1-95-customer-stage.s3.us-east-1.amazonaws.com/fnhu0000-s/stages/39195f89-13d9-4e5b-946a-d0eb23f63c9e/trimg.8f5eb19b-c727-477a-9190-5a0642b5c96505490a7d-cb45-4bd8-81be-2505e0995c7d.jpg)

2. **5 Avenue @ 57 Street**
   - **Timestamp:** 2025-06-23 08:51:39 AM
   - **Direction:** Facing South
   - **Traffic:** 2-3 cars, 2 pedestrians using crosswalk, bus lanes visible
   - **Weather:** Overcast/cloudy
   - **Image:** ![5 Ave @ 57 St](https://sfc-va3-ds1-95-customer-stage.s3.us-east-1.amazonaws.com/fnhu0000-s/stages/39195f89-13d9-4e5b-946a-d0eb23f63c9e/trimg.8f5eb19b-c727-477a-9190-5a0642b5c96571da1351-c494-4936-8241-3d9eee0065fe.jpg)

3. **5 Avenue @ 49 Street**
   - **Timestamp:** 2025-06-23 08:51:27 AM
   - **Direction:** Facing West
   - **Traffic:** Light, several parked and moving cars, street vendors visible
   - **Weather:** Sunny/clear
   - **Image:** ![5 Ave @ 49 St](https://sfc-va3-ds1-95-customer-stage.s3.us-east-1.amazonaws.com/fnhu0000-s/stages/39195f89-13d9-4e5b-946a-d0eb23f63c9e/trimg.8f5eb19b-c727-477a-9190-5a0642b5c9650a5c1d22-4ef8-43cc-a832-7849af8d0d33.jpg)

4. **5 Avenue @ 42 Street**
   - **Timestamp:** 2025-06-23 08:51:19 AM
   - **Direction:** Facing South
   - **Traffic:** Heavy foot traffic, vehicles stopped for pedestrian crossing
   - **Weather:** Clear day
   - **Image:** ![5 Ave @ 42 St](https://sfc-va3-ds1-95-customer-stage.s3.us-east-1.amazonaws.com/fnhu0000-s/stages/39195f89-13d9-4e5b-946a-d0eb23f63c9e/trimg.8f5eb19b-c727-477a-9190-5a0642b5c965da3cea36-91d0-4b6b-961a-774f612ca7f7.jpg)

5. **5 Avenue @ 23 Street**
   - **Timestamp:** 2025-06-23 08:51:10 AM
   - **Direction:** Unknown
   - **Traffic:** Multiple vehicles, typical city center scene
   - **Weather:** Slightly hazy/low resolution
   - **Image:** ![5 Ave @ 23 St](https://sfc-va3-ds1-95-customer-stage.s3.us-east-1.amazonaws.com/fnhu0000-s/stages/39195f89-13d9-4e5b-946a-d0eb23f63c9e/trimg.8f5eb19b-c727-477a-9190-5a0642b5c96526dbf149-c8ca-4c8b-8c05-913ed08e2da4.jpg)

---

### Additional Image Search Highlights

- **General Conditions:** Most images show clear to overcast weather, light to moderate traffic, and typical urban street scenes with multi-lane roads, crosswalks, and visible traffic signals.
- **Pedestrian Activity:** Ranges from few to heavy, depending on the intersection and time.
- **Vehicle Types:** Mix of private cars, yellow taxis, buses, and delivery trucks.
- **Notable Features:** Street vendors, American flags, digital billboards (near Times Square), and tree-lined sidewalks are visible in several images.

If you need more details for a specific intersection or time, let me know!

---

**User**

Give me the full details from 5 Ave @ 23 St

---

**Cursor**

Here are the full details from the latest camera data for **5 Avenue @ 23 Street**:

---

### Camera: 5 Avenue @ 23 Street

- **Timestamp:** 2025-06-23 08:51:10 AM
- **Direction of Travel:** Unknown
- **Roadway Name:** New York County
- **Image:**  
  ![5 Ave @ 23 St](https://sfc-va3-ds1-95-customer-stage.s3.us-east-1.amazonaws.com/fnhu0000-s/stages/39195f89-13d9-4e5b-946a-d0eb23f63c9e/trimg.8f5eb19b-c727-477a-9190-5a0642b5c96526dbf149-c8ca-4c8b-8c05-913ed08e2da4.jpg)

#### Scene Details (from camera JSON data):

```json
{
  "elements": {
    "buildings": "tall_commercial_buildings_with_american_flags",
    "infrastructure": [
      "traffic_lights",
      "street_lamps"
    ],
    "lighting": "appears_to_be_daytime",
    "notable_features": [
      "tree_canopy_visible",
      "urban_canyon_effect",
      "american_flags_on_buildings"
    ],
    "perspective": "looking_down_street_corridor",
    "traffic": "multiple_vehicles_on_road"
  },
  "image_quality": "slightly_hazy_or_low_resolution",
  "location": "city_center",
  "scene_type": "urban_street"
}
```

#### Summary:
- **Buildings:** Tall commercial buildings, many with American flags.
- **Infrastructure:** Traffic lights and street lamps are present.
- **Lighting:** Daytime, but image is slightly hazy or low resolution.
- **Notable Features:** Tree canopy, urban canyon effect, American flags on buildings.
- **Perspective:** Looking down the street corridor (classic NYC avenue view).
- **Traffic:** Multiple vehicles on the road, typical city center activity.
- **Scene Type:** Urban street in the city center.

If you need more images or historical data for this location, let me know!

```json
{
  "elements": {
    "buildings": "tall_commercial_buildings_with_american_flags",
    "infrastructure": [
      "traffic_lights",
      "street_lamps"
    ],
    "lighting": "appears_to_be_daytime",
    "notable_features": [
      "tree_canopy_visible",
      "urban_canyon_effect",
      "american_flags_on_buildings"
    ],
    "perspective": "looking_down_street_corridor",
    "traffic": "multiple_vehicles_on_road"
  },
  "image_quality": "slightly_hazy_or_low_resolution",
  "location": "city_center",
  "scene_type": "urban_street"
}
```

---

**User**

Give me the full details from 7 ave

---

**Cursor**

Here are the full details from the latest camera data for **7th Avenue** in New York:

---

### 1. 7 Avenue @ 57 Street
- **Timestamp:** 2025-06-23 09:30:51 AM
- **Direction:** Facing North
- **Environment:** Commercial/Urban, few pedestrians, overcast/cloudy
- **Road Features:** Bus lane, visible lane markings, "BUS" text on road
- **Traffic:** Moderate congestion, buses, delivery trucks, commercial vehicles, cars
- **Image:**  
  ![7 Ave @ 57 St](https://sfc-va3-ds1-95-customer-stage.s3.us-east-1.amazonaws.com/fnhu0000-s/stages/39195f89-13d9-4e5b-946a-d0eb23f63c9e/trimg.8e89132c-a818-4e21-8d36-b06193d137a52f8066f7-3c31-4cf6-b6b4-393974199ff6.jpg)

---

### 2. 7 Avenue @ 49 Street
- **Timestamp:** 2025-06-23 09:30:51 AM
- **Direction:** Facing East
- **Environment:** Digital billboards, commercial buildings, traffic signals, clear visibility, overcast/gray
- **Notable:** Modern commercial/retail, high density of advertising, multi-lane urban thoroughfare
- **Traffic:** Moderate, slow moving, cars, buses, commercial vehicles
- **Image:**  
  ![7 Ave @ 49 St](https://sfc-va3-ds1-95-customer-stage.s3.us-east-1.amazonaws.com/fnhu0000-s/stages/39195f89-13d9-4e5b-946a-d0eb23f63c9e/trimg.8e89132c-a818-4e21-8d36-b06193d137a50be6f5ae-b547-4e11-a203-1e74b719e330.jpg)

---

### 3. 7 Avenue @ 34 Street
- **Timestamp:** 2025-06-23 09:29:55 AM
- **Direction:** Facing North
- **Environment:** High-rise office/retail, downtown/commercial, clear visibility
- **Notable:** Ground-level retail, traffic signals, street lights, Manhattan grid
- **Pedestrian Activity:** Several at crosswalk
- **Traffic:** Moderate, multiple cars, yellow taxi
- **Image:**  
  ![7 Ave @ 34 St](https://sfc-va3-ds1-95-customer-stage.s3.us-east-1.amazonaws.com/fnhu0000-s/stages/39195f89-13d9-4e5b-946a-d0eb23f63c9e/trimg.8e89132c-a818-4e21-8d36-b06193d137a516fdd521-d703-4661-ad94-7b29b7772168.jpg)

---

### 4. 7 Avenue @ 125 Street
- **Timestamp:** 2025-06-23 09:30:43 AM
- **Direction:** Facing North
- **Environment:** Multi-story commercial/retail, sidewalks, street trees, sunny/clear
- **Scene:** Typical morning urban, business district
- **Traffic:** Few pedestrians, light, minimal vehicles
- **Image:**  
  ![7 Ave @ 125 St](https://sfc-va3-ds1-95-customer-stage.s3.us-east-1.amazonaws.com/fnhu0000-s/stages/39195f89-13d9-4e5b-946a-d0eb23f63c9e/trimg.8e89132c-a818-4e21-8d36-b06193d137a5f714461f-c209-48ad-855d-841c6c3ee63e.jpg)

---

### 5. 7 Avenue @ 23 Street
- **Timestamp:** 2025-06-23 09:16:53 AM
- **Direction:** Facing North
- **Infrastructure:** Utility/light poles, sidewalks, traffic signals
- **Road Features:** Multiple lanes, double yellow lines, crosswalk stripes, red-painted bus lane
- **Scene:** Urban street intersection, daylight, clear
- **Vehicles:** One dark-colored vehicle visible
- **Image:**  
  ![7 Ave @ 23 St](https://sfc-va3-ds1-95-customer-stage.s3.us-east-1.amazonaws.com/fnhu0000-s/stages/39195f89-13d9-4e5b-946a-d0eb23f63c9e/trimg.06a14057-375e-4078-bf2d-804d75879ab036528d0f-7f8f-40f9-bd6e-03e0ea22b072.jpg)

---

### Additional Image Search Highlights

- **General:** Multi-lane city avenue, commercial buildings, retail stores, sidewalks with pedestrians, clear/sunny, moderate congestion, cars, taxis, commercial vehicles.
- **Notable:** Bike lanes, crosswalks, digital billboards (Times Square), street trees, typical NYC urban canyon effect, yellow taxis, and moderate to light traffic.

If you want full details for a specific intersection or a particular time, let me know!

---

**User**

Get the details from 9 ave

---

**Cursor**

Here are the latest details from traffic cameras on 9th Avenue in New York:

---

### 1. 207 Street @ 9 Avenue
- **Timestamp:** 2025-06-23 12:40:08 PM
- **Direction:** Facing East
- **Traffic:** Heavy congestion, multiple lanes with backed up traffic, slow moving, cars and trucks
- **Weather:** Clear, good visibility
- **Image:**  
  ![207 St @ 9 Ave](https://sfc-va3-ds1-95-customer-stage.s3.us-east-1.amazonaws.com/fnhu0000-s/stages/39195f89-13d9-4e5b-946a-d0eb23f63c9e/trimg.c26a348d-77c4-4424-9728-cf969866a366dbcdf676-7279-49a6-808b-6e0043beff7b.jpg)

---

### 2. 9 Avenue @ 23 Street
- **Timestamp:** 2025-06-23 11:45:55 AM
- **Direction:** Facing East
- **Environment:** Daylight, street parking both sides, tree-lined, clear weather
- **Road:** 2 lanes, clear and dry, yellow divider, asphalt
- **Traffic:** Light, large truck and several parked cars
- **Image:**  
  ![9 Ave @ 23 St](https://sfc-va3-ds1-95-customer-stage.s3.us-east-1.amazonaws.com/fnhu0000-s/stages/39195f89-13d9-4e5b-946a-d0eb23f63c9e/trimg.624febed-4e4b-4e13-8908-8fc38fdbb8c70ae780ce-17ed-4c78-af92-93782400af06.jpg)

---

### 3. 9 Avenue @ 57 Street
- **Timestamp:** 2025-06-23 11:44:58 AM
- **Direction:** Facing North
- **Environment:** Mix of red brick and modern buildings, tall residential/commercial, wide sidewalks, some trees, clear/sunny
- **Traffic:** Light to moderate, multiple vehicles, yellow taxi, wide zebra crossing
- **Image:**  
  ![9 Ave @ 57 St](https://sfc-va3-ds1-95-customer-stage.s3.us-east-1.amazonaws.com/fnhu0000-s/stages/39195f89-13d9-4e5b-946a-d0eb23f63c9e/trimg.624febed-4e4b-4e13-8908-8fc38fdbb8c7fa80bb3f-bffa-41a5-8f67-ae812cbc0afa.jpg)

---

### 4. 9 Avenue @ 49 Street
- **Timestamp:** 2025-06-23 11:45:51 AM
- **Environment:** Urban, daylight, sunny/clear, tree-lined, multiple lanes with directional arrows, well-marked crosswalk, street signs
- **Traffic:** Several pedestrians crossing, clear and orderly, light vehicle density
- **Image:**  
  ![9 Ave @ 49 St](https://sfc-va3-ds1-95-customer-stage.s3.us-east-1.amazonaws.com/fnhu0000-s/stages/39195f89-13d9-4e5b-946a-d0eb23f63c9e/trimg.624febed-4e4b-4e13-8908-8fc38fdbb8c717453679-4481-44ee-85e4-ce2affd2a438.jpg)

---

### 5. 9 Avenue @ 42 Street
- **Timestamp:** 2025-06-23 11:46:26 AM
- **Direction:** Facing South
- **Environment:** Good daylight, commercial/office, covered walkway/awning, street trees, clear/sunny
- **Traffic:** Light, large bus/coach moving, multiple parked cars and white vans
- **Image:**  
  ![9 Ave @ 42 St](https://sfc-va3-ds1-95-customer-stage.s3.us-east-1.amazonaws.com/fnhu0000-s/stages/39195f89-13d9-4e5b-946a-d0eb23f63c9e/trimg.624febed-4e4b-4e13-8908-8fc38fdbb8c73b79113c-26ef-49f0-b3ea-463452e6429a.jpg)

---

If you need details for a specific intersection or more historical data, let me know!





### References

* https://docs.cursor.com/context/model-context-protocol
* https://github.com/Snowflake-Labs/mcp

