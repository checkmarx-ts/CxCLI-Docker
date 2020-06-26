# CxCLI-Docker
### Available Versions

https://github.com/checkmarx-ts/CxCLI-Docker/packages/60289/versions

## Use CxCLI Docker Image

Pull Image from Command Line:
<access_token> - Should have Read Packages permission
```sh
docker login docker.pkg.github.com -u <username> -p <access_token>
docker pull docker.pkg.github.com/checkmarx-ts/cxcli-docker/cxcli:latest
```

Use as base image in DockerFile:
```Dockerfile
FROM docker.pkg.github.com/checkmarx-ts/cxcli-docker/cxcli:latest
```

### CLI Download Links used:
latest (9.0) : https://download.checkmarx.com/9.0.0/Plugins/CxConsolePlugin-2020.2.18.zip

2020.2.18 : https://download.checkmarx.com/9.0.0/Plugins/CxConsolePlugin-2020.2.18.zip

2020.2.7 : https://download.checkmarx.com/9.0.0/Plugins/CxConsolePlugin-2020.2.7.zip

2020.2.3 : https://download.checkmarx.com/9.0.0/Plugins/CxConsolePlugin-2020.2.3.zip

2020.1.12 : https://download.checkmarx.com/9.0.0/Plugins/CxConsolePlugin-2020.1.12.zip

9.00.2 : https://download.checkmarx.com/9.0.0/Plugins/CxConsolePlugin-9.00.2.zip

9.00.1 : https://download.checkmarx.com/9.0.0/Plugins/CxConsolePlugin-9.00.1.zip

8.90.2 : https://download.checkmarx.com/8.9.0/Plugins/CxConsolePlugin-8.90.2.zip

8.80.4 : https://download.checkmarx.com/8.8.0/Plugins/CxConsolePlugin-8.80.4.zip

#### CxCLI Documentation: 

https://checkmarx.atlassian.net/wiki/spaces/KC/pages/44335590/CxSAST+CLI+Guide


### Importing Custom CA Certificates

Any binary DER encoded X.509 certificates in files ending in *.cer or *.crt will be imported from the build directory at the time the image build is executed.

### Build with latest plugin:

With Docker Compose:
```sh
docker-compose build cxcli_latest
```

With Docker:

```sh
docker build -t cxcli:latest . --no-cache
```

### Build with an older version of the plugin:
With Docker Compose:
```sh
docker-compose build cxcli_{version}
```

With Docker:
*Insert a download URL from above to change the plugin version.*

```sh
docker build --build-arg CX_CLI_URL="{download url}" -t cxcli:{version} . --no-cache
```

### Run Container:
With Docker Compose:
```sh
docker-compose up cxcli_{version}
```

With Docker:
```sh
docker run -it --name cxcli cxcli:{version}
```
### License

MIT License
