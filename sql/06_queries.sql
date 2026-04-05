SELECT book_id, title, publish_year
FROM book
ORDER BY book_id
LIMIT 20;

SELECT
    b.book_id,
    b.title,
    ts_rank(b.search_vector, plainto_tsquery('russian', 'рефакторинг')) AS rank
FROM book b
WHERE b.search_vector @@ plainto_tsquery('russian', 'рефакторинг')
ORDER BY rank DESC, b.title;

SELECT
    b.book_id,
    b.title,
    ts_rank(b.search_vector, plainto_tsquery('russian', 'раскольников')) AS rank
FROM book b
WHERE b.search_vector @@ plainto_tsquery('russian', 'раскольников')
ORDER BY rank DESC, b.title;

SELECT
    b.book_id,
    b.title,
    ts_rank(b.search_vector, plainto_tsquery('russian', 'мракобесие')) AS rank
FROM book b
WHERE b.search_vector @@ plainto_tsquery('russian', 'мракобесие')
ORDER BY rank DESC, b.title;

SELECT
    book_id,
    title
FROM book
WHERE title ILIKE 'рефакторинг%'
ORDER BY title;

SELECT
    book_id,
    title,
    similarity(title, 'преступл') AS sim
FROM book
WHERE title % 'преступл'
ORDER BY sim DESC, title;

SELECT
    b.book_id,
    b.title,
    ts_rank(
            b.search_vector,
            websearch_to_tsquery('russian', 'психологический роман')
    ) AS fts_rank,
    GREATEST(
            similarity(b.title, 'психол'),
            similarity(b.annotation, 'психол')
    ) AS trgm_rank,
    (
        ts_rank(
                b.search_vector,
                websearch_to_tsquery('russian', 'психологический роман')
        ) * 0.8
            +
        GREATEST(
                similarity(b.title, 'психол'),
                similarity(b.annotation, 'психол')
        ) * 0.2
        ) AS total_rank
FROM book b
WHERE
    b.search_vector @@ websearch_to_tsquery('russian', 'психологический роман')
   OR b.title % 'психол'
   OR b.annotation % 'психол'
ORDER BY total_rank DESC, b.title
LIMIT 20;

SELECT
    b.title,
    a.full_name AS author,
    p.name AS publisher,
    c.name AS category
FROM book b
         JOIN book_author ba ON b.book_id = ba.book_id
         JOIN author a ON ba.author_id = a.author_id
         JOIN publisher p ON b.publisher_id = p.publisher_id
         JOIN category c ON b.category_id = c.category_id
ORDER BY b.title
LIMIT 20;

SELECT
    c.name AS category,
    COUNT(*) AS book_count
FROM book b
         JOIN category c ON b.category_id = c.category_id
GROUP BY c.name
ORDER BY book_count DESC;