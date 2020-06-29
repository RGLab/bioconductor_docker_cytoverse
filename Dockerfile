ARG CYTOVERSE_DOCKER_VERSION=3.11.0.9007

# Build gs-to-flowjo binary
FROM bioconductor/bioconductor_docker:devel as builder
ARG GITHUB_PAT
RUN apt-get update \
    && apt-get install -y g++ libboost-all-dev cmake 
RUN git clone https://github.com/RGLab/cytolib.git --depth=1 --branch=master --single-branch \
    && git clone https://${GITHUB_PAT}@github.com/RGLab/cytolib-ml.git --depth=1 --branch=master --single-branch
RUN cd cytolib && cmake . && make install -j4 && cd ..
WORKDIR cytolib-ml
RUN mkdir build
WORKDIR build
RUN cmake .. && make install -j4

# Start at bioc devel
FROM bioconductor/bioconductor_docker:devel

# Pull over the gs-to-flowjo binary
COPY --from=builder /usr/local/bin/gs-to-flowjo /usr/local/bin

# Update label for submission to bioconductor
LABEL name="rglab/bioconductor_docker_cytoverse" \
      version="devel" \
      url="https://github.com/RGLab/bioconductor_docker_cytoverse" \
      maintainer="jpwagner@fredhutch.org" \
      description="Bioconductor docker image with bundled RGLab cytometry packages" \
      license="Artistic-2.0"

WORKDIR cytoverse_repos

RUN R -e 'BiocManager::install(version = "devel", ask = FALSE)'

RUN git clone https://github.com/RGLab/RProtoBufLib.git --depth=1 --branch=master --single-branch \
    && git clone https://github.com/RGLab/cytolib.git --depth=1 --branch=master --single-branch \
    && git clone https://github.com/RGLab/flowCore.git --depth=1 --branch=master --single-branch \
    && git clone https://github.com/RGLab/flowViz.git --depth=1 --branch=master --single-branch \
    && git clone https://github.com/RGLab/ncdfFlow.git --depth=1 --branch=master --single-branch \
    && git clone https://github.com/RGLab/flowWorkspace.git --depth=1 --branch=master --single-branch \
    && git clone https://github.com/RGLab/flowWorkspaceData.git --depth=1 --branch=master --single-branch \
    && git clone https://github.com/RGLab/flowClust.git --depth=1 --branch=master --single-branch \
    && git clone https://github.com/RGLab/flowStats.git --depth=1 --branch=master --single-branch \
    && git clone https://github.com/RGLab/ggcyto.git --depth=1 --branch=master --single-branch \
    && git clone https://github.com/RGLab/openCyto.git --depth=1 --branch=master --single-branch \
    && git clone https://github.com/RGLab/CytoML.git --depth=1 --branch=master --single-branch \
    && git clone https://github.com/thebioengineer/colortable.git --depth=1 --branch=master --single-branch \
    && git clone https://github.com/RGLab/cytoqc.git --depth=1 --branch=master --single-branch

# Then build all appropriate packages
RUN R -e 'devtools::install_deps("RProtoBufLib", repos=BiocManager::repositories(version = "devel"), upgrade = "never")' \
    && R CMD build RProtoBufLib --no-build-vignettes \
    && R CMD INSTALL RProtoBufLib_* \
    && R -e 'devtools::install_deps("cytolib", repos=BiocManager::repositories(version = "devel"), upgrade = "never")' \
    && R CMD build cytolib --no-build-vignettes \
    && R CMD INSTALL cytolib_* \
    && R -e 'devtools::install_deps("flowCore", repos=BiocManager::repositories(version = "devel"), upgrade = "never")' \
    && R CMD build flowCore --no-build-vignettes \
    && R CMD INSTALL flowCore_* \
    && R -e 'devtools::install_deps("flowViz", repos=BiocManager::repositories(version = "devel"), upgrade = "never")' \
    && R CMD build flowViz --no-build-vignettes \
    && R CMD INSTALL flowViz_* \
    && R -e 'devtools::install_deps("ncdfFlow", repos=BiocManager::repositories(version = "devel"), upgrade = "never")' \
    && R CMD build ncdfFlow --no-build-vignettes \
    && R CMD INSTALL ncdfFlow_* \
    && R -e 'devtools::install_deps("flowWorkspace", repos=BiocManager::repositories(version = "devel"), upgrade = "never")' \
    && R CMD build flowWorkspace --no-build-vignettes \
    && R CMD INSTALL flowWorkspace_* \
    && R -e 'devtools::install_deps("flowWorkspaceData", repos=BiocManager::repositories(version = "devel"), upgrade = "never")' \
    && R CMD build flowWorkspaceData --no-build-vignettes \
    && R CMD INSTALL flowWorkspaceData_* \
    && R -e 'devtools::install_deps("flowClust", repos=BiocManager::repositories(version = "devel"), upgrade = "never")' \
    && R CMD build flowClust --no-build-vignettes \
    && R CMD INSTALL flowClust_* \
    && R -e 'devtools::install_deps("flowStats", repos=BiocManager::repositories(version = "devel"), upgrade = "never")' \
    && R CMD build flowStats --no-build-vignettes \
    && R CMD INSTALL flowStats_* \
    && R -e 'devtools::install_deps("ggcyto", repos=BiocManager::repositories(version = "devel"), upgrade = "never")' \
    && R CMD build ggcyto --no-build-vignettes \
    && R CMD INSTALL ggcyto_* \
    && R -e 'devtools::install_deps("openCyto", repos=BiocManager::repositories(version = "devel"), upgrade = "never")' \
    && R CMD build openCyto --no-build-vignettes \
    && R CMD INSTALL openCyto_* \
    && R -e 'devtools::install_deps("CytoML", repos=BiocManager::repositories(version = "devel"), upgrade = "never")' \
    && R CMD build CytoML --no-build-vignettes \
    && R CMD INSTALL CytoML_* \
    && R -e 'devtools::install_deps("colortable", repos=BiocManager::repositories(version = "devel"), upgrade = "never")' \
    && R CMD build colortable --no-build-vignettes \
    && R CMD INSTALL colortable_* \
    && R -e 'devtools::install_deps("cytoqc", repos=BiocManager::repositories(version = "devel"), upgrade = "never")' \
    && R CMD build cytoqc --no-build-vignettes \
    && R CMD INSTALL cytoqc_*

RUN rm -rf /cytoverse_repos
