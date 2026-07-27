FROM alpine:latest

ENV MC_VERSION="latest" \
    EULA="false" \
    MC_RAM="" \
    JAVA_OPTS=""

RUN apk update \
    && apk add libstdc++ openjdk25-jre nushell
    && mkdir /papermc

COPY papermc.nu .
CMD ["nu", "./papermc.nu"]

EXPOSE 25565/tcp
EXPOSE 25565/udp
VOLUME /papermc
