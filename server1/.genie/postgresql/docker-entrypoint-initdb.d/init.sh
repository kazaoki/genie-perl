#!/bin/sh

# Port change
# -----------
echo "port = $POSTGERS_PORT" >> $PGDATA/postgresql.conf
