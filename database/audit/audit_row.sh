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

# Define PostgreSQL connection parameters
HOST="localhost"
USERNAME="zwarott"
DATABASE="pto_opavsko"

# Show me history of specific row/record (feature) within selected table 
# Need to use single quotes to converts arguments into strings
# Add <<EOF EOF that allows to include a block of SQL query
# in more readable way
psql -h "$HOST" -U "$USERNAME" -d "$DATABASE"  <<EOF
  SELECT 
    hid,
    fid,
    ops,
    kategorie,
    stav,
    provedeni,
    kat_vp,
    poznamka,
    delka_gis,
    delka_vp,
    delka_sv,
    valid_range
  FROM 
    audit.${TABLE}_history
  WHERE
    fid = $FID 
  ORDER BY
    hid DESC;
EOF
