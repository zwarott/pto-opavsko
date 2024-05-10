#!/bin/bash

# Make the script executable by running the following command in the terminal
# chmod +x list_tables.sh

# Define PostgreSQL connection parameters
HOST="localhost"
USERNAME="zwarott"
DATABASE="pto_opavsko"

# List all tables 
# Add <<EOF EOF that allows to include a block of SQL query
# in more readable way
psql -h "$HOST" -U "$USERNAME" -d "$DATABASE"  <<EOF
  SELECT 
      n.nspname AS schema_name,
      c.relname AS table_name
  FROM 
      pg_catalog.pg_class c
  JOIN 
      pg_catalog.pg_namespace n ON n.oid = c.relnamespace
  WHERE 
      c.relkind IN ('r', 'v', 'm')
      AND n.nspname NOT LIKE 'pg_%'
      AND n.nspname <> 'information_schema'
  ORDER BY
      schema_name;
EOF
