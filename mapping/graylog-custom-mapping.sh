curl -H 'Content-Type: application/json' \
     -X PUT \
     -d @'graylog-custom-mapping.json' \
     'http://localhost:9200/_template/graylog-custom-mapping?pretty'
