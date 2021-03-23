################################################################################
# This Dockerfile was generated from the template at:
#   src/dev/build/tasks/os_packages/docker_generator/templates/Dockerfile
#
# Beginning of multi stage Dockerfile
################################################################################

################################################################################
# Build stage 0 `builder`:
# Extract Kibana artifact
################################################################################
FROM arm64v8/centos:8 AS builder


RUN cd /opt && \
  curl --retry 8 -s -L -O https://artifacts.elastic.co/downloads/kibana/kibana-7.11.2-linux-x86_64.tar.gz && \
  cd -


RUN mkdir /usr/share/kibana
WORKDIR /usr/share/kibana
RUN tar --strip-components=1 -zxf /opt/kibana-7.11.2-linux-x86_64.tar.gz
# Ensure that group permissions are the same as user permissions.
# This will help when relying on GID-0 to run Kibana, rather than UID-1000.
# OpenShift does this, for example.
# REF: https://docs.openshift.org/latest/creating_images/guidelines.html



##########################################
# Remove packaged Node version
RUN rm -rf /usr/share/kibana/node
RUN mkdir /usr/share/kibana/node

# Download & Extract compatiable Node version
RUN curl -L -O https://nodejs.org/download/release/v14.15.4/node-v14.15.4-linux-arm64.tar.xz
RUN tar -xJvf node-v14.15.4-linux-arm64.tar.xz

# Move new Node version to Kibana directory
RUN mv ./node-v14.*/* /usr/share/kibana/node
RUN rm -rf node-v14.*
###########################################

# Recompile re2 node module for ARM64
WORKDIR /root
ENV PATH="/usr/share/kibana/node/bin:$PATH"
RUN yum install -y gcc-c++ make python2
RUN cd /root/ 
RUN npm install re2
RUN mv -f node_modules/re2/build/Release/re2.node /usr/share/kibana/node_modules/re2/build/Release/re2.node
###########################################


RUN chmod -R g=u /usr/share/kibana

################################################################################
# Build stage 1 (the actual Kibana image):
#
# Copy kibana from stage 
# Add entrypoint
################################################################################
FROM arm64v8/centos:8
EXPOSE 5601


RUN for iter in {1..10}; do \
      yum update --setopt=tsflags=nodocs -y && \
      yum install --setopt=tsflags=nodocs -y \
        fontconfig freetype shadow-utils nss && \
      yum clean all && exit_code=0 && break || exit_code=$? && echo "yum error: retry $iter in 10s" && \
      sleep 10; \
    done; \
    (exit $exit_code)

# Add an init process, check the checksum to make sure it's a match
RUN set -e ; \
  TINI_VERSION='v0.19.0' ; \
  TINI_BIN='tini-arm64' ; \
  curl --retry 8 -S -L -O "https://github.com/krallin/tini/releases/download/${TINI_VERSION}/${TINI_BIN}" ; \
  curl --retry 8 -S -L -O "https://github.com/krallin/tini/releases/download/${TINI_VERSION}/${TINI_BIN}.sha256sum" ; \
  sha256sum -c "${TINI_BIN}.sha256sum" ; \
  rm "${TINI_BIN}.sha256sum" ; \
  mv "${TINI_BIN}" /bin/tini ; \
  chmod +x /bin/tini

RUN mkdir /usr/share/fonts/local
RUN curl -L -o /usr/share/fonts/local/NotoSansCJK-Regular.ttc https://github.com/googlefonts/noto-cjk/raw/NotoSansV2.001/NotoSansCJK-Regular.ttc
RUN echo "5dcd1c336cc9344cb77c03a0cd8982ca8a7dc97d620fd6c9c434e02dcb1ceeb3  /usr/share/fonts/local/NotoSansCJK-Regular.ttc" | sha256sum -c -
RUN fc-cache -v

# Bring in Kibana from the initial stage.
COPY --from=builder --chown=1000:0 /usr/share/kibana /usr/share/kibana
WORKDIR /usr/share/kibana
RUN ln -s /usr/share/kibana /opt/kibana

ENV ELASTIC_CONTAINER true
ENV PATH=/usr/share/kibana/bin:$PATH

# Set some Kibana configuration defaults.
COPY --chown=1000:0 config/kibana.yml /usr/share/kibana/config/kibana.yml

# Add the launcher/wrapper script. It knows how to interpret environment
# variables and translate them to Kibana CLI options.
COPY --chown=1000:0 bin/kibana-docker /usr/local/bin/

# Ensure gid 0 write permissions for OpenShift.
RUN chmod g+ws /usr/share/kibana && \
    find /usr/share/kibana -gid 0 -and -not -perm /g+w -exec chmod g+w {} \;

# Remove the suid bit everywhere to mitigate "Stack Clash"
RUN find / -xdev -perm -4000 -exec chmod u-s {} +

# Provide a non-root user to run the process.
RUN groupadd --gid 1000 kibana && \
    useradd --uid 1000 --gid 1000 -G 0 \
      --home-dir /usr/share/kibana --no-create-home \
      kibana

LABEL org.label-schema.build-date="2021-02-08T22:42:18.324Z" \
  org.label-schema.license="Elastic License" \
  org.label-schema.name="Kibana" \
  org.label-schema.schema-version="1.0" \
  org.label-schema.url="https://www.elastic.co/products/kibana" \
  org.label-schema.usage="https://www.elastic.co/guide/en/kibana/reference/index.html" \
  org.label-schema.vcs-ref="3f71ce7177a41e067ddb1e670ec4ace5f6d4f5fe" \
  org.label-schema.vcs-url="https://github.com/elastic/kibana" \
  org.label-schema.vendor="Elastic" \
  org.label-schema.version="7.11.0" \
  org.opencontainers.image.created="2021-02-08T22:42:18.324Z" \
  org.opencontainers.image.documentation="https://www.elastic.co/guide/en/kibana/reference/index.html" \
  org.opencontainers.image.licenses="Elastic License" \
  org.opencontainers.image.revision="3f71ce7177a41e067ddb1e670ec4ace5f6d4f5fe" \
  org.opencontainers.image.source="https://github.com/elastic/kibana" \
  org.opencontainers.image.title="Kibana" \
  org.opencontainers.image.url="https://www.elastic.co/products/kibana" \
  org.opencontainers.image.vendor="Elastic" \
  org.opencontainers.image.version="7.11.1"


USER kibana

ENTRYPOINT ["/bin/tini", "--"]

CMD ["/usr/local/bin/kibana-docker"]
