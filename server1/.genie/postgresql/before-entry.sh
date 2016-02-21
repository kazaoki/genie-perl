#!/bin/sh

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

# Pass to true shell
# ------------------
exec /docker-entrypoint.sh $@
