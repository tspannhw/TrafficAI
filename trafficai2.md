## AI-Powered Traffic Monitoring: An Apache NiFi Pipeline for NYC Cameras

**Introduction:**

In the era of smart cities, leveraging real-time data from urban infrastructure is crucial for efficient management and informed decision-making. Traffic camera feeds, in particular, offer a rich source of visual information that, when analyzed with Artificial Intelligence, can provide invaluable insights into traffic conditions, congestion, and even incident detection.

This article details a sophisticated Apache NiFi pipeline designed to capture real-time images from New York City traffic cameras, process them, push them to a Snowflake internal stage, invoke an AI stored procedure (Cortex AI) for analysis, and then store the results in a database while simultaneously alerting via Slack. This end-to-end solution demonstrates NiFi's power in orchestrating complex data flows, integrating with external APIs, cloud data warehouses, and AI services.

---

### **Phase 1: Ingesting NYC Camera Data**

The initial phase of our pipeline focuses on acquiring the camera metadata and then the actual images.

**1. Getting the List of NYC Cameras**

Our journey begins by fetching a list of all available NYC cameras from the 511NY API. The **InvokeHTTP** processor is the workhorse for interacting with external web services.

* **Processor:** `InvokeHTTP`
* **Purpose:** To make an API call to retrieve a JSON list of NYC traffic cameras.
* **URL:** `https://511ny.org/api/getcameras`
* **Expected Output:** A FlowFile containing a JSON array of camera objects.

**2. Handling API Response Errors**

Before processing, it's good practice to filter out any malformed or erroneous API responses. Small file sizes often indicate an error or an empty response.

* **Processor:** `RouteOnAttribute`
* **Purpose:** To discard FlowFiles that are likely error responses (e.g., very small, indicating an issue with the API call or an empty return).
* **Routing Rule:** `${fileSize:gt(4096)}` (Route FlowFiles with a size greater than 4096 bytes to "matched" relationship). Unmatched goes to error/failure.

**3. Splitting into Individual Camera Records**

The `getcameras` API likely returns a single JSON FlowFile containing data for many cameras. To process each camera individually, we use **SplitRecord** to break the monolithic FlowFile into separate FlowFiles, one for each camera record.

* **Processor:** `SplitRecord`
* **Purpose:** To transform a single FlowFile containing multiple camera records into multiple FlowFiles, each representing one camera.
* **Record Reader/Writer:** Configure with `JsonTreeReader` and `JsonRecordSetWriter` to handle JSON records.

**4. Extracting Camera Attributes**

Each camera record contains vital metadata like its unique ID, URL, location (latitude/longitude), and status. **EvaluateJsonPath** is used to parse JSON content and extract these key pieces of information and promote them to FlowFile attributes for easy access downstream.

* **Processor:** `EvaluateJsonPath`
* **Purpose:** To extract attributes like `url` (for the image stream), `Blocked`, `Disabled`, `latitude`, `longitude`, `roadwayname`, etc., from the JSON content.
* **Example JSONPath:** `$.imageUrl` for the camera's image URL, `$.isBlocked` for its status.

**5. Adding Randomness to URL Calls (Cache Busting)**

Some image URLs might be cached by intermediate systems. To ensure we always get the freshest image, we can append a random number to the URL as a cache-busting mechanism.

* **Processor:** `UpdateAttribute`
* **Purpose:** To generate a random number and append it to the camera's image URL.
* **Expression:** `${random():mod(9996565656):plus(3)}` (generates a random number)
* **Expression 2 (Build new URL):** `${url:append(${ending})}` (where `ending` is the attribute holding the random number prepended with a `?` or `&` depending on the original URL structure).

**6. Filtering Out Disabled Cameras**

Before attempting to download an image, we perform another check to ensure the camera is active and not disabled or blocked.

* **Processor:** `RouteOnAttribute`
* **Purpose:** To filter out cameras that are reported as `Blocked` or `Disabled` by the API.
* **Routing Rule:** `${Blocked:equalsIgnoreCase("False"):and(${Disabled:equalsIgnoreCase("False")})}` (Route to "matched" if both are false).

**7. Calling the Image URL for Each Camera**

With the validated and potentially randomized URL, we now use **InvokeHTTP** again, this time to download the actual image from the camera.

* **Processor:** `InvokeHTTP`
* **Purpose:** To download the live image for each active camera.
* **URL:** `${url2}` (the newly built URL with the random component).

**8. Filtering Out "Dead" Images**

Sometimes, camera streams might be down, leading to small or empty image files (e.g., placeholder "no signal" images). We filter these out based on content length.

* **Processor:** `RouteOnAttribute`
* **Purpose:** To discard FlowFiles that represent very small or potentially empty image files, indicating a dead stream.
* **Routing Rule:** `${Content-Length:le(15136)}` (Route FlowFiles with a content length less than or equal to 15136 bytes to "unmatched" or "dead\_images" relationship).

**9. Preparing the Image File for Storage**

To make the image file unique and traceable, we generate a new filename that includes a timestamp and an MD5 hash of the original content.

* **Processor:** `UpdateAttribute`
* **Purpose:** To create a unique and descriptive filename for the downloaded image.
* **Expression:** `cam.${filename:append(${now():format('yyyyMMddHHmmSS'):append(${md5}):append('.jpg')})}` (This creates a filename like `cam.someoriginalname202506091720121a2b3c4d5e.jpg`).

**10. Storing the Image Locally**

The downloaded and named image is then temporarily saved to the local filesystem. This is a common pattern before pushing to cloud storage or processing with local tools.

* **Processor:** `PutFile`
* **Purpose:** To write the downloaded image (FlowFile content) to a specified directory on the NiFi server's local file system.
* **Directory:** `/Users/tspann/Downloads/code/images/` (or your chosen temporary storage location).

**11. Sending Image to Slack (Initial Notification)**

For immediate visual inspection, the downloaded image is pushed to a Slack channel. This allows human operators to quickly see the current traffic conditions.

* **Processor:** `PublishSlack`
* **Purpose:** To send the downloaded traffic image as an attachment to a designated Slack channel.

---

### **Phase 2: AI Analysis with Snowflake Cortex AI**

The pipeline now shifts its focus to leveraging Snowflake's capabilities for AI processing.

**12. Pushing Image to Snowflake Internal Stage**

Before Snowflake Cortex AI can analyze the image, it needs to be accessible within Snowflake. We use an **ExecuteSQLRecord** processor to execute a `PUT` command, uploading the image from the local NiFi filesystem to a Snowflake internal stage.

* **Processor:** `ExecuteSQLRecord`
* **Purpose:** To upload the downloaded image from the local NiFi file system into a Snowflake internal stage.
* **SQL:** `PUT file:///Users/tspann/Downloads/code/images/${filename:trim()} @TRAFFIC AUTO_COMPRESS=FALSE;`

**13. Processing PUT Command Results**

The `PUT` command returns JSON output indicating the status of the upload (e.g., success, file size, target location). We need to parse this to get the `target` and `messages` from the result.

* **Processor 1:** `SplitRecord`
* **Purpose:** To ensure each `PUT` result is processed as a single record.
* **Processor 2:** `EvaluateJsonPath`
* **Purpose:** To extract attributes like `target` (the path in the stage) and `message` (upload status) from the `PUT` command's JSON output.
* **JSONPath:** `$.target`, `$.messages`

**14. Invoking Snowflake Cortex AI Stored Procedure**

This is the heart of the AI processing. We call a pre-defined Snowflake stored procedure, which presumably wraps a Cortex AI model. The stored procedure takes the staged image's path as an argument.

* **Processor:** `ExecuteSQLRecord`
* **Purpose:** To execute a Snowflake stored procedure that leverages Cortex AI to analyze the uploaded traffic image.
* **SQL:** `call DEMO.DEMO.ANALYZETRAFFICIMAGE('${pdffile}','${filename}','${uuid}');` (Note: `${pdffile}` might be a placeholder for the staged file path, or the `target` from the previous step. `${uuid}` ensures unique tracking.)

**15. Extracting AI Analysis Results**

The stored procedure returns JSON output containing the AI's analysis (e.g., traffic conditions, vehicle counts). We'll split this if necessary and then extract the relevant JSON blob.

* **Processor 1:** `SplitRecord`
* **Purpose:** To ensure each record from the stored procedure output is processed individually.
* **Processor 2:** `EvaluateJsonPath`
* **Purpose:** To extract the primary JSON result from the stored procedure's output.
* **JSONPath:** `$.ANALYZETRAFFICIMAGE` (assuming the result is nested under this key).

**16. Extracting Key AI Insights**

From the extracted AI analysis JSON, we pinpoint specific insights, such as `traffic_conditions`, and promote them to FlowFile attributes. This makes these insights easily accessible for downstream actions like database insertion or notifications.

* **Processor:** `EvaluateJsonPath`
* **Purpose:** To extract specific values from the AI analysis JSON, such as `traffic_conditions`.
* **JSONPath:** `$.traffic_conditions`

**17. Building a Comprehensive Metadata JSON**

Before storing the data, we consolidate all relevant metadata—including original camera details, image filename, Snowflake stage status, and AI analysis results—into a single, rich JSON object.

* **Processor:** `AttributesToJSON`
* **Purpose:** To combine various FlowFile attributes (from camera metadata, staging, and AI analysis) into a single JSON content.
* **Attributes to include:** `videoid`, `videoname`, `videourl`, `filename`, `directionoftravel`, `latitude`, `longitude`, `roadwayname`, `url2`, `ending`, `stagemessage`, `stagestatus`, `targetsize`, `uuid`, `traffic_conditions` (and any other relevant extracted attributes).

**18. Preparing for Database Insertion**

To insert this JSON record into a database, we ensure the FlowFile content is exactly the JSON string. **ExtractText** with a regular expression can achieve this if the content isn't already perfectly formatted.

* **Processor:** `ExtractText`
* **Purpose:** To ensure the FlowFile content is purely the JSON record, ready for database insertion.
* **Regular Expression:** `(?s)(^.*$)` (This captures the entire content of the FlowFile).

**19. Inserting into Snowflake Database**

The complete JSON record, containing all original metadata and AI analysis results, is now inserted into a dedicated table in Snowflake. The **PutDatabaseRecord** processor handles this.

* **Processor:** `PutDatabaseRecord`
* **Purpose:** To insert the comprehensive JSON record into a Snowflake table (e.g., `NYCTRAFFICIMAGES`).
* **Record Reader:** Configure with `JsonTreeReader` to interpret the incoming JSON.
* **Database Table Name:** `NYCTRAFFICIMAGES`

**20. Final Notification to Slack**

Finally, a summary of the AI analysis (e.g., "Traffic is heavy on Roadway X") along with the image is sent to Slack, providing a conclusive alert with all relevant details.

* **Processor:** `PublishSlack`
* **Purpose:** To send a comprehensive notification to Slack, including key AI insights (text) and the processed image (attachment).

**Conclusion:**

This Apache NiFi pipeline demonstrates a powerful and flexible approach to real-time AI-driven traffic monitoring. By seamlessly integrating with external APIs, leveraging Snowflake's cloud capabilities (internal stages and Cortex AI), and providing real-time alerts via Slack, organizations can build sophisticated smart city solutions that transform raw data into actionable insights, ultimately contributing to better urban planning and traffic management. This pipeline serves as an excellent blueprint for similar applications involving data ingestion, cloud AI integration, and notification.
