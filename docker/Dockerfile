# Dockerfile to build the matrixdotorg/synapse docker images.
#
# To build the image, run `docker build` command from the root of the
# synapse repository:
#
#    docker build -f docker/Dockerfile .

ARG DEBIAN_HASH=sha256:11253793361a12861562d1d7b15b8b7e25ac30dd631e3d206ed1ca969bf97b7d

###
### Stage 0: builder
###
FROM debian:buster-slim@${DEBIAN_HASH} as builder

# install the OS build deps

RUN \
    env DEBIAN_FRONTEND=noninteractive \
    && apt-get update -y \
    && apt-get install -y \
        build-essential=12.6 \
        libffi-dev:amd64=3.2.1-9 \
        sqlite3=3.27.2-3 \
        libssl-dev:amd64=1.1.1d-0+deb10u2 \
        libjpeg-dev=1:1.5.2-2 \
        libxslt1-dev:amd64=1.1.32-2.2~deb10u1 \
        python3-dev=3.7.3-1 \
        python3-pip=18.1-5 \
        python3-setuptools=40.8.0-1 \
        python3-virtualenv=15.1.0+ds-2 \
        python3-pil:amd64=5.4.1-2+deb10u1 \
        python3-psycopg2=2.7.7-1 \
        python3-cryptography=2.6.1-3+deb10u2 \
        python3-msgpack=0.5.6-1+b1 \
        python3-nacl=1.3.0-2 \
    && rm -rf /var/lib/apt/lists/*

# now install synapse and all of the python deps to /install.

COPY synapse /synapse/synapse/
COPY scripts /synapse/scripts/
COPY MANIFEST.in README.rst setup.py synctl /synapse/

RUN pip3 install --prefix="/install" --no-warn-script-location \
        /synapse[all]

###
### Stage 1: runtime
###

FROM debian:buster-slim@${DEBIAN_HASH}

RUN \
    env DEBIAN_FRONTEND=noninteractive \
    && apt-get update -y \
    && apt-get install -y \
        libffi6:amd64=3.2.1-9 \
        libjpeg62-turbo:amd64=1:1.5.2-2+b1 \
        libssl-dev:amd64=1.1.1d-0+deb10u2 \
        libxslt1.1:amd64=1.1.32-2.2~deb10u1 \
        libpq5:amd64=11.7-0+deb10u1 \
        zlibc=0.9k-4.3 \
        gosu=1.10-1+b23 \
        tzdata=2019c-0+deb10u1 \
        xmlsec1=1.2.27-2 \
        python3=3.7.3-1 \
        python3-jinja2=2.10-2 \
    && update-alternatives \
        --install /usr/bin/python python /usr/bin/python3.7 2 \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /install /usr/local
COPY ./docker/start.py /start.py
COPY ./docker/conf /conf

VOLUME ["/data"]

EXPOSE 8008/tcp 8009/tcp 8448/tcp

ENTRYPOINT ["/start.py"]
