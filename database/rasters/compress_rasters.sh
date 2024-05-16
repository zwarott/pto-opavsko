#!/bin/bash

# Make the script executable by running the following command in the terminal
# chmod +x import_rasters.sh

# Exit immediately if any command returns a non-zero status (if eny error occurs)
set -e

# Check if the correct number of arguments is provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <SOURCE_DIR> <DEST_DIR>"
    exit 1
fi

# Assign the arguments to variables
SOURCE_DIR="$1"
DEST_DIR="$2"

# Check if source directory exists
if [ ! -d "$SOURCE_DIR" ]; then
  echo "Source directory does not exist."
  exit 1
fi

# Check if destination directory exists, if not create it
if [ ! -d "$DEST_DIR" ]; then
  mkdir -p "$DEST_DIR"
fi

# Start timing
# Capture current data + seconds with nanosecond precision
start_time=$(date +%s.%N)

# Iterate over each raster file in the source directory
for RASTER_FILE in "$SOURCE_DIR"/*.tif; do
    # Check if the file is a raster file
    if [ -f "$RASTER_FILE" ]; then
        # Get the filename without extension
        FILENAME=$(basename -- "$RASTER_FILE")
        FILENAME_NO_EXT="${FILENAME%.*}"
        
        # Compress the raster file using LZW compression
        COMPRESSED_RASTER="$DEST_DIR/$FILENAME_NO_EXT".tif
        gdal_translate -co COMPRESS=LZW "$RASTER_FILE" "$COMPRESSED_RASTER"
        
        # Print status
        echo "Raster file '$RASTER_FILE' compressed and saved as '$COMPRESSED_RASTER'"
    fi
done

echo "Compression complete."

# End timing (similar as start timing)
end_time=$(date +%s.%N)

# Calculate the difference between the start time and end time to get the execution time of the script
# bc = basic calculator utility
execution_time=$(echo "$end_time - $start_time" | bc)

# Print execution time
echo "Total execution time: $execution_time seconds"

