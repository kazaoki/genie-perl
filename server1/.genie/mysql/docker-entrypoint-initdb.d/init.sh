#!/bin/sh

# Extact exist db data
# --------------------
if [ -f /genie/mysql/dbdata_$MYSQL_LABEL.tar.gz ]; then
  mkdir -p /var/lib/mysql/$MYSQL_DATABASE
  tar xfz /genie/mysql/dbdata_$MYSQL_LABEL.tar.gz -C /var/lib/mysql/$MYSQL_DATABASE
fi
