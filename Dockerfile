FROM alpine:3.20

RUN apk add --no-cache wget tar libc6-compat && \
    addgroup -g 1000 -S appgroup && \
    adduser -u 1000 -S appuser -G appgroup

WORKDIR /app

COPY NOTICE.txt .

# 下载 sing-box 和 cloudflared
ARG SING_BOX_VERSION=1.12.24
RUN apk add --no-cache wget tar && \
    # 下载并解压 sing-box
    wget https://github.com/SagerNet/sing-box/releases/download/v${SING_BOX_VERSION}/sing-box-${SING_BOX_VERSION}-linux-amd64.tar.gz && \
    tar -zxvf sing-box-${SING_BOX_VERSION}-linux-amd64.tar.gz && \
    mv sing-box-${SING_BOX_VERSION}-linux-amd64/sing-box ./ && \
    rm -rf sing-box-${SING_BOX_VERSION}-linux-amd64* && \
    # 下载最新的 cloudflared (Linux AMD64 架构)
    wget https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 -O ./cloudflared && \
    chmod +x ./cloudflared && \
    apk del wget tar

# 复制配置文件和启动脚本
COPY config.json .
COPY entrypoint.sh .
RUN chmod +x entrypoint.sh && chown -R appuser:appgroup /app

USER appuser

EXPOSE 8080

# 改为通过 entrypoint.sh 启动
CMD ["./entrypoint.sh"]]
