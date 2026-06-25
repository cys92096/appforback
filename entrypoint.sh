#!/bin/sh

# 检查环境变量 TUNNEL_TOKEN 是否存在
if [ -z "$TUNNEL_TOKEN" ]; then
  echo "[错误] 未设置 TUNNEL_TOKEN 环境变量，cloudflared 无法启动！"
  exit 1
fi

# 在后台启动 cloudflared 隧道
echo "[启动] 正在连接 Cloudflare Tunnel..."
./cloudflared tunnel --no-autoupdate run --token "$TUNNEL_TOKEN" &

# 在前台启动 sing-box（让 Docker 进程保持运行）
echo "[启动] 正在启动 Sing-box..."
exec ./sing-box run "-c" "config.json"
