FROM alpine:3.19 AS builder

ENV KEYCLOAK_VERSION=999.0.0-SNAPSHOT
ARG KEYCLOAK_DIST

# Install required packages for downloading
RUN apk add --no-cache tar gzip curl

# Create directory for Keycloak
RUN mkdir -p /tmp/keycloak

# Download or copy Keycloak distribution
ADD ${KEYCLOAK_DIST} /tmp/keycloak/

# The next step makes it uniform for local development and upstream built.
# If it is a local tar archive then it is unpacked, if from remote is just downloaded.
RUN (cd /tmp/keycloak && \
    tar -xvf /tmp/keycloak/keycloak-*.tar.gz && \
    rm /tmp/keycloak/keycloak-*.tar.gz) || true

RUN mkdir -p /opt/keycloak/data
RUN mv /tmp/keycloak/keycloak-* /opt/keycloak
RUN chmod -R g+rwX /opt/keycloak

FROM alpine:3.19
ENV LANG=en_US.UTF-8

# Install required packages and configure FIPS
RUN apk update && \
    apk upgrade && \
    apk add openjdk17 && \
    rm -rf /var/cache/apk/* && \
    # Create directory and add FIPS provider to make SAML work: https://www.keycloak.org/server/fips
    mkdir -p /etc/java-17-openjdk/security && \
    echo "fips.provider.7=XMLDSig" >> /etc/java-17-openjdk/security/java.security && \
    # User stuff
    echo "keycloak:x:2000:root" >> /etc/group && \
    echo "keycloak:x:2000:2000:keycloak user:/opt/keycloak:/sbin/nologin" >> /etc/passwd

# Flag for determining app is running in container
ENV KC_RUN_IN_CONTAINER=true

COPY --from=builder --chown=2000:2000 /opt/keycloak /opt/keycloak

USER 2000

EXPOSE 8080
EXPOSE 8443
EXPOSE 9000

ENTRYPOINT [ "/opt/keycloak/bin/kc.sh" ]

# common labels
ARG KEYCLOAK_VERSION
ARG KEYCLOAK_URL="https://www.keycloak.org/"
ARG KEYCLOAK_TAGS="keycloak security identity"
ARG KEYCLOAK_MAINTAINER=${KEYCLOAK_URL}
ARG KEYCLOAK_VENDOR=${KEYCLOAK_MAINTAINER}
ARG KEYCLOAK_DESCRIPTION="Keycloak - Open Source Identity and Access Management"

LABEL maintainer=${KEYCLOAK_MAINTAINER} \
      vendor=${KEYCLOAK_VENDOR} \
      version=${KEYCLOAK_VERSION} \
      url=${KEYCLOAK_URL} \
      io.openshift.tags=${KEYCLOAK_TAGS} \
      release="" \
      vcs-ref="" \
      com.redhat.build-host="" \
      com.redhat.component="" \
      com.redhat.license_terms=""

# server specific
ARG KEYCLOAK_SERVER_DISPLAY_NAME="Keycloak Server"
ARG KEYCLOAK_SERVER_IMAGE_NAME="keycloak"
ARG KEYCLOAK_SERVER_DESCRIPTION="${KEYCLOAK_SERVER_DISPLAY_NAME} Image"

LABEL name=${KEYCLOAK_SERVER_IMAGE_NAME} \
      description=${KEYCLOAK_SERVER_DESCRIPTION} \
      summary=${KEYCLOAK_SERVER_DESCRIPTION} \
      io.k8s.display-name=${KEYCLOAK_SERVER_DISPLAY_NAME} \
      io.k8s.description=${KEYCLOAK_SERVER_DESCRIPTION}

# oci
ARG KEYCLOAK_SOURCE="https://github.com/keycloak/keycloak"
ARG KEYCLOAK_DOCS=${KEYCLOAK_URL}documentation

LABEL org.opencontainers.image.title=${KEYCLOAK_SERVER_DISPLAY_NAME} \
      org.opencontainers.image.url=${KEYCLOAK_URL} \
      org.opencontainers.image.source=${KEYCLOAK_SOURCE} \
      org.opencontainers.image.description=${KEYCLOAK_DESCRIPTION} \
      org.opencontainers.image.documentation=${KEYCLOAK_DOCS}
