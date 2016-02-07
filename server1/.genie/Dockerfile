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
    bash make patch tar bison \
    htop \
    git \
    autoconf \
    libxml2 libxml2-dev \
    gcc g++ \
    perl \
    re2c \
    openssl openssl-dev \
    curl curl-dev \
    libjpeg jpeg-dev \
    libpng libpng-dev \
    libmcrypt libmcrypt-dev \
    readline readline-dev \
    libffi libffi-dev \
    cmake \
    tree \
    libxslt libxslt-dev \
    findutils \
    apache2 apache2-dev \
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
RUN . ~/.bashrc

# Install Ruby by rbenv
# ---------------------
RUN anyenv install rbenv \
    && . ~/.bashrc \
    && rbenv install 2.2.0 \
    && rbenv global 2.2.0 \
    && rbenv rehash

# Install Perl by plenv
# ---------------------
RUN anyenv install plenv \
    && . ~/.bashrc \
    && plenv install 5.20.0 \
    && plenv global 5.20.0 \
    && plenv rehash

# Install PHP by phpenv
# ---------------------
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
RUN anyenv install phpenv \
    && . ~/.bashrc
RUN ln -s /genie/tidy_path_overwrite.sh /root/.anyenv/envs/phpenv/plugins/php-build/share/php-build/before-install.d/tidy_path_overwrite.sh
RUN chmod +x /root/.anyenv/envs/phpenv/plugins/php-build/share/php-build/before-install.d/tidy_path_overwrite.sh
RUN phpenv install 5.4.45 \
    && phpenv global 5.4.45 \
    && phpenv rehash

# Entry point
# -----------
ENTRYPOINT /genie/entry.sh
