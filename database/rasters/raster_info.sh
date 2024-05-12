#!/bin/bash
# Make the script executable by running the following command in the terminal
# chmod +x raster_info.sh

# Check if the table name is provided as an argument
# If not (argument '#$' is equal '-eq' to 0), it prints: 'Usage: ./raster_info.sh <table_name>'
# If table does not exist, an error message is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <table_name>"
    exit 1
fi

# Assign the first argument to the variable TABLE_NAME
TABLE_NAME="$1"

# Define PostgreSQL connection parameters
HOST="localhost"
PORT="5432"
DBNAME="pto_opavsko"
USER="zwarott"
SCHEMA="rasters"

# Build the GDAL command with the variable table name
gdalinfo "PG:host=$HOST port=$PORT dbname='$DBNAME' user='$USER' schema='$SCHEMA' table='$TABLE_NAME'"
