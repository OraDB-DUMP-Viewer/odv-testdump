#!/bin/bash
# =============================================================================
# Oracle Database 起動待機スクリプト
# =============================================================================
set -euo pipefail

MAX_WAIT=600  # 最大10分
INTERVAL=10
ELAPSED=0

echo "Oracle Database の起動を待機中..."

while [ $ELAPSED -lt $MAX_WAIT ]; do
    if docker exec oracle-testdump sqlplus -s /nolog <<EOF 2>/dev/null | grep -q "ALIVE"
CONNECT system/oracle@localhost:1521/FREEPDB1
SET HEADING OFF FEEDBACK OFF
SELECT 'ALIVE' FROM dual;
EXIT;
EOF
    then
        echo "Oracle Database が起動しました (${ELAPSED}秒)"
        exit 0
    fi

    echo "  待機中... (${ELAPSED}/${MAX_WAIT}秒)"
    sleep $INTERVAL
    ELAPSED=$((ELAPSED + INTERVAL))
done

echo "ERROR: Oracle Database が ${MAX_WAIT}秒以内に起動しませんでした"
echo "ログを確認してください: docker logs oracle-testdump"
exit 1
