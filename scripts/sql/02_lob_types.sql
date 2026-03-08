-- =============================================================================
-- LOB 型 (BLOB / CLOB / NCLOB / BFILE)
-- ODV_TEST ユーザーで実行
-- =============================================================================

CREATE TABLE T_LOB_TYPES (
    ID              NUMBER(10)      NOT NULL,
    COL_CLOB        CLOB,
    COL_NCLOB       NCLOB,
    COL_BLOB        BLOB,
    CONSTRAINT PK_LOB_TYPES PRIMARY KEY (ID)
);

-- 小さい LOB
INSERT INTO T_LOB_TYPES VALUES (1, 'Small CLOB data', N'Small NCLOB あいう', UTL_RAW.CAST_TO_RAW('Small BLOB data'));

-- 中サイズ LOB (4KB)
INSERT INTO T_LOB_TYPES VALUES (2,
    RPAD('Medium CLOB ', 4000, 'x'),
    RPAD(N'中サイズ NCLOB ', 4000, N'あ'),
    UTL_RAW.CAST_TO_RAW(RPAD('Medium BLOB ', 4000, 'y'))
);

-- NULL LOB
INSERT INTO T_LOB_TYPES VALUES (3, NULL, NULL, NULL);

-- 空 LOB
INSERT INTO T_LOB_TYPES VALUES (4, EMPTY_CLOB(), EMPTY_CLOB(), EMPTY_BLOB());

-- 大きい LOB (PL/SQL で生成)
DECLARE
    v_clob CLOB;
    v_nclob NCLOB;
    v_blob BLOB;
BEGIN
    -- 100KB CLOB
    INSERT INTO T_LOB_TYPES (ID, COL_CLOB, COL_NCLOB, COL_BLOB)
        VALUES (5, EMPTY_CLOB(), EMPTY_CLOB(), EMPTY_BLOB())
        RETURNING COL_CLOB, COL_NCLOB, COL_BLOB INTO v_clob, v_nclob, v_blob;

    FOR i IN 1..100 LOOP
        DBMS_LOB.WRITEAPPEND(v_clob, 1000, RPAD('CLOB-' || TO_CHAR(i, 'FM000') || ' ', 1000, CHR(65 + MOD(i, 26))));
    END LOOP;

    FOR i IN 1..50 LOOP
        DBMS_LOB.WRITEAPPEND(v_nclob, 500, RPAD(N'日本語' || TO_CHAR(i) || N' ', 500, N'漢'));
    END LOOP;

    FOR i IN 1..100 LOOP
        DBMS_LOB.WRITEAPPEND(v_blob, 1000, UTL_RAW.CAST_TO_RAW(RPAD('BLOB-' || TO_CHAR(i, 'FM000') || ' ', 1000, CHR(65 + MOD(i, 26)))));
    END LOOP;

    COMMIT;
END;
/

-- LOB + 通常カラム混在テーブル
CREATE TABLE T_LOB_MIXED (
    ID              NUMBER(10)      NOT NULL,
    COL_NAME        VARCHAR2(100),
    COL_BLOB        BLOB,
    COL_DESC        VARCHAR2(500),
    COL_CLOB        CLOB,
    COL_NUM         NUMBER,
    CONSTRAINT PK_LOB_MIXED PRIMARY KEY (ID)
);

INSERT INTO T_LOB_MIXED VALUES (1, 'Record 1', UTL_RAW.CAST_TO_RAW('blob1'), 'Description 1', 'clob data 1', 100);
INSERT INTO T_LOB_MIXED VALUES (2, 'Record 2', UTL_RAW.CAST_TO_RAW('blob2'), 'Description 2', 'clob data 2', 200);
INSERT INTO T_LOB_MIXED VALUES (3, 'Record 3', NULL, NULL, NULL, NULL);

COMMIT;

-- BFILE テスト (パス情報のみ)
CREATE TABLE T_BFILE_TYPES (
    ID              NUMBER(10)      NOT NULL,
    COL_BFILE       BFILE,
    COL_NAME        VARCHAR2(100),
    CONSTRAINT PK_BFILE_TYPES PRIMARY KEY (ID)
);

INSERT INTO T_BFILE_TYPES VALUES (1, BFILENAME('DUMP_DIR', 'sample.txt'), 'Sample file');
INSERT INTO T_BFILE_TYPES VALUES (2, BFILENAME('DUMP_DIR', 'image.png'), 'Image file');
INSERT INTO T_BFILE_TYPES VALUES (3, NULL, 'No file');

COMMIT;

EXIT;
