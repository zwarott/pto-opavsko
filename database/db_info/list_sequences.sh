#!/bin/bash
# Make the script executable by running the following command in the terminal
# chmod +x list_sequences.sh

# Define PostgreSQL connection parameters
HOST="localhost"
USERNAME="zwarott"
DATABASE="pto_opavsko"

# List all sequences 
# Implement <<EOF EOF allow implement block of SQL query
# in more readable way
psql -h "$HOST" -U "$USERNAME" -d "$DATABASE"  <<EOF
  SELECT
    seq.sequence_schema,
    seq.sequence_name
  FROM
    information_schema.sequences AS seq
  ORDER BY
    sequence_schema;
EOF
