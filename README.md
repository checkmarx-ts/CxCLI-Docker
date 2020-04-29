# CxCLI-Docker
### Checkmarx CLI with Docker

https://hub.docker.com/r/miguelfreitas93/cxcli

### Download Links:
9.00.0 (latest) : https://download.checkmarx.com/9.0.0/Plugins/cli-2020.1.12.zip

8.90.2 : https://download.checkmarx.com/8.9.0/Plugins/CxConsolePlugin-8.90.2.zip

8.80.2 : https://download.checkmarx.com/8.8.0/Plugins/CxConsolePlugin-8.80.2.zip

8.70.4 : https://download.checkmarx.com/8.7.0/Plugins/CxConsolePlugin-8.70.4.zip

8.60.3 : https://download.checkmarx.com/8.6.0/Plugins/CxConsolePlugin-8.60.3.zip

#### CxCLI Documentation: 

https://checkmarx.atlassian.net/wiki/spaces/KC/pages/44335590/CxSAST+CLI+Guide


### Importing Custom CA Certificates

Any binary DER encoded X.509 certificates in files ending in *.cer or *.crt will be imported from the build directory at the time the image build is executed.

### Build with latest plugin:

docker build -t cxcli:{version} . --no-cache

### Build with an older version of the plugin:

*Insert a download URL from above to change the plugin version.*

docker build --build-arg CX_CLI_URL="{download url}" -t cxcli:{version} . --no-cache



### Run Container:

docker run -it --name cxcli cxcli:{version}

### License

MIT License
