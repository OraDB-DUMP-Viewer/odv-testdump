# odv-testdump

OraDB DUMP Viewer のテスト用 Oracle ダンプファイル (.dmp) を生成する環境です。

Docker 上の Oracle Database Free を使用して、**Oracle の全データ型・全エクスポート形式・エッジケース** を網羅したダンプファイルを自動生成します。

## 前提条件

- Ubuntu Server (22.04 以降推奨)
- Docker + Docker Compose
- インターネット接続 (Oracle コンテナイメージの取得)

## クイックスタート

```bash
# 1. リポジトリをクローン
git clone https://github.com/OraDB-DUMP-Viewer/odv-testdump.git
cd odv-testdump

# 2. 初期セットアップ (Docker インストール + Oracle コンテナ起動)
sudo bash scripts/setup.sh

# 3. テストデータ投入 + ダンプファイル生成
bash scripts/generate-all.sh
```

生成されたダンプファイルは `output/` ディレクトリに出力されます。

## ディレクトリ構成

```
odv-testdump/
├── README.md
├── docker-compose.yml              # Oracle Database コンテナ定義
├── .gitignore
├── scripts/
│   ├── setup.sh                    # Docker + Oracle 初期セットアップ
│   ├── wait-for-oracle.sh          # Oracle 起動待機
│   ├── generate-all.sh             # 全ダンプファイル一括生成
│   ├── sql/
│   │   ├── 00_setup_users.sql      # テスト用ユーザー・権限・ディレクトリ作成
│   │   ├── 01_basic_types.sql      # CHAR / VARCHAR2 / LONG / 特殊文字
│   │   ├── 02_lob_types.sql        # BLOB / CLOB / NCLOB / BFILE
│   │   ├── 03_datetime_types.sql   # DATE / TIMESTAMP / INTERVAL
│   │   ├── 04_numeric_types.sql    # NUMBER / FLOAT / BINARY_FLOAT/DOUBLE
│   │   ├── 05_nchar_types.sql      # NCHAR / NVARCHAR2 (多言語)
│   │   ├── 06_edge_cases.sql       # 空テーブル / 幅広 / trailing NULL / 大量行
│   │   ├── 07_multi_schema.sql     # 複数スキーマ (ODV_TEST2)
│   │   ├── 08_xmltype_raw.sql      # XMLTYPE / RAW / LONG RAW / ROWID
│   │   ├── 09_all_oracle_types.sql # オブジェクト型 / JSON / BOOLEAN / SDO_GEOMETRY
│   │   ├── 10_advanced_scenarios.sql # パーティション / IOT / クラスタ / 仮想列
│   │   └── 11_japanese_tables.sql  # 日本語テーブル名・カラム名・日本語データ
│   └── shell/
│       ├── export_expdp.sh             # EXPDP 標準ダンプ生成
│       ├── export_expdp_compress.sh    # EXPDP 圧縮ダンプ生成
│       ├── export_expdp_options.sh     # EXPDP オプション別ダンプ生成
│       └── export_exp.sh              # EXP (レガシー) ダンプ生成
└── output/                         # 生成されたダンプファイル出力先
    └── .gitkeep
```

## 生成されるダンプファイル

### EXPDP (DataPump) - 標準

| ファイル | 内容 |
|---|---|
| `expdp_schema_odv_test.dmp` | スキーマモード (ODV_TEST) |
| `expdp_schema_odv_test2.dmp` | スキーマモード (ODV_TEST2) |
| `expdp_multi_schema.dmp` | 複数スキーマ (ODV_TEST + ODV_TEST2) |
| `expdp_tables.dmp` | テーブルモード (指定テーブルのみ) |
| `expdp_full.dmp` | FULL モード |

### EXPDP (DataPump) - 圧縮

| ファイル | 内容 |
|---|---|
| `expdp_compress_all.dmp` | COMPRESSION=ALL |
| `expdp_compress_data.dmp` | COMPRESSION=DATA_ONLY |
| `expdp_compress_metadata.dmp` | COMPRESSION=METADATA_ONLY |

### EXPDP (DataPump) - オプション別

| ファイル | 内容 |
|---|---|
| `expdp_data_only.dmp` | CONTENT=DATA_ONLY (データのみ) |
| `expdp_metadata_only.dmp` | CONTENT=METADATA_ONLY (メタデータのみ) |
| `expdp_query_filter.dmp` | QUERY フィルタ付き |
| `expdp_parallel_%U.dmp` | PARALLEL=2 (複数ファイル) |

### EXP (レガシー Export)

| ファイル | 内容 |
|---|---|
| `exp_tables.dmp` | TABLES モード (テーブル指定) |
| `exp_user.dmp` | OWNER モード (ユーザー指定) |
| `exp_direct.dmp` | DIRECT=Y (ダイレクトパス) |
| `exp_full.dmp` | FULL=Y (データベース全体) |

> **Note**: Oracle 23ai Free では `exp` コマンドが廃止されているため、EXP ダンプは生成されない場合があります。

## テストカバレッジ

### Oracle 全データ型

| カテゴリ | データ型 | テーブル |
|---|---|---|
| **文字列** | CHAR / VARCHAR2 / LONG | T_BASIC_TYPES |
| **Unicode** | NCHAR / NVARCHAR2 | T_NCHAR_TYPES |
| **数値** | NUMBER / INTEGER / FLOAT / REAL | T_NUMERIC_TYPES |
| **浮動小数** | BINARY_FLOAT / BINARY_DOUBLE | T_NUMERIC_TYPES |
| **日付** | DATE | T_DATETIME_TYPES |
| **タイムスタンプ** | TIMESTAMP(0-9) / WITH TIME ZONE / WITH LOCAL TIME ZONE | T_DATETIME_TYPES |
| **間隔** | INTERVAL YEAR TO MONTH / DAY TO SECOND | T_DATETIME_TYPES |
| **バイナリ** | RAW / LONG RAW | T_RAW_TYPES |
| **LOB** | BLOB / CLOB / NCLOB | T_LOB_TYPES, T_LOB_MIXED |
| **ファイル** | BFILE | T_BFILE_TYPES |
| **XML** | XMLTYPE | T_XML_TYPES |
| **行ID** | ROWID / UROWID | T_ROWID_TYPES |
| **オブジェクト** | OBJECT / VARRAY / NESTED TABLE | T_OBJECT_TYPES, T_NESTED_TABLE |
| **JSON** | JSON (23ai+) | T_JSON_TYPES |
| **真偽値** | BOOLEAN (23ai+) | T_BOOLEAN_TYPES |
| **空間** | SDO_GEOMETRY | T_SPATIAL_TYPES |
| **汎用** | ANYDATA | T_ANYDATA_TYPES |

### エッジケース

| ケース | テーブル |
|---|---|
| 空テーブル (0行) | T_EMPTY |
| 1行テーブル | T_SINGLE_ROW |
| 末尾 NULL カラム | T_TRAILING_NULLS |
| 幅広テーブル (30列) | T_WIDE_TABLE |
| 超幅広テーブル (100列) | T_VERY_WIDE |
| 大量行テーブル (10,000行) | T_LARGE_TABLE |
| 特殊文字・改行・タブ | T_SPECIAL_CHARS |
| 日本語テーブル名・カラム名 | 社員マスタ / 部署マスタ / 商品テーブル 等 |
| 日本語データ (住所・氏名等) | 受注データ / 都道府県マスタ 等 |
| LOB + 通常カラム混在 | T_LOB_MIXED |
| 複数スキーマ | ODV_TEST / ODV_TEST2 |
| パーティションテーブル | T_PARTITIONED_RANGE/HASH/LIST |
| 索引構成表 (IOT) | T_IOT |
| クラスタテーブル | T_CLUSTER_DEPT / T_CLUSTER_EMP |
| 仮想列 | T_VIRTUAL_COLUMN |
| DEFAULT 値 / IDENTITY | T_DEFAULTS |
| 外部キー制約 | T_FK_PARENT / T_FK_CHILD |
| NaN / Infinity | T_NUMERIC_TYPES (行7-9) |
| 紀元前日付 | T_DATETIME_TYPES (行6) |

## Oracle バージョン

Docker イメージ `gvenzl/oracle-free:23-slim` を使用 (Oracle Database 23ai Free)。

## トラブルシューティング

### Oracle コンテナが起動しない

```bash
docker logs oracle-testdump
```

### メモリ不足

Oracle Database Free は最低 2GB のメモリが必要です。

```bash
free -h
```

### ダンプファイルが空

Oracle が完全に起動してからスクリプトを実行してください。

```bash
bash scripts/wait-for-oracle.sh
```

### EXP コマンドが見つからない

Oracle 23ai Free では `exp` (レガシーエクスポート) が廃止されています。EXP 形式のダンプが必要な場合は、別途 Oracle 11g/12c/19c の Docker イメージを使用してください。
