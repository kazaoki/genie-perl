FROM alpine:3.3
MAINTAINER kazaoki lab.

# Set timezone
# ------------
RUN apk --update add tzdata && \
	cp /usr/share/zoneinfo/Asia/Tokyo  /etc/localtime && \
	echo "Asia/Tokyo" > /etc/timezone && \
	apk del tzdata

# Add packages
# ------------
RUN apk --update add \
	bash \
	htop \
	git \
	gcc \
	g++ \
	make \
	patch \
	tar \
	bison \
	libxml2 \
	libxml2-dev \
	re2c \
	openssl \
	openssl-dev \
	perl \
	coreutils \
	libcurl \
	&& rm -rf /var/cache/apk/*

# Changes shell to bash
# ---------------------
RUN sed -i 's/\/bin\/ash/\/bin\/bash/g' /etc/passwd \
    && /bin/bash

# Install anyenv
# --------------
RUN git clone https://github.com/riywo/anyenv ~/.anyenv \
    && echo 'export PATH="$HOME/.anyenv/bin:$PATH"' >> ~/.bash_profile \
    && echo 'eval "$(anyenv init -)"' >> ~/.bash_profile \
    && exec $SHELL -l

# Install Ruby by rbenv
# ---------------------
RUN anyenv install rbenv \
    && exec $SHELL -l
RUN rbenv install 2.3.0

# Install Perl by plenv
# ---------------------
RUN anyenv install plenv \
    && exec $SHELL -l
RUN plenv install 5.23.7

# Install PHP by phpenv
# ---------------------
RUN anyenv install phpenv \
    && exec $SHELL -l
RUN phpenv install 7.0.2

# Entry point
# -----------
ENTRYPOINT /genie/entry.sh
