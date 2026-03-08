#!/bin/bash
# =============================================================================
# EXPDP 各種オプション付きダンプファイル生成
# Oracle コンテナ内で実行
# =============================================================================
set -euo pipefail

DUMP_DIR="/opt/oracle/dump"

echo "========================================"
echo " EXPDP オプション別ダンプファイル生成"
echo "========================================"

# --- EXPDP: DATA_ONLY (DDL なし、データのみ) ---
echo "[1/4] expdp_data_only.dmp (CONTENT=DATA_ONLY)..."
expdp ODV_TEST/odv_test@localhost:1521/FREEPDB1 \
    SCHEMAS=ODV_TEST \
    DIRECTORY=dump_dir \
    DUMPFILE=expdp_data_only.dmp \
    LOGFILE=expdp_data_only.log \
    CONTENT=DATA_ONLY \
    REUSE_DUMPFILES=YES

# --- EXPDP: METADATA_ONLY (メタデータのみ、データなし) ---
echo "[2/4] expdp_metadata_only.dmp (CONTENT=METADATA_ONLY)..."
expdp ODV_TEST/odv_test@localhost:1521/FREEPDB1 \
    SCHEMAS=ODV_TEST \
    DIRECTORY=dump_dir \
    DUMPFILE=expdp_metadata_only.dmp \
    LOGFILE=expdp_metadata_only.log \
    CONTENT=METADATA_ONLY \
    REUSE_DUMPFILES=YES

# --- EXPDP: QUERY フィルタ付き ---
echo "[3/4] expdp_query_filter.dmp (QUERY フィルタ)..."
expdp ODV_TEST/odv_test@localhost:1521/FREEPDB1 \
    TABLES=T_LARGE_TABLE \
    DIRECTORY=dump_dir \
    DUMPFILE=expdp_query_filter.dmp \
    LOGFILE=expdp_query_filter.log \
    QUERY=T_LARGE_TABLE:'"WHERE ID <= 100"' \
    REUSE_DUMPFILES=YES

# --- EXPDP: パラレル (複数ファイル) ---
echo "[4/4] expdp_parallel.dmp (PARALLEL=2)..."
expdp ODV_TEST/odv_test@localhost:1521/FREEPDB1 \
    SCHEMAS=ODV_TEST \
    DIRECTORY=dump_dir \
    DUMPFILE=expdp_parallel_%U.dmp \
    LOGFILE=expdp_parallel.log \
    PARALLEL=2 \
    REUSE_DUMPFILES=YES

echo ""
echo "EXPDP オプション別ダンプファイル生成完了:"
ls -lh ${DUMP_DIR}/expdp_*.dmp 2>/dev/null || echo "(ファイルなし)"
