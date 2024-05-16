#!/bin/bash

# Make the script executable by running the following command in the terminal
# chmod +x list_schema_tables.sh

# Check if schema name argument is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <target_schema>"
    exit 1
fi

# Assign the schema name argument to a variable
TARGE_SCHEMA="$1"

# Define PostgreSQL connection parameters
HOST="localhost"
USERNAME="zwarott"
DATABASE="pto_opavsko"

# Execute SQL query to list tables in the specified schema
# Add <<EOF EOF that allows to include a block of SQL query
# in more readable way
psql -h "$HOST" -U "$USERNAME" -d "$DATABASE"  <<EOF
  SELECT 
    table_name 
  FROM 
    information_schema.tables 
  WHERE 
    table_schema = '$TARGET_SCHEMA'
  ORDER BY
    table_name;
EOF
