SET track_io_timing = TRUE;

EXPLAIN (ANALYZE, BUFFERS)
SELECT
    b.book_id,
    b.title,
    ts_rank(b.search_vector, plainto_tsquery('russian', 'рефакторинг')) AS rank
FROM book b
WHERE b.search_vector @@ plainto_tsquery('russian', 'рефакторинг')
ORDER BY rank DESC, b.title;

EXPLAIN (ANALYZE, BUFFERS)
SELECT
    b.book_id,
    b.title,
    ts_rank(b.search_vector, plainto_tsquery('russian', 'раскольников')) AS rank
FROM book b
WHERE b.search_vector @@ plainto_tsquery('russian', 'раскольников')
ORDER BY rank DESC, b.title;

EXPLAIN (ANALYZE, BUFFERS)
SELECT
    book_id,
    title,
    similarity(title, 'преступл') AS sim
FROM book
WHERE title % 'преступл'
ORDER BY sim DESC, title;

EXPLAIN (ANALYZE, BUFFERS)
SELECT
    book_id,
    title
FROM book
WHERE title ILIKE 'рефакторинг%'
ORDER BY title;