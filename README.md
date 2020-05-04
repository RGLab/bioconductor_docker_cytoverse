# Docker container for Cytoverse packages

This Docker image is built off of the `devel` branch of [Bioconductor's base Docker image](https://hub.docker.com/r/bioconductor/bioconductor_docker) with the development branches of following packages installed (along with their dependencies).

* RProtoBufLib: [GitHub](https://github.com/RGLab/RProtoBufLib), [Bioconductor](https://www.bioconductor.org/packages/devel/bioc/html/RProtoBufLib.html)
* cytolib: [GitHub](https://github.com/RGLab/cytolib), [Bioconductor](https://www.bioconductor.org/packages/devel/bioc/html/cytolib.html)
* flowCore: [GitHub](https://github.com/RGLab/flowCore), [Bioconductor](https://www.bioconductor.org/packages/devel/bioc/html/flowCore.html)
* flowViz: [GitHub](https://github.com/RGLab/flowViz), [Bioconductor](https://www.bioconductor.org/packages/devel/bioc/html/flowViz.html)
* ncdfFlow: [GitHub](https://github.com/RGLab/ncdfFlow), [Bioconductor](https://www.bioconductor.org/packages/devel/bioc/html/ncdfFlow.html)
* flowWorkspace: [GitHub](https://github.com/RGLab/flowWorkspace), [Bioconductor](https://www.bioconductor.org/packages/devel/bioc/html/flowWorkspace.html)
* flowWorkspaceData: [GitHub](https://github.com/RGLab/flowWorkspaceData), [Bioconductor](https://www.bioconductor.org/packages/devel/bioc/html/flowWorkspaceData.html)
* flowClust: [GitHub](https://github.com/RGLab/flowClust), [Bioconductor](https://www.bioconductor.org/packages/devel/bioc/html/flowClust.html)
* flowStats: [GitHub](https://github.com/RGLab/flowStats), [Bioconductor](https://www.bioconductor.org/packages/devel/bioc/html/flowStats.html)
* ggcyto: [GitHub](https://github.com/RGLab/ggcyto), [Bioconductor](https://www.bioconductor.org/packages/devel/bioc/html/ggcyto.html)
* openCyto: [GitHub](https://github.com/RGLab/openCyto), [Bioconductor](https://www.bioconductor.org/packages/devel/bioc/html/openCyto.html)
* CytoML: [GitHub](https://github.com/RGLab/CytoML), [Bioconductor](https://www.bioconductor.org/packages/devel/bioc/html/CytoML.html)

This is provided as an option to make it easier for users of all platforms to use the packages for analysis of cytometry data without needing to worry about dependencies or platform-dependent aspects of installation. It will also be continuously updated to the newest versions of the packages, allowing users to stay up to date with a single `docker pull`.

## Usage

Please see Docker's documentation for general notes on using containers and getting started with installation on your system

* [Docker Overview](https://docs.docker.com/engine/docker-overview/)
* [Get Started](https://www.docker.com/get-started)

## Getting Started

As this Docker image is built directly on the Bioconductor docker image, it can be used in the same way, with the only difference being
you will default have access to the additional packages listed above. Please see see the documentation on [Bioconductor Docker](https://hub.docker.com/r/bioconductor/bioconductor_docker) regarding usage. To get the Cytoverse docker image to run in a container locally, simply execute the following command:

```
docker pull jpwagner/cytoverse:devel
```

You can then run the container and make an RStudio session available in the same way as for the base Bioconductor image:

```
 docker run \
     -e PASSWORD=bioc \
     -p 8787:8787 \
     jpwagner/cytoverse:devel
```

This will make an RStudio session available using a web browser at `https://localhost:8787`. The user will be `rstudio` and the password will be `bioc`.

For further information on additional topics including mounting storage volumes or modifying the images (for example adding in more packages), please consult the [Bioconductor Docker documentation](https://hub.docker.com/r/bioconductor/bioconductor_docker).