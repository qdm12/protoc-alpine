# Protoc Alpine

Protoc compiled statically in an Alpine Docker image.

## 🐋 Tags available

- `:latest` mirrors the `main` branch
- `:v3.14.0` for protoc v3.14.0 built on Alpine 3.12
- [Create an issue](https://github.com/qdm12/protoc-alpine/issues/new) if you need a specific version

## CPU architectures

The image is built for:

- linux/amd64
- linux/386
- linux/arm64
- linux/arm/v7
- linux/arm/v6
- [Create an issue](https://github.com/qdm12/protoc-alpine/issues/new) if you need another CPU architecture supported

## Usage

### Copy it in your Alpine image

This is most useful for CI setup where you want protoc to generate your files.

```Dockerfile
FROM alpine:3.12
# Copy the binary
COPY --from=qmcgaw/protoc /usr/local/bin/protoc /usr/local/bin/protoc
# Copy the include proto files
COPY --from=qmcgaw/protoc /usr/local/lib/google /usr/local/lib/google
# ... (your other instructions)
```

### Use the image directly

```sh
docker run -it --rm -v "$(pwd)":/workspace -w /workspace qmcgaw/protoc
```

⚠️ To avoid permission issues, the image runs as `root` by default.

### Extend the image

```Dockerfile
FROM qmcgaw/protoc
# Place your instructions below
```

## TODOs
