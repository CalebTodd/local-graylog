Used to configure a local Graylog server for parsing and enabling search capabilities for a local set of standardized logs.

# Resource Dependencies
This design is to support a processing capacity of around 1M logs over a minute or less and has been tuned with a generously outfitted laptop (OSX; 2.2 GHz Intel Core i7; 32 GB 2400 MHz DDR4). To run this Docker Compose file, some configuration updates to the basic Docker setup are required.

## Docker Desktop
- 9 CPUs
- 12 GB memory
- 1 GB SWAP

This has been done to increase . The Docker Compose file has been adjusted for the following resources

### Elasticsearch
- scheduled to use CPUs 1-4
- 2 GB memory reserved; 3 GB memory limit

### Graylog
- scheduled to use CPUs 5-7
- 1500 MB memory reserved

# Content Packs
While Graylog may accept logs of a given type (via GELF) it doesn't always have the ability to make sense out of them. In cases where a log standard exists and searchability of specific fields is desired, a Content Pack is the way to approach this. This allows Graylog to parse a GELF log into relevant fields.

## Custom Mapping
It may be that an additional Elasticsearch custom mapping may be required to facilitate searching of the custom fields. Simple searching tends to be available -- e.g. `NEW_FIELD_1: "foo"` -- but complex searches tend to reveal this requirement -- `NEW_FIELD_1: "foo" ANDNEW_FIELD_2: "bar"`. This does not bootstrap at the moment. However, see `./mapping/` for an example using AWS ELB Logs.

## ELB Log Pattern
```
ELB_TIMESTAMP - %{TIMESTAMP_ISO8601}
ELB_NAME - %{NOTSPACE}
ELB_CLIENT_PORT - %{HOSTPORT}
ELB_BACKEND_PORT - %{HOSTPORT}
ELB_REQUEST_PROCESSING_TIME - %{NOTSPACE}
ELB_BACKEND_PROCESSING_TIME - %{NOTSPACE}
ELB_RESPONSE_PROCESSING_TIME - %{NOTSPACE}
ELB_STATUS_CODE - %{INT}
ELB_BACKEND_STATUS_CODE - %{INT}
ELB_RECEIVED_BYTES - %{INT}
ELB_SENT_BYTES - %{INT}
ELB_REQUEST - %{QUOTEDSTRING}
ELB_USER_AGENT - %{QUOTEDSTRING}
ELB_SSL_CIPHER - %{NOTSPACE}
ELB_SSL_PROTOCOL - %{NOTSPACE}
```

Graylog Extractor Grok Pattern
```%{ELB_TIMESTAMP} %{ELB_NAME} %{ELB_CLIENT_PORT} %{ELB_BACKEND_PORT} %{ELB_REQUEST_PROCESSING_TIME} %{ELB_BACKEND_PROCESSING_TIME} %{ELB_RESPONSE_PROCESSING_TIME} %{ELB_STATUS_CODE} %{ELB_BACKEND_STATUS_CODE} %{ELB_RECEIVED_BYTES} %{ELB_SENT_BYTES} %{ELB_REQUEST} %{ELB_USER_AGENT} %{ELB_SSL_CIPHER} %{ELB_SSL_PROTOCOL}```

## ALB Log Pattern
```
%{TIMESTAMP_ISO8601:log_timestamp}
%{NOTSPACE:elb-name}
%{NOTSPACE:elb-client}
%{NOTSPACE:elb-target}
%{NOTSPACE:request_processing_time:float}
%{NOTSPACE:target_processing_time:float}
%{NOTSPACE:response_processing_time:float}
%{NOTSPACE:elb_status_code}
%{NOTSPACE:target_status_code}
%{NOTSPACE:received_bytes:float}
%{NOTSPACE:sent_bytes:float}
%{QUOTEDSTRING:request}
%{QUOTEDSTRING:user_agent}
%{NOTSPACE:ssl_cipher}
%{NOTSPACE:ssl_protocol}
%{NOTSPACE:target_group_arn}
%{QUOTEDSTRING:trace_id}
```