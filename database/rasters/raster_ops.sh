#!/bin/bash

# Ensure the script is executable by running: chmod +x raster_ops.sh

# Check if no arguments are provided
if [ "$#" -ne 0 ]; then
    echo "Usage: $0"
    exit 1
fi

# Define PostgreSQL connection parameters
DB_NAME="pto_opavsko"
HOST="localhost"
USER="zwarott"

# Function to perform the spatial analysis and update the ops column
process_table() {
    # Set local variable executable within function only 
    local RASTER_TABLE=$1

    # SQL commands to perform the spatial analysis and update the ops column
    SQL_COMMANDS=$(cat <<EOF
    -- Update the ops column in raster_metadata table based on spatial analysis
    UPDATE 
      public.raster_metadata rm
    -- Create concatanated string of distinct ops values that intersect with the specific raster table 
    SET ops = (
        SELECT 
          string_agg(DISTINCT ps.ops, ', ')
        FROM 
          main.pozice_srubu_main ps
        WHERE 
          ST_Intersects(ps.geom, (SELECT ST_Union(rast) FROM rasters."$RASTER_TABLE"))
    )
    WHERE 
      rm.name = '$RASTER_TABLE';
EOF
    )

    # Connect to the database and execute the SQL commands
    # -v ON_ERROR_STOP=1 | stop executing further commands if an error occurs
    psql -v ON_ERROR_STOP=1 -U $USER -d $DB_NAME -h "$HOST" <<EOF
    $SQL_COMMANDS
EOF

    # Check the result of the psql command and print an appropriate message
    if [ $? -eq 0 ]; then
        echo "Successfully updated ops column in raster_metadata table for raster '$RASTER_TABLE'."
    else
        echo "Failed to update ops column in raster_metadata table for raster '$RASTER_TABLE'."
        exit 1
    fi
}

# Get the list of raster tables in the "rasters" schema
# -t | tuples only (data without column names, row count footer or another metadata)
# -c | specify command to be executed
# 'BASE TABLE' | include regulat rables only (excluding views etc.)
RASTER_TABLES=$(psql -U $USER -d $DB_NAME -h "$HOST" -t -c "SELECT table_name FROM information_schema.tables WHERE table_schema = 'rasters' AND table_type = 'BASE TABLE'")

# Iterate over each raster table and process it
for RASTER_TABLE in $RASTER_TABLES; do
    # Call the function to process the raster table
    process_table "$RASTER_TABLE"
done
