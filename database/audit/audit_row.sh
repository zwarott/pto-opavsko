#!/bin/sh
# Make the script executable by running the following command in the terminal
# chmod +x audit_row.sh

# Check if arguments are provided
# If not (arguments'#$' is not equal '-ne' to 2), it prints: 'Usage: ./audit_row.sh <table> <fid>'
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <table> <fid>"
    exit 1
fi

# Assign arguments to variables
TABLE="$1"
FID="$2"

# Define the column to exclude
COLUMN_TO_EXCLUDE="geom"

# Define PostgreSQL connection parameters
HOST="localhost"
USERNAME="zwarott"
DATABASE="pto_opavsko"

# Get the list of columns excluding the specific column
COLUMNS=$(psql -h "$HOST" -U "$USERNAME" -d "$DATABASE" -t -c "
  SELECT string_agg(column_name, ', ')
  FROM information_schema.columns
  WHERE table_name = '${TABLE}_history' AND column_name != '$COLUMN_TO_EXCLUDE'
")

# Show the history of a specific row/record (feature) within the selected table
psql -h "$HOST" -U "$USERNAME" -d "$DATABASE"  <<EOF
  SELECT 
    $COLUMNS
  FROM 
    audit.${TABLE}_history
  WHERE
    fid = $FID 
  ORDER BY
    hid DESC;
EOF
