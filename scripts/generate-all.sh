#!/bin/bash
# =============================================================================
# 全ダンプファイル一括生成スクリプト
# ホストから実行: bash scripts/generate-all.sh
# =============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
CONTAINER="oracle-testdump"

echo "========================================"
echo " OraDB DUMP Viewer - テストダンプ一括生成"
echo "========================================"

# Oracle 起動待機
echo "[Step 0] Oracle Database 起動待機..."
bash "${SCRIPT_DIR}/wait-for-oracle.sh"

# =============================================================
# Step 1: テストデータ投入
# =============================================================
echo ""
echo "[Step 1] テストデータ投入中..."

# SYSTEM ユーザーで初期セットアップ
echo "  -> 00_setup_users.sql (ユーザー・権限作成)..."
docker exec -i ${CONTAINER} sqlplus -s system/oracle@localhost:1521/FREEPDB1 \
    < "${SCRIPT_DIR}/sql/00_setup_users.sql"

# ODV_TEST ユーザーで各テーブル作成
for sql_file in 01_basic_types 02_lob_types 03_datetime_types 04_numeric_types \
                05_nchar_types 06_edge_cases 08_xmltype_raw 09_all_oracle_types \
                10_advanced_scenarios 11_japanese_tables; do
    echo "  -> ${sql_file}.sql..."
    docker exec -i ${CONTAINER} sqlplus -s ODV_TEST/odv_test@localhost:1521/FREEPDB1 \
        < "${SCRIPT_DIR}/sql/${sql_file}.sql"
done

# ODV_TEST2 ユーザーでテーブル作成
echo "  -> 07_multi_schema.sql (ODV_TEST2)..."
docker exec -i ${CONTAINER} sqlplus -s ODV_TEST2/odv_test2@localhost:1521/FREEPDB1 \
    < "${SCRIPT_DIR}/sql/07_multi_schema.sql"

echo "[Step 1] テストデータ投入完了"

# =============================================================
# Step 2: EXPDP ダンプ生成
# =============================================================
echo ""
echo "[Step 2] EXPDP ダンプ生成中..."

# シェルスクリプトをコンテナにコピーして実行
for script in export_expdp export_expdp_compress export_expdp_options; do
    docker cp "${SCRIPT_DIR}/shell/${script}.sh" ${CONTAINER}:/tmp/${script}.sh
    docker exec ${CONTAINER} bash /tmp/${script}.sh
done

echo "[Step 2] EXPDP ダンプ生成完了"

# =============================================================
# Step 3: EXP (レガシー) ダンプ生成 (利用可能な場合)
# =============================================================
echo ""
echo "[Step 3] EXP ダンプ生成中..."

docker cp "${SCRIPT_DIR}/shell/export_exp.sh" ${CONTAINER}:/tmp/export_exp.sh
docker exec ${CONTAINER} bash /tmp/export_exp.sh

echo "[Step 3] EXP ダンプ生成完了"

# =============================================================
# 結果サマリ
# =============================================================
echo ""
echo "========================================"
echo " 生成結果"
echo "========================================"
echo ""
echo "output/ ディレクトリの内容:"
ls -lh "${PROJECT_DIR}/output/"*.dmp 2>/dev/null || echo "  (ダンプファイルなし - Docker ボリューム経由で output/ に出力されているか確認)"
echo ""
echo "コンテナ内のダンプファイル:"
docker exec ${CONTAINER} ls -lh /opt/oracle/dump/*.dmp 2>/dev/null || echo "  (なし)"
echo ""
echo "========================================"
echo " 完了"
echo "========================================"
