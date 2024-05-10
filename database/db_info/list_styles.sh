#!/bin/bash

# List tables that have stored layer styles
# In psql: \d public.layer_styles

# Make the script executable by running the following command in the terminal
# chmod +x list_styles.sh

# Define PostgreSQL connection parameters
HOST="localhost"
USERNAME="zwarott"
DATABASE="pto_opavsko"

# List all styles 
# Add <<EOF EOF that allows to include a block of SQL query
# in more readable way
psql -h "$HOST" -U "$USERNAME" -d "$DATABASE"  <<EOF
  SELECT
    f_table_schema AS schema,
    f_table_name AS table,
    stylename AS style,
    useasdefault AS default_style,
    update_time AS updated,
    type
  FROM
    public.layer_styles;
EOF
