cp -p /usr/share/zoneinfo/Japan /etc/localtime
sed -i "s/3306/$MYSQL_PORT/" /etc/mysql/my.cnf
sed -i "s/\[mysqld\]/\[mysqld\]\ncharacter-set-server=$MYSQL_CHARSET/" /etc/mysql/my.cnf
sed -i "s/\[client\]/\[client\]\ndefault-character-set=$MYSQL_CHARSET/" /etc/mysql/my.cnf
