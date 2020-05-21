ARG BIOC_VERSION=RELEASE_3_11

# Build gs-to-flowjo binary
FROM bioconductor/bioconductor_docker:$BIOC_VERSION as builder

ARG BIOC_VERSION
ARG GITHUB_PAT

RUN apt-get update \
    && apt-get install -y g++ libboost-all-dev cmake 
RUN git clone https://git.bioconductor.org/packages/cytolib --depth=1 --branch=$BIOC_VERSION --single-branch  \
    && git clone https://${GITHUB_PAT}@github.com/FredHutch/cytolib-ml.git --depth=1 --branch=$BIOC_VERSION --single-branch
RUN cd cytolib && cmake . && make install -j4 && cd ..
WORKDIR cytolib-ml
RUN mkdir build
WORKDIR build
RUN cmake .. && make install -j4

# Start at bioc release
FROM bioconductor/bioconductor_docker:$BIOC_VERSION
ARG BIOC_VERSION

# Pull over the gs-to-flowjo binary
COPY --from=builder /usr/local/bin/gs-to-flowjo /usr/local/bin

# Update label for submission to bioconductor
LABEL name="rglab/bioconductor_docker_cytoverse" \
      version="BIOC_${BIOC_VERSION}" \
      url="https://github.com/RGlab/bioconductor_docker_cytoverse" \
      maintainer="jpwagner@fredhutch.org" \
      description="Bioconductor docker image with bundled RGLab cytometry packages" \
      license="Artistic-2.0"

WORKDIR cytoverse_repos

RUN git clone https://git.bioconductor.org/packages/RProtoBufLib --depth=1 --branch=$BIOC_VERSION --single-branch \
    && git clone https://git.bioconductor.org/packages/cytolib --depth=1 --branch=$BIOC_VERSION --single-branch \
    && git clone https://git.bioconductor.org/packages/flowCore --depth=1 --branch=$BIOC_VERSION --single-branch \
    && git clone https://git.bioconductor.org/packages/flowViz --depth=1 --branch=$BIOC_VERSION --single-branch \
    && git clone https://git.bioconductor.org/packages/ncdfFlow --depth=1 --branch=$BIOC_VERSION --single-branch \
    && git clone https://git.bioconductor.org/packages/flowWorkspace --depth=1 --branch=$BIOC_VERSION --single-branch \
    && git clone https://git.bioconductor.org/packages/flowWorkspaceData --depth=1 --branch=$BIOC_VERSION --single-branch \
    && git clone https://git.bioconductor.org/packages/flowClust --depth=1 --branch=$BIOC_VERSION --single-branch \
    && git clone https://git.bioconductor.org/packages/flowStats --depth=1 --branch=$BIOC_VERSION --single-branch \
    && git clone https://git.bioconductor.org/packages/ggcyto --depth=1 --branch=$BIOC_VERSION --single-branch \
    && git clone https://git.bioconductor.org/packages/openCyto --depth=1 --branch=$BIOC_VERSION --single-branch \
    && git clone https://git.bioconductor.org/packages/CytoML --depth=1 --branch=$BIOC_VERSION --single-branch

RUN R -e 'devtools::install_deps("RProtoBufLib", repos=BiocManager::repositories(), upgrade = "never")' \
    && R CMD build RProtoBufLib --no-build-vignettes \
    && R CMD INSTALL RProtoBufLib_* \
    && R -e 'devtools::install_deps("cytolib", repos=BiocManager::repositories(), upgrade = "never")' \
    && R CMD build cytolib --no-build-vignettes \
    && R CMD INSTALL cytolib_* \
    && R -e 'devtools::install_deps("flowCore", repos=BiocManager::repositories(), upgrade = "never")' \
    && R CMD build flowCore --no-build-vignettes \
    && R CMD INSTALL flowCore_* \
    && R -e 'devtools::install_deps("flowViz", repos=BiocManager::repositories(), upgrade = "never")' \
    && R CMD build flowViz --no-build-vignettes \
    && R CMD INSTALL flowViz_* \
    && R -e 'devtools::install_deps("ncdfFlow", repos=BiocManager::repositories(), upgrade = "never")' \
    && R CMD build ncdfFlow --no-build-vignettes \
    && R CMD INSTALL ncdfFlow_* \
    && R -e 'devtools::install_deps("flowWorkspace", repos=BiocManager::repositories(), upgrade = "never")' \
    && R CMD build flowWorkspace --no-build-vignettes \
    && R CMD INSTALL flowWorkspace_* \
    && R -e 'devtools::install_deps("flowWorkspaceData", repos=BiocManager::repositories(), upgrade = "never")' \
    && R CMD build flowWorkspaceData --no-build-vignettes \
    && R CMD INSTALL flowWorkspaceData_* \
    && R -e 'devtools::install_deps("flowClust", repos=BiocManager::repositories(), upgrade = "never")' \
    && R CMD build flowClust --no-build-vignettes \
    && R CMD INSTALL flowClust_* \
    && R -e 'devtools::install_deps("flowStats", repos=BiocManager::repositories(), upgrade = "never")' \
    && R CMD build flowStats --no-build-vignettes \
    && R CMD INSTALL flowStats_* \
    && R -e 'devtools::install_deps("ggcyto", repos=BiocManager::repositories(), upgrade = "never")' \
    && R CMD build ggcyto --no-build-vignettes \
    && R CMD INSTALL ggcyto_* \
    && R -e 'devtools::install_deps("openCyto", repos=BiocManager::repositories(), upgrade = "never")' \
    && R CMD build openCyto --no-build-vignettes \
    && R CMD INSTALL openCyto_* \
    && R -e 'devtools::install_deps("CytoML", repos=BiocManager::repositories(), upgrade = "never")' \
    && R CMD build CytoML --no-build-vignettes \
    && R CMD INSTALL CytoML_*

RUN rm -rf /cytoverse_repos
