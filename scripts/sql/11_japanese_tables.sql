-- =============================================================================
-- 日本語テーブル名・日本語カラム名・日本語データ
-- ODV_TEST ユーザーで実行
-- =============================================================================

-- 日本語テーブル名 + 日本語カラム名
CREATE TABLE "社員マスタ" (
    "社員番号"      NUMBER(10)      NOT NULL,
    "氏名"          VARCHAR2(100),
    "氏名カナ"      VARCHAR2(200),
    "部署コード"    NUMBER(5),
    "役職"          VARCHAR2(50),
    "入社日"        DATE,
    "給与"          NUMBER(10, 2),
    "メールアドレス" VARCHAR2(200),
    "備考"          VARCHAR2(1000),
    CONSTRAINT "PK_社員マスタ" PRIMARY KEY ("社員番号")
);

INSERT INTO "社員マスタ" VALUES (1001, '山田 太郎', 'ヤマダ タロウ', 10, '部長', TO_DATE('2000-04-01', 'YYYY-MM-DD'), 800000, 'yamada@example.com', '創業メンバー');
INSERT INTO "社員マスタ" VALUES (1002, '佐藤 花子', 'サトウ ハナコ', 20, '課長', TO_DATE('2005-04-01', 'YYYY-MM-DD'), 600000, 'sato@example.com', NULL);
INSERT INTO "社員マスタ" VALUES (1003, '鈴木 一郎', 'スズキ イチロウ', 10, '主任', TO_DATE('2010-10-01', 'YYYY-MM-DD'), 450000, 'suzuki@example.com', '中途入社');
INSERT INTO "社員マスタ" VALUES (1004, '田中 美咲', 'タナカ ミサキ', 30, NULL, TO_DATE('2020-04-01', 'YYYY-MM-DD'), 300000, 'tanaka@example.com', '新卒入社');
INSERT INTO "社員マスタ" VALUES (1005, '高橋 健太', 'タカハシ ケンタ', 20, '係長', TO_DATE('2015-04-01', 'YYYY-MM-DD'), 500000, NULL, NULL);

COMMIT;

-- 日本語テーブル名 (部署)
CREATE TABLE "部署マスタ" (
    "部署コード"    NUMBER(5)       NOT NULL,
    "部署名"        VARCHAR2(100),
    "部署名英語"    VARCHAR2(100),
    "所在地"        VARCHAR2(200),
    "設立日"        DATE,
    CONSTRAINT "PK_部署マスタ" PRIMARY KEY ("部署コード")
);

INSERT INTO "部署マスタ" VALUES (10, '開発部', 'Development', '東京都渋谷区神宮前1-2-3', TO_DATE('1990-04-01', 'YYYY-MM-DD'));
INSERT INTO "部署マスタ" VALUES (20, '営業部', 'Sales', '東京都千代田区丸の内4-5-6', TO_DATE('1990-04-01', 'YYYY-MM-DD'));
INSERT INTO "部署マスタ" VALUES (30, '総務部', 'General Affairs', '大阪府大阪市北区梅田7-8-9', TO_DATE('2000-01-01', 'YYYY-MM-DD'));

COMMIT;

-- 日本語テーブル名 (商品)
CREATE TABLE "商品テーブル" (
    "商品コード"    VARCHAR2(20)    NOT NULL,
    "商品名"        VARCHAR2(200),
    "カテゴリ"      VARCHAR2(100),
    "単価"          NUMBER(10, 2),
    "在庫数"        NUMBER(10),
    "説明"          CLOB,
    "登録日時"      TIMESTAMP,
    CONSTRAINT "PK_商品テーブル" PRIMARY KEY ("商品コード")
);

INSERT INTO "商品テーブル" VALUES ('PROD-001', 'ノートパソコン Pro 15', 'PC', 198000, 50,
    'ハイスペックノートPC。メモリ32GB、SSD 1TB搭載。ビジネス・クリエイター向け。', SYSTIMESTAMP);
INSERT INTO "商品テーブル" VALUES ('PROD-002', 'ワイヤレスマウス M100', '周辺機器', 3980, 200,
    '静音クリック。Bluetooth 5.0対応。', SYSTIMESTAMP);
INSERT INTO "商品テーブル" VALUES ('PROD-003', '4Kモニター 27インチ', 'モニター', 59800, 30,
    'IPS液晶、HDR対応。USB-C給電可能。', SYSTIMESTAMP);
INSERT INTO "商品テーブル" VALUES ('PROD-004', 'メカニカルキーボード K1', '周辺機器', 12800, 100,
    '青軸。日本語配列。RGB バックライト搭載。', SYSTIMESTAMP);
INSERT INTO "商品テーブル" VALUES ('PROD-005', 'USBハブ 7ポート', '周辺機器', 2980, 0, NULL, SYSTIMESTAMP);

COMMIT;

-- 日本語テーブル名 (受注)
CREATE TABLE "受注データ" (
    "受注番号"      NUMBER(15)      NOT NULL,
    "受注日"        DATE            NOT NULL,
    "顧客名"        VARCHAR2(200),
    "商品コード"    VARCHAR2(20),
    "数量"          NUMBER(10),
    "金額"          NUMBER(12, 2),
    "配送先住所"    NVARCHAR2(500),
    "ステータス"    VARCHAR2(20),
    CONSTRAINT "PK_受注データ" PRIMARY KEY ("受注番号")
);

INSERT INTO "受注データ" VALUES (20260001, TO_DATE('2026-01-15', 'YYYY-MM-DD'), '株式会社テスト', 'PROD-001', 2, 396000, N'東京都新宿区西新宿2-8-1', '出荷済');
INSERT INTO "受注データ" VALUES (20260002, TO_DATE('2026-02-20', 'YYYY-MM-DD'), '有限会社サンプル', 'PROD-003', 5, 299000, N'大阪府大阪市中央区本町3-1-2', '処理中');
INSERT INTO "受注データ" VALUES (20260003, TO_DATE('2026-03-01', 'YYYY-MM-DD'), '個人　山田太郎', 'PROD-002', 1, 3980, N'北海道札幌市中央区大通西1丁目', '未処理');
INSERT INTO "受注データ" VALUES (20260004, TO_DATE('2026-03-08', 'YYYY-MM-DD'), 'ＡＢＣ商事（全角）', 'PROD-004', 10, 128000, N'福岡県福岡市博多区博多駅前', '未処理');

COMMIT;

-- 日本語カラム名 + LOB混在
CREATE TABLE "ドキュメント管理" (
    "文書ID"        NUMBER(10)      NOT NULL,
    "タイトル"      NVARCHAR2(200),
    "本文"          NCLOB,
    "添付ファイル"  BLOB,
    "作成者"        VARCHAR2(100),
    "作成日"        DATE,
    "更新日"        TIMESTAMP,
    CONSTRAINT "PK_ドキュメント管理" PRIMARY KEY ("文書ID")
);

INSERT INTO "ドキュメント管理" VALUES (1, N'議事録：2026年3月定例会議', N'出席者：山田、佐藤、鈴木' || CHR(10) || N'議題：新製品の開発スケジュールについて' || CHR(10) || N'決定事項：4月末までにプロトタイプ完成', UTL_RAW.CAST_TO_RAW('PDF content here'), '山田太郎', TO_DATE('2026-03-01', 'YYYY-MM-DD'), SYSTIMESTAMP);
INSERT INTO "ドキュメント管理" VALUES (2, N'設計書：ODVテスト環境構築', N'1. 概要' || CHR(10) || N'   Oracle Database Free を Docker で構築' || CHR(10) || N'2. 手順' || CHR(10) || N'   docker compose up -d', NULL, '佐藤花子', TO_DATE('2026-03-08', 'YYYY-MM-DD'), SYSTIMESTAMP);
INSERT INTO "ドキュメント管理" VALUES (3, N'報告書：月次売上レポート', NULL, NULL, '鈴木一郎', TO_DATE('2026-02-28', 'YYYY-MM-DD'), SYSTIMESTAMP);

COMMIT;

-- 日本語テーブル名 (マスタ全般)
CREATE TABLE "都道府県マスタ" (
    "都道府県コード" NUMBER(2)      NOT NULL,
    "都道府県名"    VARCHAR2(20),
    "都道府県名カナ" VARCHAR2(40),
    "地方"          VARCHAR2(20),
    CONSTRAINT "PK_都道府県マスタ" PRIMARY KEY ("都道府県コード")
);

INSERT INTO "都道府県マスタ" VALUES (1, '北海道', 'ホッカイドウ', '北海道');
INSERT INTO "都道府県マスタ" VALUES (13, '東京都', 'トウキョウト', '関東');
INSERT INTO "都道府県マスタ" VALUES (27, '大阪府', 'オオサカフ', '近畿');
INSERT INTO "都道府県マスタ" VALUES (40, '福岡県', 'フクオカケン', '九州');
INSERT INTO "都道府県マスタ" VALUES (47, '沖縄県', 'オキナワケン', '九州');

COMMIT;

EXIT;
