#!/bin/bash

# Make the script executable by running the following command in the terminal
# chmod +x import_rasters.sh

# Exit immediately if any command returns a non-zero status (if eny error occurs)
set -e

# Check if the correct number of arguments is provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <raster_dir> <target_schema>"
    exit 1
fi

# Assign the arguments to variables
RASTER_DIR="$1"
TARGET_SCHEMA="$2"

# Define PostgreSQL connection parameters
HOST="localhost"
DBNAME="pto_opavsko"
USER="zwarott"

# Define raster parameters
EPSG="5514"

# Check if the directory exists
if [ ! -d "$RASTER_DIR" ]; then
    echo "Directory $RASTER_DIR does not exist."
    exit 1
fi

# Check if the directory is empty
if [ -z "$(ls -A "$RASTER_DIR")" ]; then
    echo "Directory $RASTER_DIR is empty."
    exit 1
fi

# Start timing
# Capture current data + seconds with nanosecond precision
start_time=$(date +%s.%N)


# Find all TIF files in the directory and iterate over them
find "$RASTER_DIR" -type f -name "*.tif" -print0 | while IFS= read -r -d '' RASTER_FILE; do
    # Extract raster file name without extension
    RASTER_NAME=$(basename "$RASTER_FILE" .tif)

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
    NODATA_VALUE=$(gdalinfo -nomd -norat -noct -nogcp -nofl -stats "$RASTER_FILE" | grep "NoData Value" | sed 's/.*= \(.*\)/\1/')

    # Import raster with NODATA value set to a value that doesn't occur naturally in the raster
    # Set NODATA_VALUE to a specific value (e.g., -9999) that doesn't exist in your raster
    # -s | use srid <EPSG>
    # -I | create spatial index
    # -C | use standard raster constraints (pixel size, srid) - to ensure raster is properly registered in "raster_column" view
    # -M | vacuum analayze the raster table
    # -N | specify <NODATA_VALUE> for import operation
    # -t | cut raster into tiles to be inserted one per table row, put "auto" to allow the loader to compute an appropriate tile size
    raster2pgsql -s "$EPSG" -I -C -M -N "$NODATA_VALUE" "$RASTER_FILE" -t "auto" "$TARGET_SCHEMA.$RASTER_NAME" | psql -h "$HOST" -d "$DBNAME" -U "$USER"
    
    echo "Raster $RASTER_NAME imported successfully."
done

# End timing (similar as start timing)
end_time=$(date +%s.%N)

# Calculate the difference between the start time and end time to get the execution time of the script
# bc = basic calculator utility
execution_time=$(echo "$end_time - $start_time" | bc)

# Print execution time
echo "Total execution time: $execution_time seconds"
