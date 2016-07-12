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
cp /mysql/opt/conf.d/* /etc/mysql/conf.d
sed -i "s/<__MYSQL_CHARSET__>/$MYSQL_CHARSET/" /etc/mysql/conf.d/*
chmod -R 0644 /etc/mysql/conf.d

# Copy shell file
# ---------------
cp /mysql/opt/docker-entrypoint-initdb.d/* /docker-entrypoint-initdb.d

# Copy dump file
# --------------
if [ -f /mysql/opt/dumps/$MYSQL_LABEL.sql ]; then
  cp /mysql/opt/dumps/$MYSQL_LABEL.sql /docker-entrypoint-initdb.d
fi

# Copy directories other than /opt/
# ---------------------------------
for target in `ls /mysql`
do
  if [ $target != 'opt' ]; then
    echo $target
    \cp -rf /mysql/$target /
  fi
done

# Pass to true shell
# ------------------
exec /entrypoint.sh $@
