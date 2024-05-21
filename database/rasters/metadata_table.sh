#!/bin/bash

# Make the script executable by running the following command in the terminal
# chmod +x metadata_table.sh

# Terminate the script if any command fails
set -e

# Check if both arguments are provided
# "$#" represents the numebr of positional parameters (arguments) passed to the script
# -ne | not equal
# $0  | special variable that contains the name if the script itself
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <input_file> <target_schema> <new_table>"
    exit 1
fi

# Assign arguments
INPUT_FILE="$1"
TARGET_SCHEMA="$2"
NEW_TABLE="$3"

# Define PostgreSQL connection parameters
DB_NAME="pto_opavsko"
HOST="localhost"
USER="zwarott"

# Ensure the input file exists and is readable
if [ ! -f "$INPUT_FILE" ]; then
    echo "Error: Input file '$INPUT_FILE' does not exist or is not readable."
    exit 1
fi

# Connect to the database and run the SQL commands within a single psql session to ensure atomic execution
# -v ON_ERROR_STOP=1 | stop executing further commands if an error occurs
psql -v ON_ERROR_STOP=1 -U $USER -d $DB_NAME -h "$HOST" <<EOF
BEGIN;

CREATE TABLE $TARGET_SCHEMA.$NEW_TABLE (
    name VARCHAR(255),
    code VARCHAR(255),
    territory VARCHAR(255),
    year INTEGER,
    scale INTEGER,
    transformation VARCHAR(255),
    resampling VARCHAR(255),
    compression VARCHAR(255),
    rmse DOUBLE PRECISION,
    ops VARCHAR(255)
);

COPY $TARGET_SCHEMA.$NEW_TABLE(name, code, territory, year, scale, transformation, resampling, compression, rmse, ops)
FROM '$(realpath $INPUT_FILE)'
DELIMITER ','
CSV HEADER;

COMMIT;
EOF

# Check for any errors during execution
if [ "$?" -eq 0 ]; then
    echo "Data imported successfully into $TARGET_SCHEMA.$NEW_TABLE."
else
    echo "Error during data import. Please check the input file and database connection parameters."
    exit 1
fi
