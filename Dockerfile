FROM openjdk:oraclelinux7

COPY scm_support/perforce/perforce.repo /etc/yum.repos.d/

RUN rpm --import https://package.perforce.com/perforce.pubkey && \
    yum install -y curl python python3 jq helix-cli git unzip && \
    yum clean all

ARG CX_CLI_URL="https://download.checkmarx.com/9.0.0/Plugins/CxConsolePlugin-2020.4.4.zip"

# Certificates
COPY *.crt *.cer import_certs.sh /certs/

RUN chmod +x /certs/import_certs.sh && \
    /certs/import_certs.sh

WORKDIR /opt

# CLI
RUN echo Downloading CLI plugin from ${CX_CLI_URL} && \
    curl ${CX_CLI_URL} -o cli.zip && \
    unzip cli.zip -d cli_tmp  && \
    rm -f cli.zip && \
    ( [ -d cli_tmp/CxConsolePlugin-* ] && { mv cli_tmp/CxConsolePlugin-* /opt/cxcli; rm -rf cli_tmp; } || { mkdir /opt/cxcli ; cp -r cli_tmp/* /opt/cxcli; rm -rf cli_tmp; } ) && \ 
    cd cxcli && \
    # Fix DOS/Windows EOL encoding, if it exists
    cat -v runCxConsole.sh | sed -e "s/\^M$//" > runCxConsole-fixed.sh && \
    rm -f runCxConsole.sh && \
    mv runCxConsole-fixed.sh runCxConsole.sh && \
    rm -rf Examples && \
    chmod +x runCxConsole.sh && \
    mkdir /post-fetch && \
    /certs/import_certs.sh && \
    pip3 install yarl

COPY scripts/* /opt/cxcli/
RUN chmod +x /opt/cxcli/entry.sh

WORKDIR /opt/cxcli

ENTRYPOINT ["/opt/cxcli/entry.sh"]

ONBUILD COPY *.crt /certs/
ONBUILD COPY *.cer /certs/
ONBUILD RUN /certs/import_certs.sh

