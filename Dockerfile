ARG ALPINE_VERSION=3.12

FROM alpine:${ALPINE_VERSION} AS protoc

# Install build dependencies
RUN apk add --update --no-cache autoconf automake libtool curl make g++ unzip

# Download source code
WORKDIR /tmp/protoc
ARG PROTOC_VERSION=3.14.0
RUN wget -qO- https://github.com/protocolbuffers/protobuf/releases/download/v${PROTOC_VERSION}/protobuf-all-${PROTOC_VERSION}.tar.gz | \
    tar -xz --strip-components=1

# Build static binary and include proto files
RUN ./configure \
    --disable-shared \
    --enable-static \
    --disable-dependency-tracking \
    --disable-maintainer-mode \
    LDFLAGS="-static-libgcc -static-libstdc++"
RUN make
# Commented as too time consuming for X-arch builds
# RUN make check

# Cleanup include directory
RUN apk add --update --no-cache findutils && \
    find src/google/protobuf/ -type f ! -name '*.proto' -delete && \
    find src/google/protobuf/ -type d -name '*test*' -exec rm -r {} + && \
    find src/google/protobuf/ -type f -name '*test*' -delete && \
    find src/google/protobuf/ -type d -empty -delete

FROM alpine:${ALPINE_VERSION}
COPY --from=protoc --chown=1000:1000 /tmp/protoc/src/protoc /usr/local/bin/protoc
COPY --from=protoc --chown=1000:1000 /tmp/protoc/src/google /usr/local/lib/
