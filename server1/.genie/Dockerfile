FROM alpine:3.3
MAINTAINER kazaoki lab.

# Add packages
# ------------
RUN apk --update add \
	bash \
	&& rm -rf /var/cache/apk/*

# Entry point
# -----------
ENTRYPOINT /genie/entry.sh
