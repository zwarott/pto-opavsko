#!/bin/sh
# Make the script executable by running the following command in the terminal
# chmod +x audit_from_to.sh

# Check if all three arguments are provided
# If not (arguments '#$' are not equal '-ne' to 3), it prints: 'Usage: ./audit_from_to.sh <from> <to> <table'

if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <table> <from> <to>"
    exit 1
fi

# Define PostgreSQL connection parameters
HOST="localhost"
USERNAME="zwarott"
DATABASE="pto_opavsko"

# Assign arguments to variables
TABLE="$1"
FROM="$2"
TO="$3"

# Show me changes in selected table from specific date to specific date
# Need to use single quotes to converts arguments into strings
# lower(valid_range) refers to the first timestamp in tstzrange
# upper(valid_range) refers to the second timestamp in tstzrange
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
    delka_gis,
    valid_range
  FROM 
    audit.${TABLE}_history
  WHERE
  tstzrange('$FROM', '$TO', '[)') && valid_range AND
      (
        lower(valid_range) >= '$FROM'::timestamp OR
        upper(valid_range) <= '$TO'::timestamp
      )
  ORDER BY
    hid DESC;
EOF
