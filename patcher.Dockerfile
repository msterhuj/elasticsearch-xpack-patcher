FROM openjdk:17-jdk-alpine

WORKDIR /espatcher

RUN mkdir -p output
RUN apk add --no-cache wget bash patch make file

ENTRYPOINT [ "/bin/bash" ]
