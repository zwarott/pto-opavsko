#!/bin/bash
# Make the script executable by running the following command in the terminal
# chmod +x drop_schema_views.sh

# Check if the schema name is provided as an argument
if [ "$#" -eq 0 ]; then
    echo "Usage: $0 <target_schema>"
    exit 1
fi

# Assign the first argument to the variable TARGET_SCHEMA
TARGET_SCHEMA="$1"

# Define PostgreSQL connection parameters
HOST="localhost"
USER="zwarott"
DATABASE="pto_opavsko"

# Start timing
# Capture current data + seconds with nanosecond precision
start_time=$(date +%s.%N)

# Drop all views within the target schema
# Use the <<-EOF syntax to allow indentation within the here-document
psql -h "$HOST" -U "$USER" -d "$DATABASE"  <<-EOF
  DO \$\$ 
  DECLARE
      view_record RECORD;
  BEGIN
      FOR view_record IN
          SELECT table_schema, table_name
          FROM information_schema.views
          WHERE table_schema = '$TARGET_SCHEMA' 
      LOOP
          EXECUTE format('DROP VIEW IF EXISTS %I.%I CASCADE;', view_record.table_schema, view_record.table_name);
          RAISE NOTICE 'Dropped view: %', view_record.table_name;
      END LOOP;
  END \$\$;
EOF

# End timing (similar as start timing)
end_time=$(date +%s.%N)

# Calculate the difference between the start time and end time to get the execution time of the script
# bc = basic calculator utility
execution_time=$(echo "$end_time - $start_time" | bc)

# Print execution time
echo "Total execution time: $execution_time seconds"

