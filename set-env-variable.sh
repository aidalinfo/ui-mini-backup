#!/bin/sh

# Inject environment variables into the placeholder
JSON_STRING='window.configs = { \
  "API_URL": "'"${API_URL}"'", \
}'

# Replace the placeholder in index.html with actual environment variables
sed -i "s@// CONFIGURATIONS_PLACEHOLDER@${JSON_STRING}@" /usr/share/nginx/html/index.html

# Execute the original entrypoint
exec "$@"
