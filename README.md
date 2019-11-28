# CxCLI-Docker
### Checkmarx CLI with Docker

https://hub.docker.com/r/miguelfreitas93/cxcli

### Download Links:

8.90.2 (latest): https://download.checkmarx.com/8.9.0/Plugins/CxConsolePlugin-8.90.2.zip

8.80.2 : https://download.checkmarx.com/8.8.0/Plugins/CxConsolePlugin-8.80.2.zip

8.70.4 : https://download.checkmarx.com/8.7.0/Plugins/CxConsolePlugin-8.70.4.zip

8.60.3 : https://download.checkmarx.com/8.6.0/Plugins/CxConsolePlugin-8.60.3.zip

#### CxCLI Documentation: 

https://checkmarx.atlassian.net/wiki/spaces/KC/pages/44335590/CxSAST+CLI+Guide

### Build:

docker build -t cxcli:{version} . --no-cache

### Run Container:

docker run -it --name cxcli cxcli:{version}

### License

MIT License
