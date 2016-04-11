FROM centos:7
MAINTAINER kazaoki lab.

# Set timezone
# ------------
RUN cp /etc/localtime /etc/localtime.org \
    && ln -sf  /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

# Set locale
# ----------
RUN echo 'LANG="ja_JP.utf8"' > /etc/locale.conf \
    && source /etc/locale.conf

# Add packages
# ------------
RUN rpm -Uvh http://dev.mysql.com/get/mysql-community-release-el7-5.noarch.rpm \
    && yum update -y \
    && yum install epel-release -y \
    && yum install -y \
        gcc make perl perl-core openssl openssl-libs openssl-devel htop \
        git bzip2 tar patch wget \
        readline readline-devel \
        zlib zlib-devel unzip \
        curl curl-devel \
        bison bison-devel re2c libxml2-devel autoconf automake \
        libjpeg-devel libpng-devel readline-devel libtidy-devel \
        libxslt-devel libmcrypt libmcrypt-devel php-mcrypt \
        php php-mbstring php-pdo php-mysql php-pgsql php-gd php-xml \
        php-soap php-Smarty re2c libxml2-devel bison bison-devel \
        perl-libwww-perl perl-Crypt-SSLeay \
        perl-String-CRC32 gnutls \
        perl-DBD-MySQL perl-DBD-Pg \
        ImageMagick ImageMagick-perl \
        postfix \
        libffi-devel \
        mariadb mariadb-devel \
        postgresql postgresql-devel \
        httpd httpd-devel mod_php mod_ssl \
        net-tools sudo multitail zip tar bzip2 patch git \
        nginx \
        ruby ruby-devel rubygem-bundler \
        ibus-kkc vlgothic-* \
    && yum clean all

# Install anyenv
# --------------
ENV PATH /root/.anyenv/bin:$PATH
RUN git clone https://github.com/riywo/anyenv ~/.anyenv \
    && echo 'export PATH="$HOME/.anyenv/bin:$PATH"' >> ~/.bashrc \
    && echo 'eval "$(anyenv init -)"' >> ~/.bashrc \
    && . ~/.bashrc \
    && anyenv install rbenv \
    && anyenv install plenv \
    && anyenv install phpenv \
    && . ~/.bashrc

# Install PhantomJS
# -----------------
RUN cd /root/ \
    && wget https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2 \
    && tar jxvf phantomjs-2.1.1-linux-x86_64.tar.bz2 \
    && mv phantomjs-2.1.1-linux-x86_64/bin/phantomjs /usr/local/bin \
    && rm -fr phantomjs-2.1.1-linux-x86_64* \
    && cd

# Turnip, Capybara, Poltergeist, CapturefulFormatter(for report)
# -----------------------------
ADD Gemfile.lock /turnip/Gemfile.lock
ADD Gemfile /turnip/Gemfile
RUN . /root/.bashrc && \
    cd /turnip && \
    bundle install --path=vendor/bundle && \
    echo '-r turnip/rspec' > .rspec && \
    echo '--format Fuubar' >> .rspec && \
    echo '-r turnip_formatter' >> .rspec && \
    echo '--format RSpecTurnipFormatter' >> .rspec && \
    echo '--out /spec/report.html' >> .rspec && \
    mkdir spec

# Setup default PHP
# -----------------
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

# Install mod_bw
# --------------
RUN mkdir ~/src \
    && cd ~/src \
    && wget -O mod_bw-0.92.tgz https://sourceforge.net/projects/bwmod/files/bwmod/mod_bw%200.92/mod_bw-0.92.tgz/download \
    && tar xfz mod_bw-0.92.tgz \
    && cp mod_bw.c mod_bw.c.org \
    && sed s/remote_addr/client_addr/g -i mod_bw.c \
    && apxs -i -a -c mod_bw.c \
    && rm -fr ~/src


# Setup Apache
# ------------
RUN sed -i 's/\#AddHandler\ cgi\-script\ \.cgi/AddHandler\ cgi\-script\ \.cgi/g' /etc/httpd/conf/httpd.conf \
    && echo '<Directory /var/www/html>' >> /etc/httpd/conf/httpd.conf \
    && echo '  Options FollowSymLinks ExecCGI' >> /etc/httpd/conf/httpd.conf \
    && echo '  AllowOverride All' >> /etc/httpd/conf/httpd.conf \
    && echo '  DirectoryIndex index.cgi index.php index.html index.htm' >> /etc/httpd/conf/httpd.conf \
    && echo '  SetEnv PERL5LIB /perl/cpanfile-modules/lib/perl5' >> /etc/httpd/conf/httpd.conf \
    && echo '  EnableMMAP Off' >> /etc/httpd/conf/httpd.conf \
    && echo '  EnableSendfile Off' >> /etc/httpd/conf/httpd.conf \
    && echo '  # <__PASSENV__>' >> /etc/httpd/conf/httpd.conf \
    && echo '  # </__PASSENV__>' >> /etc/httpd/conf/httpd.conf \
    && echo '  # <__BANDWIDTH__>' >> /etc/httpd/conf/httpd.conf \
    && echo '  # </__BANDWIDTH__>' >> /etc/httpd/conf/httpd.conf \
    && echo '  # <__NO_CACHE__>' >> /etc/httpd/conf/httpd.conf \
    && echo '  # </__NO_CACHE__>' >> /etc/httpd/conf/httpd.conf \
    && echo '</Directory>' >> /etc/httpd/conf/httpd.conf \
    && sed -i 's/\#ServerName www\.example\.com\:80/ServerName genie/g' /etc/httpd/conf/httpd.conf

# Install ngrok
# -------------
RUN mkdir /tmp/ngrok/ \
    && cd /tmp/ngrok/ \
    && wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip \
    && unzip ngrok-stable-linux-amd64.zip \
    && mv ngrok /usr/local/bin \
    && rm -fr /tmp/ngrok/ \
    && cd

# Install lftp
# ------------
RUN rpm -ivh http://lftp.yar.ru/ftp/binaries/lftp-4.6.5-1.x86_64.rpm

# Entry point
# -----------
ENTRYPOINT /opt/entry.sh
