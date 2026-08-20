#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════════════════════════
# setup-docker-ros2-humble.sh
#
# 在 Ubuntu 26.04 上:
#   1. 配置 Docker Hub 国内镜像加速(registry-mirrors,幂等合并,保留已有配置)
#   2. 拉取 ros:humble 镜像(走镜像加速)
#   3. 创建 ROS2 Humble 开发容器,挂载本地 workspace 目录
#
# 用法:bash setup-docker-ros2-humble.sh [--recreate]
#   --recreate  删除同名旧容器后重建
# 幂等:重复执行只刷新配置/复用已有容器,可放心重跑。
# ═══════════════════════════════════════════════════════════════════════════
set -euo pipefail

# ═══════════════ 可配置项 ═══════════════
# 镜像加速源,按优先级排列;某天失效了改这里(验证方法见配套文档)
MIRRORS=(
  "https://docker.xuanyuan.me"
  "https://docker.1ms.run"
  "https://docker.m.daocloud.io"
)
ROS_IMAGE="ros:humble"                                # 想要更精简可改 ros:humble-ros-base
CONTAINER_NAME="ros2-humble-dev"
HOST_WS="$HOME/workspace/01-coding/ros2-workspace"    # 宿主机目录(不存在会自动创建)
CTR_WS="/workspace"                                   # 容器内挂载点
# ═══════════════════════════════════

C_RED='\033[0;31m'
C_GREEN='\033[0;32m'
C_YELLOW='\033[0;33m'
C_NC='\033[0m'
log()  { printf "${C_GREEN}[*]${C_NC} %s\n" "$*"; }
warn() { printf "${C_YELLOW}[!]${C_NC} %s\n" "$*"; }
die()  { printf "${C_RED}[x]${C_NC} %s\n" "$*" >&2; exit 1; }

RECREATE=false
if [ "${1:-}" = "--recreate" ]; then
  RECREATE=true
fi

# ────────────── 1. 检查/安装 Docker ──────────────
if ! command -v docker >/dev/null 2>&1; then
  log "未检测到 docker,安装 docker.io..."
  sudo apt-get update && sudo apt-get install -y docker.io
fi
sudo systemctl enable --now docker >/dev/null 2>&1 || true

# 当前用户不在 docker 组时自动加入,并用 sg 方式继续执行后续 docker 命令
if docker info >/dev/null 2>&1; then
  run_docker() { docker "$@"; }
else
  warn "当前用户不在 docker 组,自动加入..."
  sudo usermod -aG docker "$USER"
  warn "已加入 docker 组;本脚本用 sg 继续执行,新开的终端将直接生效"
  run_docker() { sg docker -c "$(printf '%q ' docker "$@")"; }
fi

# ────────────── 2. 配置镜像加速 ──────────────
log "写入 /etc/docker/daemon.json(合并 registry-mirrors,保留已有配置)..."
sudo mkdir -p /etc/docker
if [ -f /etc/docker/daemon.json ]; then
  sudo cp -a /etc/docker/daemon.json "/etc/docker/daemon.json.bak.$(date +%Y%m%d%H%M%S)"
fi
sudo python3 - "$(printf '%s\n' "${MIRRORS[@]}")" <<'PY'
import json, sys, os
path = "/etc/docker/daemon.json"
mirrors = [m for m in sys.argv[1].splitlines() if m.strip()]
# 已知失效的公共源,自动从旧配置里清理
dead = ("dockerhub.icu", "dockerproxy.cn", "dockerpull.com", "dockerpull.org",
        "lynn520.xyz", "docker.mrxn.net", "mirrors.ustc.edu.cn",
        "mirrors.tuna.tsinghua.edu.cn", "hub-mirror.c.163.com",
        "registry.docker-cn.com")
cfg = {}
if os.path.exists(path):
    try:
        cfg = json.load(open(path))
    except Exception as e:
        sys.exit(f"daemon.json 解析失败: {e}")
old = [m for m in cfg.get("registry-mirrors", []) if not any(d in m for d in dead)]
cfg["registry-mirrors"] = list(dict.fromkeys(mirrors + old))
json.dump(cfg, open(path, "w"), indent=2, ensure_ascii=False)
print("registry-mirrors:", cfg["registry-mirrors"])
PY

log "重启 Docker 服务..."
sudo systemctl restart docker
for _ in $(seq 1 30); do
  sudo docker info >/dev/null 2>&1 && break
  sleep 1
done
sudo docker info | grep -A 8 "Registry Mirrors" || true

# ────────────── 3. 拉取 ROS2 Humble 镜像 ──────────────
log "拉取 $ROS_IMAGE(约 700MB+,第一次较慢)..."
run_docker pull "$ROS_IMAGE"

# ────────────── 4. 创建开发容器 ──────────────
mkdir -p "$HOST_WS"
if run_docker ps -a --format '{{.Names}}' | grep -qx "$CONTAINER_NAME"; then
  if [ "$RECREATE" = true ]; then
    log "删除旧容器 $CONTAINER_NAME(--recreate)..."
    run_docker rm -f "$CONTAINER_NAME"
  else
    warn "容器 $CONTAINER_NAME 已存在,跳过创建(加 --recreate 可重建)"
  fi
fi
if ! run_docker ps -a --format '{{.Names}}' | grep -qx "$CONTAINER_NAME"; then
  log "创建容器 $CONTAINER_NAME..."
  run_docker run -d \
    --name "$CONTAINER_NAME" \
    --network host \
    -e DISPLAY="${DISPLAY:-:0}" \
    -e QT_X11_NO_MITSHM=1 \
    -v /tmp/.X11-unix:/tmp/.X11-unix:ro \
    -v "$HOST_WS:$CTR_WS" \
    -w "$CTR_WS" \
    "$ROS_IMAGE" sleep infinity
fi

# 容器内 ~/.bashrc 自动 source ROS 环境(幂等)
if ! run_docker exec "$CONTAINER_NAME" bash -c 'grep -q "source /opt/ros/humble/setup.bash" ~/.bashrc 2>/dev/null'; then
  run_docker exec "$CONTAINER_NAME" bash -c 'echo "source /opt/ros/humble/setup.bash" >> ~/.bashrc'
fi

# ────────────── 5. 验证 ──────────────
log "验证容器内 ROS2 环境..."
run_docker exec "$CONTAINER_NAME" bash -c \
  'source /opt/ros/humble/setup.bash && echo "ROS_DISTRO=$ROS_DISTRO" && ros2 --help | head -n 3'

cat <<EOF

[*] 全部完成!
    进入容器:  docker exec -it $CONTAINER_NAME bash
    目录映射:  $HOST_WS  ↔  容器内 $CTR_WS
    GUI 应用:  容器内直接运行 rviz2(已透传 DISPLAY 与 X11 socket)
    文件权限:  容器内以 root 运行,新建文件属主为 root,
               宿主侧执行 sudo chown -R \$USER:\$USER $HOST_WS 修复
    镜像加速:  已写入 /etc/docker/daemon.json,可用 docker info 查看
EOF
