-- =============================================================================
-- 複数スキーマテスト
-- ODV_TEST2 ユーザーで実行
-- =============================================================================

-- スキーマ2のテーブル
CREATE TABLE T_SCHEMA2_TABLE1 (
    ID              NUMBER(10)      NOT NULL,
    COL_NAME        VARCHAR2(200),
    COL_DATE        DATE,
    COL_AMOUNT      NUMBER(12, 2),
    CONSTRAINT PK_S2_TABLE1 PRIMARY KEY (ID)
);

INSERT INTO T_SCHEMA2_TABLE1 VALUES (1, 'Schema2 Record 1', SYSDATE, 1000.50);
INSERT INTO T_SCHEMA2_TABLE1 VALUES (2, 'Schema2 Record 2', SYSDATE - 30, 2500.75);
INSERT INTO T_SCHEMA2_TABLE1 VALUES (3, 'Schema2 Record 3', SYSDATE - 365, 999.99);

COMMIT;

CREATE TABLE T_SCHEMA2_TABLE2 (
    ID              NUMBER(10)      NOT NULL,
    COL_TEXT        VARCHAR2(500),
    COL_NUM         NUMBER,
    CONSTRAINT PK_S2_TABLE2 PRIMARY KEY (ID)
);

INSERT INTO T_SCHEMA2_TABLE2 VALUES (1, 'Text data in schema 2', 100);
INSERT INTO T_SCHEMA2_TABLE2 VALUES (2, 'マルチスキーマテスト', 200);

COMMIT;

-- 空テーブル (スキーマ2)
CREATE TABLE T_SCHEMA2_EMPTY (
    ID              NUMBER(10)      NOT NULL,
    COL_NAME        VARCHAR2(100),
    CONSTRAINT PK_S2_EMPTY PRIMARY KEY (ID)
);

EXIT;
