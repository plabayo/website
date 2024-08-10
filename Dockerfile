FROM rust:1-bookworm as builder

RUN apt-get update && \
    apt-get install --no-install-recommends -y cmake clang

WORKDIR /usr/src/app
COPY . .
# Will build and cache the binary and dependent crates in release mode
RUN --mount=type=cache,target=/usr/local/cargo,from=rust:latest,source=/usr/local/cargo \
    --mount=type=cache,target=target \
    cargo build --release && mkdir ./bin && mv ./target/release/plabayo_www ./bin/plabayo_www && mv ./static ./bin/static

# Runtime image
FROM debian:bookworm-slim

WORKDIR /app

# Get compiled binaries from builder's cargo install directory
COPY --from=builder /usr/src/app/bin/plabayo_www /app/plabayo_www
COPY --from=builder /usr/src/app/bin/static /app/static

# Run the app
ENTRYPOINT ["/app/plabayo_www", "-i", "0.0.0.0", "-d", "/app/static"]
