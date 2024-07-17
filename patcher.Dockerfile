FROM openjdk:17-jdk-alpine

WORKDIR /espatcher

RUN mkdir -p output
RUN apk add --no-cache wget bash

# download jd-cli and remove not needed files
ADD "https://github.com/intoolswetrust/jd-cli/releases/download/jd-cli-1.2.0/jd-cli-1.2.0-dist.tar.gz" /espatcher/jd-cli-1.2.0-dist.tar.gz
RUN tar -xvf jd-cli-1.2.0-dist.tar.gz && rm jd-cli-1.2.0-dist.tar.gz LICENSE.txt jd-cli.bat jd-cli

ENTRYPOINT [ "/bin/bash" ]
