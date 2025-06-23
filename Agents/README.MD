### Snowflake Cortex AI Agents



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



### References

* https://docs.cursor.com/context/model-context-protocol
