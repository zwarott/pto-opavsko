#!/bin/sh
# Make the script executable by running the following command in the terminal
# chmod +x audit_under.sh

# Check if arguments are provided
# If not (arguments'#$' is not equal '-ne' to 2), it prints: 'Usage: ./audit_under.sh <table> <to>'
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <table> <to>"
    exit 1
fi

# Assign arguments to variables
TABLE="$1"
TO="$2"

# Define PostgreSQL connection parameters
HOST="localhost"
USERNAME="zwarott"
DATABASE="pto_opavsko"

# Show me changes in selected table to specific date
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
  delka_gis,
  valid_range
FROM 
  audit.${TABLE}_history
WHERE
  lower(valid_range) <= '$TO'::timestamp AND
  upper(valid_range) <= '$TO'::timestamp
ORDER BY
  hid DESC;
EOF
