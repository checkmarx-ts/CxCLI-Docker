# CxCLI-Docker
### Checkmarx CLI with Docker

https://hub.docker.com/r/miguelfreitas93/cxcli

### Download Links:
9.00.0 (latest) : https://download.checkmarx.com/9.0.0/Plugins/CxConsolePlugin-2020.2.18.zip

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
