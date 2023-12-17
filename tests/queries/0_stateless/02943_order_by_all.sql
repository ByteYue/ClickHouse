-- Tests that sort expression ORDER BY ALL

DROP TABLE IF EXISTS order_by_all;

CREATE TABLE order_by_all
(
    a String,
    b Nullable(Int32),
    all UInt64,
)
ENGINE = Memory;

INSERT INTO order_by_all VALUES ('B', 3, 10), ('C', NULL, 40), ('D', 1, 20), ('A', 2, 30);

SELECT '-- no modifiers';
SELECT a, b FROM order_by_all ORDER BY ALL;
SELECT b, a FROM order_by_all ORDER BY ALL;

SELECT '-- with ASC/DESC modifiers';
SELECT a, b FROM order_by_all ORDER BY ALL ASC;
SELECT a, b FROM order_by_all ORDER BY ALL DESC;

SELECT '-- with NULLS FIRST/LAST modifiers';
SELECT b, a FROM order_by_all ORDER BY ALL NULLS FIRST;
SELECT b, a FROM order_by_all ORDER BY ALL NULLS LAST;

SELECT '-- what happens if some column "all" already exists?';

-- columns
SELECT a, b, all FROM order_by_all ORDER BY all;  -- { serverError UNEXPECTED_EXPRESSION }
SELECT a, b, all FROM order_by_all ORDER BY ALL;  -- { serverError UNEXPECTED_EXPRESSION }
SELECT a, b, all FROM order_by_all ORDER BY all SETTINGS enable_order_by_all = false;

-- column aliases
SELECT a, b AS all FROM order_by_all ORDER BY all;  -- { serverError UNEXPECTED_EXPRESSION }
SELECT a, b AS all FROM order_by_all ORDER BY ALL;  -- { serverError UNEXPECTED_EXPRESSION }
SELECT a, b AS all FROM order_by_all ORDER BY all SETTINGS enable_order_by_all = false;

-- expressions
SELECT format('{} {}', a, b) AS all FROM order_by_all ORDER BY all;  -- { serverError UNEXPECTED_EXPRESSION }
SELECT format('{} {}', a, b) AS all FROM order_by_all ORDER BY ALL;  -- { serverError UNEXPECTED_EXPRESSION }
SELECT format('{} {}', a, b) AS all FROM order_by_all ORDER BY all SETTINGS enable_order_by_all = false;

SELECT a, b, all FROM order_by_all ORDER BY all, a;

DROP TABLE order_by_all;
