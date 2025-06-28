CREATE OR REPLACE TABLE transit_alerts (
    title VARCHAR(255),
    description VARCHAR(1000),
    link VARCHAR(255),
    guid VARCHAR(255),
    advisoryAlert VARCHAR(255),
    pubDate TIMESTAMP,
    alert_message_components VARIANT,
    ts BIGINT,
    companyname VARCHAR(50),
    uuid VARCHAR(36),
    servicename VARCHAR(50),
    raw_json VARIANT,
    created_at TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP()
);
