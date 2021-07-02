FROM debian:jessie
#FROM i386/debian:jessie
#FROM alpine:3.2
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
