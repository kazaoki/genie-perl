#!/bin/sh

# TimeZone set
# ------------
cp -p /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
echo 'Asia/Tokyo' > /etc/timezone

# Conf files copy from host
# -------------------------
cp /genie/mysql/conf.d/* /etc/mysql/conf.d
sed -i "s/<__MYSQL_CHARSET__>/$MYSQL_CHARSET/" /etc/mysql/conf.d/*
sed -i "s/<__MYSQL_PORT__>/$MYSQL_PORT/" /etc/mysql/conf.d/*
chmod -R 0660 /etc/mysql/conf.d

# Copy shell file
# ---------------
cp /genie/mysql/docker-entrypoint-initdb.d/* /docker-entrypoint-initdb.d

# Copy dump file
# --------------
cp /genie/mysql/dumps/$MYSQL_LABEL.sql /docker-entrypoint-initdb.d

# Pass to true shell
# ------------------
exec /entrypoint.sh $@
