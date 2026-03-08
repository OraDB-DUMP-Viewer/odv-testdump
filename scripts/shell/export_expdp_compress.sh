#!/bin/bash
# =============================================================================
# EXPDP 圧縮ダンプファイル生成
# Oracle コンテナ内で実行
# =============================================================================
set -euo pipefail

DUMP_DIR="/opt/oracle/dump"

echo "========================================"
echo " EXPDP 圧縮ダンプファイル生成"
echo "========================================"

# --- EXPDP: 圧縮 ALL ---
echo "[1/3] expdp_compress_all.dmp (COMPRESSION=ALL)..."
expdp ODV_TEST/odv_test@localhost:1521/FREEPDB1 \
    SCHEMAS=ODV_TEST \
    DIRECTORY=dump_dir \
    DUMPFILE=expdp_compress_all.dmp \
    LOGFILE=expdp_compress_all.log \
    COMPRESSION=ALL \
    REUSE_DUMPFILES=YES

# --- EXPDP: 圧縮 DATA_ONLY ---
echo "[2/3] expdp_compress_data.dmp (COMPRESSION=DATA_ONLY)..."
expdp ODV_TEST/odv_test@localhost:1521/FREEPDB1 \
    SCHEMAS=ODV_TEST \
    DIRECTORY=dump_dir \
    DUMPFILE=expdp_compress_data.dmp \
    LOGFILE=expdp_compress_data.log \
    COMPRESSION=DATA_ONLY \
    REUSE_DUMPFILES=YES

# --- EXPDP: 圧縮 METADATA_ONLY ---
echo "[3/3] expdp_compress_metadata.dmp (COMPRESSION=METADATA_ONLY)..."
expdp ODV_TEST/odv_test@localhost:1521/FREEPDB1 \
    SCHEMAS=ODV_TEST \
    DIRECTORY=dump_dir \
    DUMPFILE=expdp_compress_metadata.dmp \
    LOGFILE=expdp_compress_metadata.log \
    COMPRESSION=METADATA_ONLY \
    REUSE_DUMPFILES=YES

echo ""
echo "EXPDP 圧縮ダンプファイル生成完了:"
ls -lh ${DUMP_DIR}/expdp_compress_*.dmp 2>/dev/null || echo "(ファイルなし)"
