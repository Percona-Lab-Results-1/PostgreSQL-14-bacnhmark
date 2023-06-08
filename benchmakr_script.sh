#!/bin/bash

# Benchmark script for PostgreSQL 11, 12, and 13

# Set the parameters
HOST="localhost"
PORT=5432
DB_NAME="your_database_name"
USER="your_username"
PASSWORD="your_password"
THREADS=4
TIME=60

# Function to run the benchmark for a specific version of PostgreSQL
run_benchmark() {
    local VERSION=$1

    echo "Running benchmark for PostgreSQL ${VERSION}..."
    echo "=============================================="

    # Set the appropriate environment variables based on the version
    case $VERSION in
        11)
            export PATH="/path/to/postgresql-11/bin:$PATH"
            ;;
        12)
            export PATH="/path/to/postgresql-12/bin:$PATH"
            ;;
        13)
            export PATH="/path/to/postgresql-13/bin:$PATH"
            ;;
        *)
            echo "Unsupported PostgreSQL version!"
            exit 1
            ;;
    esac

    # Initialize the database
    initdb -D "/path/to/data_directory"

    # Start the PostgreSQL server
    pg_ctl -D "/path/to/data_directory" -l logfile start

    # Create the benchmark database
    createdb -h $HOST -p $PORT -U $USER $DB_NAME

    # Load the sample data (if needed)
    # pgbench -h $HOST -p $PORT -U $USER -i $DB_NAME

    # Run the benchmark
    pgbench -h $HOST -p $PORT -U $USER -t $THREADS -c $THREADS -T $TIME $DB_NAME

    # Stop the PostgreSQL server
    pg_ctl -D "/path/to/data_directory" stop

    echo "Benchmark for PostgreSQL ${VERSION} completed!"
    echo "=============================================="
    echo
}

# Run the benchmark for each version
run_benchmark 11
run_benchmark 12
run_benchmark 13

