-- =============================================================================
-- NCHAR / NVARCHAR2 (マルチバイト Unicode) テスト
-- ODV_TEST ユーザーで実行
-- =============================================================================

CREATE TABLE T_NCHAR_TYPES (
    ID              NUMBER(10)      NOT NULL,
    COL_NCHAR       NCHAR(50),
    COL_NVARCHAR2   NVARCHAR2(500),
    COL_VARCHAR2    VARCHAR2(200),
    CONSTRAINT PK_NCHAR_TYPES PRIMARY KEY (ID)
);

-- 日本語 (ひらがな・カタカナ・漢字)
INSERT INTO T_NCHAR_TYPES VALUES (1,
    N'こんにちは世界',
    N'日本語テストデータ：漢字・ひらがな・カタカナ',
    'ASCII comparison'
);

-- 日本語 (半角カナ・全角英数)
INSERT INTO T_NCHAR_TYPES VALUES (2,
    N'ﾊﾝｶｸｶﾅ',
    N'ＡＢＣＤＥ１２３４５ａｂｃｄｅ',
    'Half/Full width'
);

-- CJK 統合漢字 (中国語・韓国語)
INSERT INTO T_NCHAR_TYPES VALUES (3,
    N'你好世界',
    N'한국어 테스트 데이터',
    'CJK unified'
);

-- 絵文字・サロゲートペア
INSERT INTO T_NCHAR_TYPES VALUES (4,
    N'😀🎉🚀',
    N'絵文字テスト: 🍣🍺🎌🗾',
    'Emoji test'
);

-- アラビア語・タイ語
INSERT INTO T_NCHAR_TYPES VALUES (5,
    N'مرحبا بالعالم',
    N'สวัสดีชาวโลก',
    'RTL and Thai'
);

-- 空・NULL
INSERT INTO T_NCHAR_TYPES VALUES (6, N'', N'', '');
INSERT INTO T_NCHAR_TYPES VALUES (7, NULL, NULL, NULL);

-- 最大長テスト
INSERT INTO T_NCHAR_TYPES VALUES (8,
    RPAD(N'あ', 50, N'い'),
    RPAD(N'漢', 500, N'字'),
    'Max length NCHAR'
);

COMMIT;

EXIT;
