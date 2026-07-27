FROM alpine:latest

ENV MC_VERSION="latest" \
    EULA="false" \
    MC_RAM="" \
    JAVA_OPTS=""

RUN apk update \
    && apk add --no-cache libstdc++ openjdk25-jre nushell su-exec \
    && adduser -D -h /papermc minecraft

COPY papermc.nu /papermc.nu
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 25565/tcp
EXPOSE 25565/udp
VOLUME /papermc

ENTRYPOINT ["/entrypoint.sh"]
CMD ["nu", "/papermc.nu"]
