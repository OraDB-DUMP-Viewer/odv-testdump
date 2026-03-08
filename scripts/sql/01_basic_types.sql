-- =============================================================================
-- 基本文字列型・基本テーブル
-- ODV_TEST ユーザーで実行
-- =============================================================================

-- CHAR / VARCHAR2 / LONG
CREATE TABLE T_BASIC_TYPES (
    ID              NUMBER(10)      NOT NULL,
    COL_CHAR        CHAR(20),
    COL_CHAR_BYTE   CHAR(50 BYTE),
    COL_VARCHAR2    VARCHAR2(200),
    COL_VARCHAR2_MAX VARCHAR2(4000),
    COL_LONG        LONG,
    CONSTRAINT PK_BASIC_TYPES PRIMARY KEY (ID)
);

INSERT INTO T_BASIC_TYPES VALUES (1, 'Hello', 'ByteChar', 'World', 'Short text', 'This is a LONG column value');
INSERT INTO T_BASIC_TYPES VALUES (2, 'Test ', 'テスト', '日本語テスト', RPAD('A', 4000, 'B'), 'Long value 2');
INSERT INTO T_BASIC_TYPES VALUES (3, NULL, NULL, NULL, NULL, NULL);
INSERT INTO T_BASIC_TYPES VALUES (4, 'ABCDEFGHIJKLMNOPQRST', 'MaxLen', 'Mixed 123 テスト αβγ', 'Unicode: あいうえお漢字', 'Long with 日本語');
INSERT INTO T_BASIC_TYPES VALUES (5, 'pad               ', 'spaces', '  leading spaces', 'trailing spaces   ', 'LONG trailing   ');

COMMIT;

-- 特殊文字テスト
CREATE TABLE T_SPECIAL_CHARS (
    ID              NUMBER(10)      NOT NULL,
    COL_NEWLINE     VARCHAR2(200),
    COL_TAB         VARCHAR2(200),
    COL_QUOTE       VARCHAR2(200),
    COL_COMMA       VARCHAR2(200),
    COL_BACKSLASH   VARCHAR2(200),
    COL_UNICODE     VARCHAR2(200),
    COL_EMPTY       VARCHAR2(200),
    CONSTRAINT PK_SPECIAL_CHARS PRIMARY KEY (ID)
);

INSERT INTO T_SPECIAL_CHARS VALUES (1, 'line1' || CHR(10) || 'line2', 'col1' || CHR(9) || 'col2', 'He said "hello"', 'a,b,c', 'path\to\file', '☺★♪♫€£¥', '');
INSERT INTO T_SPECIAL_CHARS VALUES (2, CHR(13) || CHR(10), CHR(9) || CHR(9), '''single''', '","', '\\\\', '🍣🍺🎌', NULL);
INSERT INTO T_SPECIAL_CHARS VALUES (3, 'normal', 'normal', 'no quotes', 'no commas', 'no backslash', 'ASCII only', ' ');

COMMIT;

EXIT;
