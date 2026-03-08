#!/bin/bash
# =============================================================================
# EXPDP (DataPump) ダンプファイル生成
# Oracle コンテナ内で実行
# =============================================================================
set -euo pipefail

DUMP_DIR="/opt/oracle/dump"
CONN_SYS="sys/oracle@localhost:1521/FREEPDB1 AS SYSDBA"

echo "========================================"
echo " EXPDP ダンプファイル生成"
echo "========================================"

# --- EXPDP: スキーマモード (ODV_TEST のみ) ---
echo "[1/5] expdp_schema_odv_test.dmp (スキーマモード: ODV_TEST)..."
expdp system/oracle@localhost:1521/FREEPDB1 \
    SCHEMAS=ODV_TEST \
    DIRECTORY=dump_dir \
    DUMPFILE=expdp_schema_odv_test.dmp \
    LOGFILE=expdp_schema_odv_test.log \
    REUSE_DUMPFILES=YES

# --- EXPDP: スキーマモード (ODV_TEST2 のみ) ---
echo "[2/5] expdp_schema_odv_test2.dmp (スキーマモード: ODV_TEST2)..."
expdp system/oracle@localhost:1521/FREEPDB1 \
    SCHEMAS=ODV_TEST2 \
    DIRECTORY=dump_dir \
    DUMPFILE=expdp_schema_odv_test2.dmp \
    LOGFILE=expdp_schema_odv_test2.log \
    REUSE_DUMPFILES=YES

# --- EXPDP: 複数スキーマ ---
echo "[3/5] expdp_multi_schema.dmp (複数スキーマ)..."
expdp system/oracle@localhost:1521/FREEPDB1 \
    SCHEMAS=ODV_TEST,ODV_TEST2 \
    DIRECTORY=dump_dir \
    DUMPFILE=expdp_multi_schema.dmp \
    LOGFILE=expdp_multi_schema.log \
    REUSE_DUMPFILES=YES

# --- EXPDP: テーブルモード (指定テーブルのみ) ---
echo "[4/5] expdp_tables.dmp (テーブルモード)..."
expdp ODV_TEST/odv_test@localhost:1521/FREEPDB1 \
    TABLES=T_BASIC_TYPES,T_NUMERIC_TYPES,T_DATETIME_TYPES,T_LOB_TYPES,T_NCHAR_TYPES \
    DIRECTORY=dump_dir \
    DUMPFILE=expdp_tables.dmp \
    LOGFILE=expdp_tables.log \
    REUSE_DUMPFILES=YES

# --- EXPDP: FULL モード ---
echo "[5/5] expdp_full.dmp (FULL モード)..."
expdp system/oracle@localhost:1521/FREEPDB1 \
    FULL=YES \
    DIRECTORY=dump_dir \
    DUMPFILE=expdp_full.dmp \
    LOGFILE=expdp_full.log \
    REUSE_DUMPFILES=YES \
    EXCLUDE=SCHEMA:\"IN \(\'SYS\',\'SYSTEM\',\'OUTLN\',\'DBSNMP\',\'XDB\',\'CTXSYS\',\'MDSYS\',\'ORDDATA\',\'ORDSYS\',\'WMSYS\',\'APEX_PUBLIC_USER\',\'FLOWS_FILES\',\'HR\',\'OE\',\'PM\',\'IX\',\'SH\',\'BI\'\)\"

echo ""
echo "EXPDP ダンプファイル生成完了:"
ls -lh ${DUMP_DIR}/expdp_*.dmp 2>/dev/null || echo "(ファイルなし)"
