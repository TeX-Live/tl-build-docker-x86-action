FROM debian:jessie
#FROM i386/debian:jessie
#FROM alpine:3.2
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get -y update && apt-get install -y --no-install-recommends bash gcc g++ make perl libfontconfig-dev libx11-dev libxmu-dev libxaw7-dev build-essential
# clean up
RUN apt-get clean && rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
