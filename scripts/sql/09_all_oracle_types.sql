-- =============================================================================
-- Oracle 全データ型 (プロジェクト未対応含む・将来対応用)
-- ODV_TEST ユーザーで実行
-- =============================================================================

-- オブジェクト型 (User-Defined Types)
CREATE TYPE T_ADDRESS AS OBJECT (
    STREET      VARCHAR2(200),
    CITY        VARCHAR2(100),
    ZIP_CODE    VARCHAR2(20)
);
/

CREATE TYPE T_PHONE_LIST AS VARRAY(5) OF VARCHAR2(20);
/

CREATE TYPE T_NAME_TABLE AS TABLE OF VARCHAR2(100);
/

-- オブジェクト型テーブル
CREATE TABLE T_OBJECT_TYPES (
    ID              NUMBER(10)      NOT NULL,
    COL_ADDRESS     T_ADDRESS,
    COL_PHONES      T_PHONE_LIST,
    COL_NAME        VARCHAR2(100),
    CONSTRAINT PK_OBJECT_TYPES PRIMARY KEY (ID)
);

INSERT INTO T_OBJECT_TYPES VALUES (1,
    T_ADDRESS('123 Main St', 'Tokyo', '100-0001'),
    T_PHONE_LIST('03-1234-5678', '090-1234-5678'),
    'Object type test'
);

INSERT INTO T_OBJECT_TYPES VALUES (2,
    T_ADDRESS('456 Oak Ave', 'Osaka', '530-0001'),
    T_PHONE_LIST('06-1234-5678'),
    'Object type test 2'
);

INSERT INTO T_OBJECT_TYPES VALUES (3, NULL, NULL, 'Null objects');

COMMIT;

-- ネストされたテーブル
CREATE TABLE T_NESTED_TABLE (
    ID              NUMBER(10)      NOT NULL,
    COL_NAMES       T_NAME_TABLE,
    COL_DESC        VARCHAR2(200),
    CONSTRAINT PK_NESTED_TABLE PRIMARY KEY (ID)
) NESTED TABLE COL_NAMES STORE AS NT_NAMES;

INSERT INTO T_NESTED_TABLE VALUES (1,
    T_NAME_TABLE('Alice', 'Bob', 'Charlie'),
    'Three names'
);

INSERT INTO T_NESTED_TABLE VALUES (2,
    T_NAME_TABLE('日本語名前'),
    'Japanese name'
);

INSERT INTO T_NESTED_TABLE VALUES (3,
    T_NAME_TABLE(),
    'Empty nested table'
);

COMMIT;

-- JSON 型 (Oracle 21c+)
CREATE TABLE T_JSON_TYPES (
    ID              NUMBER(10)      NOT NULL,
    COL_JSON        JSON,
    COL_VARCHAR_JSON VARCHAR2(4000) CHECK (COL_VARCHAR_JSON IS JSON),
    COL_NAME        VARCHAR2(100),
    CONSTRAINT PK_JSON_TYPES PRIMARY KEY (ID)
);

INSERT INTO T_JSON_TYPES VALUES (1,
    JSON('{"name": "Test", "value": 100, "nested": {"key": "value"}}'),
    '{"array": [1, 2, 3], "bool": true, "null_val": null}',
    'JSON test'
);

INSERT INTO T_JSON_TYPES VALUES (2,
    JSON('{"jp": "日本語JSON", "emoji": "🍣"}'),
    '{"simple": "value"}',
    'Japanese JSON'
);

INSERT INTO T_JSON_TYPES VALUES (3, NULL, NULL, 'Null JSON');

COMMIT;

-- BOOLEAN 型 (Oracle 23ai+)
CREATE TABLE T_BOOLEAN_TYPES (
    ID              NUMBER(10)      NOT NULL,
    COL_BOOL        BOOLEAN,
    COL_NAME        VARCHAR2(100),
    CONSTRAINT PK_BOOLEAN_TYPES PRIMARY KEY (ID)
);

INSERT INTO T_BOOLEAN_TYPES VALUES (1, TRUE, 'True value');
INSERT INTO T_BOOLEAN_TYPES VALUES (2, FALSE, 'False value');
INSERT INTO T_BOOLEAN_TYPES VALUES (3, NULL, 'Null boolean');

COMMIT;

-- SDO_GEOMETRY (空間データ - Oracle Spatial がある場合)
-- ※ Oracle Free では使えない可能性あり。エラー時はスキップ。
BEGIN
    EXECUTE IMMEDIATE '
        CREATE TABLE T_SPATIAL_TYPES (
            ID              NUMBER(10)      NOT NULL,
            COL_GEOMETRY    SDO_GEOMETRY,
            COL_NAME        VARCHAR2(100),
            CONSTRAINT PK_SPATIAL_TYPES PRIMARY KEY (ID)
        )';

    EXECUTE IMMEDIATE '
        INSERT INTO T_SPATIAL_TYPES VALUES (1,
            SDO_GEOMETRY(2001, 4326, SDO_POINT_TYPE(139.6917, 35.6895, NULL), NULL, NULL),
            ''Tokyo point'')';

    EXECUTE IMMEDIATE '
        INSERT INTO T_SPATIAL_TYPES VALUES (2,
            SDO_GEOMETRY(2001, 4326, SDO_POINT_TYPE(135.5023, 34.6937, NULL), NULL, NULL),
            ''Osaka point'')';

    EXECUTE IMMEDIATE 'COMMIT';
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('SDO_GEOMETRY not available: ' || SQLERRM);
END;
/

-- ANYDATA / ANYTYPE (汎用データ型)
CREATE TABLE T_ANYDATA_TYPES (
    ID              NUMBER(10)      NOT NULL,
    COL_ANYDATA     ANYDATA,
    COL_NAME        VARCHAR2(100),
    CONSTRAINT PK_ANYDATA_TYPES PRIMARY KEY (ID)
);

INSERT INTO T_ANYDATA_TYPES VALUES (1, ANYDATA.CONVERTNUMBER(42), 'Number in ANYDATA');
INSERT INTO T_ANYDATA_TYPES VALUES (2, ANYDATA.CONVERTVARCHAR2('Hello'), 'VARCHAR2 in ANYDATA');
INSERT INTO T_ANYDATA_TYPES VALUES (3, ANYDATA.CONVERTDATE(SYSDATE), 'DATE in ANYDATA');
INSERT INTO T_ANYDATA_TYPES VALUES (4, NULL, 'Null ANYDATA');

COMMIT;

EXIT;
