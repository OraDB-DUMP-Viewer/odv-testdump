#!/bin/bash
# =============================================================================
# EXP (レガシー Export) ダンプファイル生成
# Oracle コンテナ内で実行
#
# ※ Oracle 23ai Free では exp コマンドが廃止されている場合があります。
#    その場合はこのスクリプトはスキップされます。
# =============================================================================
set -euo pipefail

DUMP_DIR="/opt/oracle/dump"

echo "========================================"
echo " EXP (レガシー) ダンプファイル生成"
echo "========================================"

# exp コマンドの存在確認
if ! command -v exp &>/dev/null; then
    echo "WARNING: exp コマンドが見つかりません。"
    echo "Oracle 23ai Free では exp は廃止されています。"
    echo "EXP ダンプが必要な場合は Oracle 11g/12c/19c 環境をご利用ください。"
    echo ""
    echo "EXP ダンプ生成をスキップします。"
    exit 0
fi

# --- EXP: テーブルモード (TABLES) ---
echo "[1/4] exp_tables.dmp (TABLES モード)..."
exp ODV_TEST/odv_test@localhost:1521/FREEPDB1 \
    TABLES=\(T_BASIC_TYPES,T_NUMERIC_TYPES,T_DATETIME_TYPES\) \
    FILE=${DUMP_DIR}/exp_tables.dmp \
    LOG=${DUMP_DIR}/exp_tables.log \
    STATISTICS=NONE

# --- EXP: ユーザーモード (OWNER) ---
echo "[2/4] exp_user.dmp (OWNER モード)..."
exp ODV_TEST/odv_test@localhost:1521/FREEPDB1 \
    OWNER=ODV_TEST \
    FILE=${DUMP_DIR}/exp_user.dmp \
    LOG=${DUMP_DIR}/exp_user.log \
    STATISTICS=NONE

# --- EXP: DIRECT=Y (ダイレクトパス) ---
echo "[3/4] exp_direct.dmp (DIRECT=Y)..."
exp ODV_TEST/odv_test@localhost:1521/FREEPDB1 \
    OWNER=ODV_TEST \
    FILE=${DUMP_DIR}/exp_direct.dmp \
    LOG=${DUMP_DIR}/exp_direct.log \
    DIRECT=Y \
    STATISTICS=NONE

# --- EXP: FULL モード ---
echo "[4/4] exp_full.dmp (FULL=Y)..."
exp system/oracle@localhost:1521/FREEPDB1 \
    FULL=Y \
    FILE=${DUMP_DIR}/exp_full.dmp \
    LOG=${DUMP_DIR}/exp_full.log \
    STATISTICS=NONE

echo ""
echo "EXP ダンプファイル生成完了:"
ls -lh ${DUMP_DIR}/exp_*.dmp 2>/dev/null || echo "(ファイルなし)"
