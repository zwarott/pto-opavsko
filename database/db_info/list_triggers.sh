#!/bin/bash

# Make the script executable by running the following command in the terminal
# chmod +x list_triggers.sh

# Define PostgreSQL connection parameters
HOST="localhost"
USERNAME="zwarott"
DATABASE="pto_opavsko"

# List all triggers 
# Add <<EOF EOF that allows to include a block of SQL query
# in more readable way
psql -h "$HOST" -U "$USERNAME" -d "$DATABASE"  <<EOF
  SELECT
    tgname as trigger_name
  FROM
    pg_trigger
  ORDER BY trigger_name;
EOF
