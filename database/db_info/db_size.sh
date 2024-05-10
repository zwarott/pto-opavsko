#!/bin/bash
# Make the script executable by running the following command in the terminal
# chmod +x db_size.sh

# Define PostgreSQL connection parameters
HOST="localhost"
USERNAME="zwarott"
DATABASE="pto_opavsko"

# Show database size 
# Add <<EOF EOF that allows to include a block of SQL query
# in more readable way
psql -h "$HOST" -U "$USERNAME" -d "$DATABASE"  <<EOF
  SELECT 
    datname AS database_name,
    pg_size_pretty(pg_database_size(datname)) AS database_size
  FROM 
    pg_database
  WHERE 
    datname = 'pto_opavsko'; 
EOF
