#!/bin/sh

# Process start
# -------------
echo 'Process start' >> /var/log/init.log

# TimeZone set
# ------------
cp -p /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
echo 'Asia/Tokyo' > /etc/timezone

# Conf files copy from host
# -------------------------
cp /opt/conf.d/* /etc/mysql/conf.d
sed -i "s/<__MYSQL_CHARSET__>/$MYSQL_CHARSET/" /etc/mysql/conf.d/*
sed -i "s/<__MYSQL_PORT__>/$MYSQL_PORT/" /etc/mysql/conf.d/*
chmod -R 0660 /etc/mysql/conf.d

# Copy shell file
# ---------------
cp /opt/docker-entrypoint-initdb.d/* /docker-entrypoint-initdb.d

# Copy dump file
# --------------
if [ -f /opt/dumps/$MYSQL_LABEL.sql ]; then
  cp /opt/dumps/$MYSQL_LABEL.sql /docker-entrypoint-initdb.d
fi

# Pass to true shell
# ------------------
exec /entrypoint.sh $@
