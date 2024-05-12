#!/bin/sh
# Make the script executable by running the following command in the terminal
# chmod +x raster_info.sh

# Check if both arguments are provided
# If not (arguments '#$' are not equal '-ne' to 2), it prints: 'Usage: ./import_raster.sh <input_raster> <raster_table>'
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

raster2pgsql -s "$EPSG" -I -C -M "$INPUT_RASTER" "{$TARGET_SCHEMA}"."{$RASTER_TABLE}" | psql -h "$HOST" -d "$DBNAME" -U "$USER"
