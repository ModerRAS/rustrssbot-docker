FROM rust:alpine AS builder
RUN apk update && \
    apk add cargo rustup git && \
    cd /home && \
    git clone -b 2.x --depth 1 https://github.com/iovxw/rssbot.git && \
    cd rssbot && \
    rustup install nightly && \
    rustup target add x86_64-unknown-linux-musl && \
    cargo +nightly build --release
FROM alpine:latest
RUN apk --no-cache add ca-certificates
COPY --from=builder \
    /home/rssbot/target/x86_64-unknown-linux-musl/release/rssbot \
    /usr/local/bin/
ENV DATAFILE="/rustrssbot/rssdata.json"
ENV TELEGRAM_BOT_TOKEN=""
VOLUME /rustrssbot
ENTRYPOINT /usr/local/bin/rssbot $DATAFILE $TELEGRAM_BOT_TOKEN
