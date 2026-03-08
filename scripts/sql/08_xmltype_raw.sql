-- =============================================================================
-- XMLTYPE / RAW / LONG RAW / ROWID 型
-- ODV_TEST ユーザーで実行
-- =============================================================================

-- XMLTYPE テーブル
CREATE TABLE T_XML_TYPES (
    ID              NUMBER(10)      NOT NULL,
    COL_XML         XMLTYPE,
    COL_NAME        VARCHAR2(100),
    CONSTRAINT PK_XML_TYPES PRIMARY KEY (ID)
);

INSERT INTO T_XML_TYPES VALUES (1,
    XMLTYPE('<root><item id="1"><name>Test</name><value>100</value></item></root>'),
    'Simple XML'
);

INSERT INTO T_XML_TYPES VALUES (2,
    XMLTYPE('<?xml version="1.0" encoding="UTF-8"?><data><record><id>1</id><name>日本語XML</name><desc>テストデータ</desc></record><record><id>2</id><name>Second</name><desc>English</desc></record></data>'),
    'Multi-record XML'
);

INSERT INTO T_XML_TYPES VALUES (3, NULL, 'Null XML');

COMMIT;

-- RAW / LONG RAW テーブル
CREATE TABLE T_RAW_TYPES (
    ID              NUMBER(10)      NOT NULL,
    COL_RAW         RAW(2000),
    COL_LONG_RAW    LONG RAW,
    COL_NAME        VARCHAR2(100),
    CONSTRAINT PK_RAW_TYPES PRIMARY KEY (ID)
);

INSERT INTO T_RAW_TYPES VALUES (1, HEXTORAW('DEADBEEF'), HEXTORAW('0102030405060708090A0B0C0D0E0F'), 'Hex data');
INSERT INTO T_RAW_TYPES VALUES (2, HEXTORAW('FF00FF00FF'), UTL_RAW.CAST_TO_RAW('Raw string data'), 'Mixed raw');
INSERT INTO T_RAW_TYPES VALUES (3, NULL, NULL, 'Null raw');

-- 大きい RAW
INSERT INTO T_RAW_TYPES VALUES (4,
    UTL_RAW.CAST_TO_RAW(RPAD('X', 2000, 'Y')),
    UTL_RAW.CAST_TO_RAW(RPAD('Long raw data ', 4000, 'Z')),
    'Max RAW'
);

COMMIT;

-- ROWID テスト (実際の行のROWIDを格納)
CREATE TABLE T_ROWID_TYPES (
    ID              NUMBER(10)      NOT NULL,
    COL_ROWID       ROWID,
    COL_UROWID      UROWID,
    COL_NAME        VARCHAR2(100),
    CONSTRAINT PK_ROWID_TYPES PRIMARY KEY (ID)
);

-- T_BASIC_TYPES の実際の ROWID を取得して格納
INSERT INTO T_ROWID_TYPES
    SELECT 1, ROWID, ROWID, 'ROWID from T_BASIC_TYPES'
    FROM T_BASIC_TYPES WHERE ID = 1;

INSERT INTO T_ROWID_TYPES
    SELECT 2, ROWID, ROWID, 'ROWID from T_BASIC_TYPES row 2'
    FROM T_BASIC_TYPES WHERE ID = 2;

INSERT INTO T_ROWID_TYPES VALUES (3, NULL, NULL, 'Null ROWID');

COMMIT;

EXIT;
