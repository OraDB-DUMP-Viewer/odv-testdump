#!/bin/bash
# =============================================================================
# Oracle テスト環境セットアップスクリプト
# Ubuntu Server に Docker + Oracle Database Free をセットアップ
# =============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

echo "========================================"
echo " OraDB DUMP Viewer - テスト環境セットアップ"
echo "========================================"

# ------------------------------------------------------------
# 1. Docker インストール (未インストールの場合)
# ------------------------------------------------------------
if ! command -v docker &>/dev/null; then
    echo "[1/3] Docker をインストール中..."
    apt-get update -qq
    apt-get install -y -qq ca-certificates curl gnupg lsb-release

    install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    chmod a+r /etc/apt/keyrings/docker.gpg

    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

    apt-get update -qq
    apt-get install -y -qq docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

    systemctl enable docker
    systemctl start docker
    echo "[1/3] Docker インストール完了"
else
    echo "[1/3] Docker は既にインストール済み"
fi

# ------------------------------------------------------------
# 2. Docker Compose 確認
# ------------------------------------------------------------
if docker compose version &>/dev/null; then
    echo "[2/3] Docker Compose (plugin) 確認OK"
else
    echo "[2/3] ERROR: docker compose が使用できません"
    exit 1
fi

# ------------------------------------------------------------
# 3. Oracle コンテナ起動
# ------------------------------------------------------------
echo "[3/3] Oracle Database コンテナを起動中..."
cd "$PROJECT_DIR"

# output ディレクトリの権限設定 (Oracle コンテナが書き込めるように)
mkdir -p output
chmod 777 output

docker compose up -d

echo ""
echo "========================================"
echo " セットアップ完了"
echo "========================================"
echo ""
echo "Oracle Database が起動するまで数分かかります。"
echo "起動待機するには:"
echo "  bash scripts/wait-for-oracle.sh"
echo ""
echo "テストデータ投入 + ダンプ生成:"
echo "  bash scripts/generate-all.sh"
echo ""
