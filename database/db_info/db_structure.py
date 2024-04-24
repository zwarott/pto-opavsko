from __future__ import unicode_literals

import psycopg2
from treelib import Tree


def fetch_schema_table_info():
    """
    Function to fetch schema and table information from PostgreSQL database.
    
    Execute command
    ---------------
    pg_catalog.pg_class
        A table that contains information about tables and other relations.
    pg_catalog.pg_namespace
        A table that contains information about namespaces, which are 
    essentially schemas in PostgreSQL.

    The JOIN clause combines rows from two or more tables based on a related 
    column between them. n this case, it joins the pg_class table (c) with 
    the pg_namespace table (n) based on the oid (object identifier).

    c.relkind IN ('r', 'v', 'm')
        This condition filters for relations (r), views (v), and materialized 
        views (m). It excludes other types of relations.
    n.nspname NOT LIKE 'pg_%'
        This condition excludes schemas whose names start with "pg_".
    n.nspname <> 'information_schema
        This condition excludes the "information_schema" schema.

    Retruns
    -------
        List of tuples representing schema name and table name.
    """
    # Connect to an existing database
    conn = psycopg2.connect(
        database="pto_opavsko", 
        user="zwarott", 
        host="localhost",
        port="5432"
    )

    # Open a cursor to perform database operations
    cur = conn.cursor()

    # Execute a command: this crates tuples (schema, table)
    cur.execute("""
        SELECT
            n.nspname AS schema_name,
            c.relname AS table_name
        FROM
            pg_catalog.pg_class c
        JOIN 
            pg_catalog.pg_namespace n ON n.oid = c.relnamespace
        WHERE
            c.relkind IN ('r', 'v', 'm')
            AND n.nspname NOT LIKE 'pg_%'
            AND n.nspname <> 'information_schema'
        ORDER BY
            n.nspname,
            c.relname;
    """)

    # Fetch all rows of a query result and return them as a list of tuples
    rows = cur.fetchall()

    # Close communication with the database
    cur.close()
    conn.close()
    return rows


def build_tree(schema_table_data: list):
    """
    Function to build PostgreSQL database tree structure.

    Parameters
    ----------
    schema_table_data: list
        List of tuples representing schema name and table
        name.

    Returns
    -------
        Tree-like database structure.
    """
    
    # Define tree-like structure based on Node objects.
    tree = Tree()

    # Root variable: database name
    root = "pto_opavsko"
    # Define root
    tree.create_node(tag=root, identifier=root)
    
    # Assing schemas and tables to tree-like db structure 
    for schema, table in schema_table_data:
        # If schema is not included in tree-like db structure, create a new
        # node as a root's child
        if not tree.get_node(schema):
            tree.create_node(tag=schema, identifier=schema, parent=root)
        # Then assign table to created schemas as root's grandchild 
        tree.create_node(tag=table, identifier=table, parent=schema)

    return tree


if __name__ == "__main__":
    # Fetch schema and table information
    schema_table_info = fetch_schema_table_info()

    # Build the tree structure
    database_tree = build_tree(schema_table_info)

    # Show the tree structure
    print(database_tree)
