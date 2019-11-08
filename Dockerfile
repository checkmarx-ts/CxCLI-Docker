FROM openjdk:jre-alpine

LABEL Miguel Freitas <miguel.freitas@checkmarx.com>

#ARG CX_CLI_VERSION="8.60.3"
#ARG CX_CLI_VERSION="8.70.4"
#ARG CX_CLI_VERSION="8.80.2"
ARG CX_CLI_VERSION="8.90.2"

#ARG CX_VERSION="8.6.0"
#ARG CX_VERSION="8.7.0"
#ARG CX_VERSION="8.8.0"
ARG CX_VERSION="8.9.0"
ARG CX_CLI_URL="https://download.checkmarx.com/${CX_VERSION}/Plugins/CxConsolePlugin-${CX_CLI_VERSION}.zip"

RUN apk add --no-cache --update curl python jq bash

WORKDIR /opt

RUN curl ${CX_CLI_URL} -o cli.zip && \
    rm -rf /var/cache/apk/* && \
    unzip cli.zip && \
    rm -rf cli.zip && \
    cd CxConsolePlugin-${CX_CLI_VERSION} && \
    chmod +x runCxConsole.sh

WORKDIR /opt/CxConsolePlugin-${CX_CLI_VERSION}

CMD ["sh", "runCxConsole.sh", "Scan"]