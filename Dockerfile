FROM openjdk:8-jdk-alpine

LABEL Miguel Freitas <miguel.freitas@checkmarx.com>

ARG CX_CLI_URL="https://download.checkmarx.com/9.0.0/Plugins/CxConsolePlugin-2020.2.18.zip"

RUN apk add --no-cache --update curl python jq bash && \
    rm -rf /var/cache/apk/*

WORKDIR /opt

COPY *.crt *.cer import_certs.sh /certs/

RUN echo Downloading CLI plugin from ${CX_CLI_URL} && \
    curl ${CX_CLI_URL} -o cli.zip && \
    unzip cli.zip && \
    rm -rf cli.zip && \
    ( [ -d CxConsolePlugin-* ] && mv CxConsolePlugin-* cxcli || { mkdir cxcli; cp -r $(ls | grep -v cxcli) cxcli; rm -rf $(ls | grep -v cxcli); } ) && \ 
    cd cxcli && \
    # Fix DOS/Windows EOL encoding, if it exists
    cat -v runCxConsole.sh | sed -e "s/\^M$//" > runCxConsole-fixed.sh && \
    rm -f runCxConsole.sh && \
    mv runCxConsole-fixed.sh runCxConsole.sh && \
    rm -rf Examples && \
    chmod +x runCxConsole.sh && \
    chmod +x /certs/import_certs.sh && \
    /certs/import_certs.sh && \
    rm -rf /certs


WORKDIR /opt/cxcli

ENTRYPOINT ["/opt/cxcli/runCxConsole.sh"]

