FROM alpine
# FROM centos:6.6
MAINTAINER kazaoki lab.

# General
# ----------------
# RUN useradd lamp -u 1000

# # TimeZone set
# # ------------
# RUN cp /etc/localtime /etc/localtime.org && \
#     ln -sf  /usr/share/zoneinfo/Asia/Tokyo /etc/localtime && \
#     cp /etc/sysconfig/clock /etc/sysconfig/clock.org && \
#     echo 'ZONE="Asia/Tokyo"' > /etc/sysconfig/clock

# # Base yum install
# # ----------------
# RUN yum update -y && \
#     yum install epel-release -y && \
#     yum install -y \
#         gcc make perl perl-core openssl openssl-libs openssl-devel \
#         net-tools sudo multitail zip tar bzip2 patch git \
#         curl curl-devel ruby \
#         php php-mbstring php-pdo php-mysql php-pgsql php-gd php-xml \
#         php-soap php-Smarty re2c libxml2-devel bison bison-devel \
#         libjpeg-devel libpng-devel readline-devel libtidy-devel \
#         libxslt-devel libmcrypt libmcrypt-devel php-mcrypt \
#         perl-libwww-perl perl-Crypt-SSLeay \
#         perl-DBI perl-DBD-MySQL perl-DBD-SQLite perl-DBD-CSV perl-DBD-ODBC perl-DBD-Pg \
#         ImageMagick ImageMagick-perl \
#         postfix \
#         mysql mysql-server \
#         postgresql postgresql-server \
#         httpd httpd-devel mod_php mod_ssl \
#     && yum clean all

# # PHP
# # ---
# RUN sed -i 's/\;date\.timezone\ \=/date\.timezone\ \=\ Asia\/Tokyo/g' /etc/php.ini && \
#     sed -i 's/\;mbstring\.language\ \=\ Japanese/mbstring\.language\ \=\ Japanese/g' /etc/php.ini && \
#     sed -i 's/\;mbstring\.internal_encoding\ \=\ EUC-JP/mbstring\.internal_encoding\ \=\ UTF-8/g' /etc/php.ini && \
#     sed -i 's/\;mbstring\.http_input\ \=\ auto/mbstring\.http_input\ \=\ pass/g' /etc/php.ini && \
#     sed -i 's/\;mbstring\.http_output\ \=\ SJIS/mbstring\.http_output\ \=\ pass/g' /etc/php.ini && \
#     sed -i 's/\;mbstring\.encoding_translation\ \=\ Off/mbstring\.encoding_translation\ \=\ Off/g' /etc/php.ini && \
#     sed -i 's/\;mbstring\.detect_order\ \=\ auto/mbstring\.detect_order\ \=\ UTF-8\,SJIS\,EUC-JP\,JIS\,ASCII/g' /etc/php.ini && \
#     sed -i 's/\;mbstring\.func_overload\ \=\ 0/mbstring\.func_overload\ \=\ 0/g' /etc/php.ini && \
#     cd /root/
# RUN curl -L https://raw.github.com/CHH/phpenv/master/bin/phpenv-install.sh | sh && \
#     echo 'export PATH="/root/.phpenv/bin:$PATH"' >> /root/.bashrc && \
#     echo 'eval "$(phpenv init -)"' >> /root/.bashrc && \
#     source /root/.bashrc && \
#     git clone https://github.com/CHH/php-build.git /root/src/php-build && \
#     cd /root/src/php-build/ && \
#     sh install.sh && \
#     cd /

# # CGI/Perl
# # --------
# RUN curl -L http://cpanmin.us | perl - App::cpanminus \
#     && cpanm Module::CPANfile --force \
#     && cpanm Carton

# # Postfix
# # -------

# # MySQL
# # -----
# RUN sed -i "1i [mysql]\ndefault-character-set=utf8\n" /etc/my.cnf && \
#     sed -i 's/\[mysqld\]/\[mysqld\]\ndefault-character-set=utf8/' /etc/my.cnf

# # PostgreSQL
# # ----------
# RUN su - postgres -c "/usr/bin/initdb --encoding=UTF8 --no-locale" && \
#     sed -i "s/\#listen_addresses = 'localhost'/listen_addresses = '*'/g" /var/lib/pgsql/data/postgresql.conf && \
#     sed -i "s/^log_timezone\ \=\ \'UTC\'/\#log_timezone\ \=\ \'UTC\'/g" /var/lib/pgsql/data/postgresql.conf && \
#     sed -i "s/^timezone\ \=\ \'UTC\'/\#timezone\ \=\ \'UTC\'/g" /var/lib/pgsql/data/postgresql.conf && \
#     echo "host all all 0.0.0.0/0 trust" >> /var/lib/pgsql/data/pg_hba.conf

# # Apache
# # ------
# RUN sed -i 's/User\ apache/User\ lamp/g' /etc/httpd/conf/httpd.conf && \
#     sed -i 's/Group\ apache/Group\ lamp/g' /etc/httpd/conf/httpd.conf && \
#     sed -i 's/\#AddHandler\ cgi\-script\ \.cgi/AddHandler\ cgi\-script\ \.cgi/g' /etc/httpd/conf/httpd.conf && \
#     sed -i 's/\#ServerName www\.example\.com\:80/ServerName lamp/g' /etc/httpd/conf/httpd.conf && \
#     echo '<Directory /var/www/html>' >> /etc/httpd/conf/httpd.conf && \
#     echo '  Options FollowSymLinks ExecCGI' >> /etc/httpd/conf/httpd.conf && \
#     echo '  AllowOverride All' >> /etc/httpd/conf/httpd.conf && \
#     echo '  DirectoryIndex index.cgi index.php index.html index.htm' >> /etc/httpd/conf/httpd.conf && \
#     echo '  SetEnv PERL5LIB /opt/perl-carton/local/lib/perl5' >> /etc/httpd/conf/httpd.conf && \
#     echo '  EnableMMAP Off' >> /etc/httpd/conf/httpd.conf && \
#     echo '  EnableSendfile Off' >> /etc/httpd/conf/httpd.conf && \
#     echo '  # <__PASSENV__>' >> /etc/httpd/conf/httpd.conf && \
#     echo '  # </__PASSENV__>' >> /etc/httpd/conf/httpd.conf && \
#     echo '  # <__NO_CACHE__>' >> /etc/httpd/conf/httpd.conf && \
#     echo '  # </__NO_CACHE__>' >> /etc/httpd/conf/httpd.conf && \
#     echo '  # <__BANDWIDTH__>' >> /etc/httpd/conf/httpd.conf && \
#     echo '  # </__BANDWIDTH__>' >> /etc/httpd/conf/httpd.conf && \
#     echo '</Directory>' >> /etc/httpd/conf/httpd.conf && \
#     usermod -G apache lamp

# RUN mkdir /usr/local/src/mod_bw && \
#     cd /usr/local/src/mod_bw && \
#     curl -o mod_bw-0.92.tgz -LO http://sourceforge.net/projects/bwmod/files/bwmod/mod_bw%200.92/mod_bw-0.92.tgz/download && \
#     tar zxfv mod_bw-0.92.tgz && \
#     apxs -i -a -c mod_bw.c && \
#     cd / && \
#     rm -fr /usr/local/src/mod_bw

# Added shell files
# -----------------
ADD entry.sh /opt/entry.sh
ADD after.sh /opt/after.sh
ENTRYPOINT /opt/entry.sh
