#!/bin/sh

# Process start
# -------------
echo 'Process start' >> /var/log/init.log

# TimeZone set
# ------------
cp -p /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
echo 'Asia/Tokyo' > /etc/timezone

# Package update & lang setting
# -----------------------------
echo "ja_JP.UTF-8 UTF-8" >> /etc/locale.gen
echo "ja_JP.EUC-JP EUC-JP" >> /etc/locale.gen
/usr/sbin/locale-gen
export LANG=$POSTGERS_LOCALE
/usr/sbin/update-locale LANG=$POSTGERS_LOCALE

# Copy shell file
# ---------------
cp /postgresql/opt/docker-entrypoint-initdb.d/* /docker-entrypoint-initdb.d

# Copy dump file
# --------------
cp /postgresql/opt/dumps/$POSTGRES_LABEL.sql /docker-entrypoint-initdb.d

# Copy directories other than /opt/
# ---------------------------------
for target in `ls /postgresql`
do
  if [ $target != 'opt' ]; then
    echo $target
    \cp -rf /postgresql/$target /
  fi
done

# Pass to true shell
# ------------------
exec /docker-entrypoint.sh $@
