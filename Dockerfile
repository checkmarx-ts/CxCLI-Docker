FROM openjdk:oraclelinux7

COPY scm_support/perforce/perforce.repo /etc/yum.repos.d/

RUN rpm --import https://package.perforce.com/perforce.pubkey && \
    yum install -y curl python python3 jq helix-cli git unzip yarl && \
    yum clean all

ARG CX_CLI_URL="https://download.checkmarx.com/9.0.0/Plugins/CxConsolePlugin-2020.4.4.zip"

# Certificates
COPY *.crt *.cer import_certs.sh /certs/

RUN chmod +x /certs/import_certs.sh && \
    /certs/import_certs.sh

WORKDIR /opt

# CLI
RUN echo Downloading CLI plugin from ${CX_CLI_URL} && \
    curl ${CX_CLI_URL} -o cli.zip

RUN echo Unzipping cli.zip && \
    unzip cli.zip -d cli_tmp  && \
    rm -f cli.zip && \
    ( [ -d cli_tmp/CxConsolePlugin-* ] && { mv cli_tmp/CxConsolePlugin-* /opt/cxcli; rm -rf cli_tmp; } || { mkdir /opt/cxcli ; cp -r cli_tmp/* /opt/cxcli; rm -rf cli_tmp; } )

RUN echo Clear Up cli folder && \
    # Fix DOS/Windows EOL encoding, if it exists
    cd cxcli && \
    cat -v runCxConsole.sh | sed -e "s/\^M$//" > runCxConsole-fixed.sh && \ 
    rm -f runCxConsole.sh && \
    mv runCxConsole-fixed.sh runCxConsole.sh && \
    rm -rf Examples && \
    ls -la && \
    chmod +x runCxConsole.sh && \
    mkdir /post-fetch

RUN echo Importing Certificates && \
    /certs/import_certs.sh

COPY scripts/* /opt/cxcli/

RUN chmod +x /opt/cxcli/entry.sh

WORKDIR /opt/cxcli

ENTRYPOINT ["/opt/cxcli/entry.sh"]

# Workaround to Docker failing to build derived containers
# if no certificate files are available.
ONBUILD COPY ./* /certs_staging/
ONBUILD RUN \
            ( [ -f /cert_staging/*.crt ] && cp /cert_staging/*.crt -t /certs/  || continue ) && \
            ( [ -f /cert_staging/*.cer ] && cp /cert_stagins/*.cer /certs/  || continue) && \
            /certs/import_certs.sh && \
            ( [ -f /certs_staging ] && rm -rf /certs_staging || continue ) && \
            . /dev/null


