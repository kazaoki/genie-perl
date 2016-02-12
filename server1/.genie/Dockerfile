FROM centos:7
MAINTAINER kazaoki lab.

# Set timezone
# ------------
RUN cp /etc/localtime /etc/localtime.org \
    && ln -sf  /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

# Add packages
# ------------
RUN yum update -y && \
    yum install epel-release -y && \
    yum install -y \
        gcc make perl perl-core openssl openssl-libs openssl-devel htop \
        git bzip2 tar patch wget \
        readline readline-devel \
        zlib zlib-devel \
        curl curl-devel \
        bison bison-devel re2c libxml2-devel \
        libjpeg-devel libpng-devel readline-devel libtidy-devel \
        libxslt-devel libmcrypt libmcrypt-devel php-mcrypt \
        php php-mbstring php-pdo php-mysql php-pgsql php-gd php-xml \
        php-soap php-Smarty re2c libxml2-devel bison bison-devel \
        perl-libwww-perl perl-Crypt-SSLeay \
        ImageMagick ImageMagick-perl \
        postfix \
        libffi-devel \
        mysql mysql-server mysql-devel \
        postgresql postgresql-server postgresql-devel \
        httpd httpd-devel mod_php mod_ssl \
        net-tools sudo multitail zip tar bzip2 patch git \
        nginx \
        ruby \
    && yum clean all

# Install anyenv
# --------------
RUN git clone https://github.com/riywo/anyenv ~/.anyenv \
    && echo 'export PATH="$HOME/.anyenv/bin:$PATH"' >> ~/.bashrc \
    && echo 'eval "$(anyenv init -)"' >> ~/.bashrc
ENV PATH /root/.anyenv/bin:$PATH
RUN . ~/.bashrc

# Install Ruby by rbenv
# ---------------------
RUN anyenv install rbenv \
    && . ~/.bashrc

# Install Perl by plenv
# ---------------------
RUN anyenv install plenv \
    && . ~/.bashrc

# Install PHP by phpenv
# ---------------------
RUN anyenv install phpenv \
    && . ~/.bashrc

# Install PhantomJS
# -----------------
RUN cd /root/ \
    && wget https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2 \
    && tar jxvf phantomjs-2.1.1-linux-x86_64.tar.bz2 \
    && mv phantomjs-2.1.1-linux-x86_64/bin/phantomjs /usr/local/bin \
    && rm -fr phantomjs-2.1.1-linux-x86_64* \
    && cd

# Setup PHP
# ---------
RUN sed -i 's/\;date\.timezone\ \=/date\.timezone\ \=\ Asia\/Tokyo/g' /etc/php.ini \
    && sed -i 's/\;mbstring\.language\ \=\ Japanese/mbstring\.language\ \=\ Japanese/g' /etc/php.ini \
    && sed -i 's/\;mbstring\.internal_encoding\ \=\ EUC-JP/mbstring\.internal_encoding\ \=\ UTF-8/g' /etc/php.ini \
    && sed -i 's/\;mbstring\.http_input\ \=\ auto/mbstring\.http_input\ \=\ pass/g' /etc/php.ini \
    && sed -i 's/\;mbstring\.http_output\ \=\ SJIS/mbstring\.http_output\ \=\ pass/g' /etc/php.ini \
    && sed -i 's/\;mbstring\.encoding_translation\ \=\ Off/mbstring\.encoding_translation\ \=\ Off/g' /etc/php.ini \
    && sed -i 's/\;mbstring\.detect_order\ \=\ auto/mbstring\.detect_order\ \=\ UTF-8\,SJIS\,EUC-JP\,JIS\,ASCII/g' /etc/php.ini \
    && sed -i 's/\;mbstring\.func_overload\ \=\ 0/mbstring\.func_overload\ \=\ 0/g' /etc/php.ini

# Setup cpanm
# -----------
RUN curl -L http://cpanmin.us | perl - App::cpanminus

# Setup MySQL
# -----------
RUN sed -i "1i [mysql]\ndefault-character-set=utf8\n" /etc/my.cnf \
    && sed -i 's/\[mysqld\]/\[mysqld\]\ndefault-character-set=utf8/' /etc/my.cnf

# Setup PostgreSQL
# ----------------
RUN su - postgres -c "/usr/bin/initdb --encoding=UTF8 --no-locale" \
    && sed -i "s/\#listen_addresses = 'localhost'/listen_addresses = '*'/g" /var/lib/pgsql/data/postgresql.conf \
    && echo "host all all 0.0.0.0/0 trust" >> /var/lib/pgsql/data/pg_hba.conf

# Setup Apache
# ------------
RUN sed -i 's/\#AddHandler\ cgi\-script\ \.cgi/AddHandler\ cgi\-script\ \.cgi/g' /etc/httpd/conf/httpd.conf \
    && echo '<Directory /var/www/html>' >> /etc/httpd/conf/httpd.conf \
    && echo '  Options FollowSymLinks ExecCGI' >> /etc/httpd/conf/httpd.conf \
    && echo '  AllowOverride All' >> /etc/httpd/conf/httpd.conf \
    && echo '  DirectoryIndex index.cgi index.php index.html index.htm' >> /etc/httpd/conf/httpd.conf \
    && echo '  SetEnv PERL5LIB /opt/perl-carton/local/lib/perl5' >> /etc/httpd/conf/httpd.conf \
    && echo '  EnableMMAP Off' >> /etc/httpd/conf/httpd.conf \
    && echo '  EnableSendfile Off' >> /etc/httpd/conf/httpd.conf \
    && echo '  # <__PASSENV__>' >> /etc/httpd/conf/httpd.conf \
    && echo '  # </__PASSENV__>' >> /etc/httpd/conf/httpd.conf \
    && echo '  # <__BANDWIDTH__>' >> /etc/httpd/conf/httpd.conf \
    && echo '  # </__BANDWIDTH__>' >> /etc/httpd/conf/httpd.conf \
    && echo '  # <__NO_CACHE__>' >> /etc/httpd/conf/httpd.conf \
    && echo '  # </__NO_CACHE__>' >> /etc/httpd/conf/httpd.conf \
    && echo '</Directory>' >> /etc/httpd/conf/httpd.conf

# RUN sed -i 's/User\ apache/User\ lamp/g' /etc/httpd/conf/httpd.conf \
#     && sed -i 's/Group\ apache/Group\ lamp/g' /etc/httpd/conf/httpd.conf \
#     && sed -i 's/\#ServerName www\.example\.com\:80/ServerName lamp/g' /etc/httpd/conf/httpd.conf \
#     && usermod -G apache lamp

# Entry point
# -----------
ENTRYPOINT /genie/entry.sh
