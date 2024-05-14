#!/bin/bash
# Make the script executable by running the following command in the terminal
# chmod +x import_raster.sh

# Check if both arguments are provided
# If not (arguments '$#' are not equal '-ne' to 2), it prints: 'Usage: ./import_raster.sh <input_raster> <raster_table>'
# If import raster does not exist, an error message is provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <input_raster> <raster_table>"
    exit 1
fi

# Assign arguments
INPUT_RASTER="$1"
RASTER_TABLE="$2"

# Define PostgreSQL connection parameters
HOST="localhost"
DBNAME="pto_opavsko"
USER="zwarott"

# Define raster parameters
EPSG="5514"
TARGET_SCHEMA="rasters"

# Start timing
# Capture current data + seconds with nanosecond precision
start_time=$(date +%s.%N)

# Find the NODATA value of the input raster using series of commands concatened with pipes ("|")
#
# At first, we need to supress some information from gdalinfo utility
# -nomd  | supress metadata output
# -norat | supress Raster Attribute Table (RAT) output
# -noct  | supress color table output
# -nogcp | supress Ground Control Point (GCP) output
# -nofl  | supress file list output
# -stats | supress raster statistics
#
# Then, filter "NoData Value" of raster only
#
# Finally, extract the Nodata value fro mthe filtered output using regex
# s/      | indicates a substitution operation
# .*=     | matches any characters followed by an equal sign
# \(.*\)/ | parentheses \( \) capture the value inside them
# \1      | refers to the captured value
NODATA_VALUE=$(gdalinfo -nomd -norat -noct -nogcp -nofl -stats "$INPUT_RASTER" | grep "NoData Value" | sed 's/.*= \(.*\)/\1/')

# Import raster with NODATA value set to a value that doesn't occur naturally in the raster
# Set NODATA_VALUE to a specific value (e.g., -9999) that doesn't exist in your raster
# -s | use srid <EPSG>
# -I | create spatial index
# -C | use standard raster constraints (pixel size, srid) - to ensure raster is properly registered in "raster_column" view
# -M | vacuum analayze the raster table
# -N | specify <NODATA_VALUE> for import operation
# -t | cut raster into tiles to be inserted one per table row, put "auto" to allow the loader to compute an appropriate tile size
raster2pgsql -s "$EPSG" -I -C -M -N "$NODATA_VALUE" "$INPUT_RASTER" -t "auto" "$TARGET_SCHEMA"."$RASTER_TABLE" | psql -h "$HOST" -d "$DBNAME" -U "$USER"

# End timing (similar as start timing)
end_time=$(date +%s.%N)

# Calculate the difference between the start time and end time to get the execution time of the script
# bc = basic calculator utility
execution_time=$(echo "$end_time - $start_time" | bc)

# Print execution time
echo "Total execution time: $execution_time seconds"
