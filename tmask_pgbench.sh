#!/bin/bash
## pgbench

# __author__ = "biuro@tmask.pl"
# __copyright__ = "Copyright (C) 2022 TMask.pl"
# __license__ = "MIT License"
# __version__ = "1.0"

NAME=`date +%Y%m%d_%H%M`

SEC=600

echo "Start TMask.pl Stress Test Postgres pgbench - $NAME"

# psql -c "CREATE DATABASE bench"
# psql -c "CREATE DATABASE bench1"
# psql -c "CREATE DATABASE bench2"



# Buffer test: 
echo "Buffer test"
    pgbench -i -s 70 bench2
sleep 5
# Read-Write Test
echo "Read-Write Test"
NAME=`date +%Y%m%d_%H%M`
    pgbench -c 4 -j 2 -T $SEC bench2 > Read-Write_$NAME.txt
    cat Read-Write_$NAME.txt | grep "tps"
sleep 5
# Read-Only Test
echo "Read-Only Test"
NAME=`date +%Y%m%d_%H%M`
    pgbench -c 4 -j 2 -T $SEC -S bench2 > Read-Only_$NAME.txt
    cat Read-Only_$NAME.txt | grep "tps"
sleep 5
# Simple Write Test
echo "Simple Write Test"
NAME=`date +%Y%m%d_%H%M`
    pgbench -c 4 -j 2 -T $SEC -N bench2 > Write_Only_$NAME.txt
    cat Write_Only_$NAME.txt | grep "tps"
sleep 5

# Connections and Contention

# For this series of tests, we want to test how PostgreSQL behaves with different levels of connection activity. In this case, it's very relative to how many cores you have. Again, we're assuming the same 2-core, 2GB machine.

# Unfortunately, you can only do this test effectively from another machine which has at least as many cores as the database server.

# All tests start with:
echo "Connections and Contention"
    pgbench -i -s 30 bench
sleep 5
# Single-Threaded
echo "Single-Threaded"
NAME=`date +%Y%m%d_%H%M`
    pgbench -c 1 -T $SEC bench > Single-Threaded_$NAME.txt
    cat Single-Threaded_$NAME.txt | grep "tps"
sleep 5
# Normal Load
echo "Normal Load"
NAME=`date +%Y%m%d_%H%M`
    pgbench -c 8 -j 2 -T $SEC bench > Normal_Load_$NAME.txt
    cat Normal_Load_$NAME.txt | grep "tps"
sleep 5
# Heavy Contention
echo "Heavy Contention"
NAME=`date +%Y%m%d_%H%M`
    pgbench -c 64 -j 4 -T $SEC bench > Heavy_Contention_$NAME.txt
    cat Heavy_Contention_$NAME.txt | grep "tps"
sleep 5
# Heavy Connections without Contention
echo "Heavy Connections without Contention"
NAME=`date +%Y%m%d_%H%M`
    pgbench -c 64 -j 4 -T $SEC -N bench > Heavy_Connections_without_Contention_$NAME.txt
    cat Heavy_Connections_without_Contention_$NAME.txt | grep "tps"
sleep 5

# Heavy Re-connection (simulates no connection pooling)
echo "Heavy Re-connection (simulates no connection pooling)"
NAME=`date +%Y%m%d_%H%M`
    pgbench -c 8 -j 2 -T $SEC -C bench > Heavy_Re-connection_$NAME.txt
    cat Heavy_Re-connection_$NAME.txt | grep "tps"

sleep 5

# Prepared vs. Ah-hoc Queries

# pgBench 9.0 also allows you to test the effect of prepared queries on performance. Assumes the same database server as above.

# Initialize with:
echo "Prepared vs. Ah-hoc Queries"
    pgbench -i -s 70 bench
sleep 5
# Unprepared, Read-Write:
echo "Unprepared, Read-Write:"
NAME=`date +%Y%m%d_%H%M`
    pgbench -c 4 -j 2 -T $SEC bench > Unprepared_Read-Write_$NAME.txt
    cat Unprepared_Read-Write_$NAME.txt | grep "tps"
sleep 5
# Prepared, Read-Write:
echo "Prepared, Read-Write:"
NAME=`date +%Y%m%d_%H%M`
    pgbench -c 4 -j 2 -T $SEC -M prepared bench > Prepared_Read-Write_$NAME.txt
    cat Prepared_Read-Write_$NAME.txt | grep "tps"
sleep 5
# Unprepared, Read-Only:
echo "Unprepared, Read-Only:"
NAME=`date +%Y%m%d_%H%M`
    pgbench -c 4 -j 2 -T $SEC -S bench > Unprepared_Read-Only_$NAME.txt
    cat Unprepared_Read-Only_$NAME.txt | grep "tps"
sleep 5
# Prepared, Read-Only:
echo "Prepared, Read-Only:"
NAME=`date +%Y%m%d_%H%M`
    pgbench -c 4 -j 2 -T $SEC -M prepared -S bench > Prepared_Read-Only_$NAME.txt
    cat Prepared_Read-Only_$NAME.txt | grep "tps"
sleep 5

NAME=`date +%Y%m%d_%H%M`

echo "Stop TMask.pl Stress Test Postgres pgbench - $NAME"
