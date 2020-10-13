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
latest (2020.3.1) : https://download.checkmarx.com/9.0.0/Plugins/CxConsolePlugin-2020.3.1.zip

2020.3.1 : https://download.checkmarx.com/9.0.0/Plugins/CxConsolePlugin-2020.3.1.zip

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


## Importing Custom CA Certificates


### Building from Source

If you are building the docker image from the source, any binary DER encoded X.509 certificates in files located in the root directory ending in *.cer or *.crt will be added to the list of Java trusted CAs.  Place the certificate files in the build directory at the time the image build is executed.

### Building a Derived Container

If you are building a container derived from the pre-built CxCLI docker container (e.g. `FROM docker.pkg.github.com/checkmarx-ts/cxcli-docker/cxcli:latest`), any *.crt or *.cer files in the build root directory will automatically be imported to the list of Java trusted CAs.  This is done through build triggers that are executed prior to the custom image build.


## Build with latest plugin:

With Docker Compose:
```sh
docker-compose build cxcli_latest
```

With Docker:

```sh
docker build -t cxcli:latest . --no-cache
```

## Build with an older version of the plugin:
With Docker Compose:
```sh
docker-compose build cxcli_{version}
```

With Docker:
*Insert a download URL from above to change the plugin version.*

```sh
docker build --build-arg CX_CLI_URL="{download url}" -t cxcli:{version} . --no-cache
```

## Run Container:
With Docker Compose:
```sh
docker-compose up cxcli_{version}
```

With Docker:
```sh
docker run -it --name cxcli cxcli:{version}
```

### Example how to use CLI image:

Dockerfile example:
```dockerfile
FROM docker.pkg.github.com/checkmarx-ts/cxcli-docker/cxcli:latest

# Import Certs into Keystore - If Required
#COPY *.cer ./certs/
#COPY *.crt ./certs/

RUN ls -la && \
    cd certs && \
    ./import_certs.sh && \
    cd ..

WORKDIR /opt

#Copy Code

COPY . ./mycode/
```

Then login into Github Docker:
<access_token> - Should have Read Packages permission
```sh
docker login docker.pkg.github.com -u <username> -p <access_token>
```

Build Image:
```sh
docker build -t my_custom_cxcli:latest . --no-cache
```

Run Container:
```sh
docker run my_custom_cxcli:latest Scan -CxServer http://localhost -CxUser admin@cx -CxPassword password -ProjectName /CxServer/SP/Company/Team/myproject -LocationType folder -LocationPath ./mycode -Log log.log -v
```

# Local Checkout

The Local Checkout option provides the following features:

* Stages the source pull in the Docker container when working with remote SCM systems.
* Optionally allows for some local workflow scripts to be executed.

To invoke the Local Checkout feature, insert `LocalCheckout` as the first argument to the CxCLI plugin.  The second and subsequent arguments would be the those normally passed to the CxCLI plugin.

## Filtering Files/Paths that are not Compatible with Windows

Using `LocalCheckout` it is possible to filter files and/or paths that can not be written to a Windows OS.  The CxCLI `-locationfilesexclude` and `-locationpathexclude` options allow
files to be excluded when the remainder of the source is zipped and submitted to the CxSAST server.

## Executing User-Defined Scripts

After the source code is fetched from the SCM and before it is packaged for submission to the CxSAST server, executable files found in the `/post-fetch` folder will be executed in
arbitrary order.  Each script will receive the path to the root of the fetched code as the first argument, and the value of the `-locationtype` CxCLI argument as the second argument.

Typical use-cases for a post-fetch script are:

* Apply more customized logic to remove/rename files/paths with names that are incompatible with the Windows OS
* Perform code organization to make it better suited to submit for CxSAST scanning
* Perform transpilation of code to allow it to be compatible with CxSAST scanning capability

It is usually a better idea to perform these types of operations in the build pipeline, but occasionally this capability can be useful when integration into a CI/CD tool is not readily available.
