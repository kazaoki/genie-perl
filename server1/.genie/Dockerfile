FROM alpine:3.3
MAINTAINER kazaoki lab.

# Set timezone
# ------------
RUN apk --update add tzdata \
	&& cp /usr/share/zoneinfo/Asia/Tokyo  /etc/localtime \
	&& echo "Asia/Tokyo" > /etc/timezone \
	&& apk del tzdata

# Add packages
# ------------
RUN apk --update add \
    coreutils \
    findutils \
    net-tools sudo zip bzip2 \
    git htop autoconf gcc g++ re2c \
    bash make patch tar bison \
    libxml2 libxml2-dev \
    openssl openssl-dev \
    curl curl-dev \
    libjpeg jpeg-dev \
    libpng libpng-dev \
    libmcrypt libmcrypt-dev \
    readline readline-dev \
    libffi libffi-dev \
    libxslt libxslt-dev \
    cmake tree \
    apache2 apache2-dev \
    mysql mysql-client \
    postgresql postgresql-client postgresql-dev \
    postfix \
    imagemagick \
    perl \
    php \
    ruby \
    && rm -rf /var/cache/apk/*

# Change shell to bash
# --------------------
RUN sed -i 's/\/bin\/ash/\/bin\/bash/g' /etc/passwd \
    && exec /bin/bash -l

# Install anyenv
# --------------
RUN git clone https://github.com/riywo/anyenv ~/.anyenv \
    && echo 'export PATH="$HOME/.anyenv/bin:$PATH"' >> ~/.bashrc \
    && echo 'eval "$(anyenv init -)"' >> ~/.bashrc
ENV PATH /root/.anyenv/bin:$PATH

# Install rbenv
# -------------
RUN ["/bin/bash", "-c", " \
        source ~/.bashrc \
        && anyenv install rbenv \
    "]

# Install plenv
# -------------
RUN ["/bin/bash", "-c", " \
        source ~/.bashrc \
        && anyenv install plenv \
    "]

# Install phpenv
# --------------
RUN mkdir ~/src \
    && cd ~/src \
    && wget https://github.com/htacg/tidy-html5/archive/master.zip \
    && unzip master.zip \
    && cd tidy-html5-master/build/cmake/ \
    && cmake ../.. \
    && make \
    && make install \
    && rm -fr ~/src \
    && cd
RUN ["/bin/bash", "-c", " \
        source ~/.bashrc \
        && anyenv install phpenv \
    "]

# COPY tidy_path_overwrite.sh /root/.anyenv/envs/phpenv/plugins/php-build/share/php-build/before-install.d/tidy_path_overwrite.sh
# RUN chmod +x /root/.anyenv/envs/phpenv/plugins/php-build/share/php-build/before-install.d/tidy_path_overwrite.sh
# RUN ["/bin/bash", "-c", " \
#         source ~/.bashrc \
#         && phpenv install 5.6.0 \
#         && phpenv global 5.6.0 \
#         && phpenv rehash \
#     "]

# Install PhantomJS binary for alpine linux
# -----------------------------------------
RUN curl -Ls https://github.com/fgrehm/docker-phantomjs2/releases/download/v2.0.0-20150722/dockerized-phantomjs.tar.gz | tar xz -C /

# Entry point
# -----------
ENTRYPOINT /genie/entry.sh
