CREATE EXTENSION IF NOT EXISTS pg_trgm;

CREATE OR REPLACE FUNCTION book_search_vector_update()
    RETURNS trigger AS
$$
BEGIN
    NEW.search_vector :=
            setweight(to_tsvector('russian', coalesce(NEW.title, '')), 'A') ||
            setweight(to_tsvector('russian', coalesce(NEW.annotation, '')), 'B');
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_book_search_vector ON book;

CREATE TRIGGER trg_book_search_vector
    BEFORE INSERT OR UPDATE OF title, annotation
    ON book
    FOR EACH ROW
EXECUTE FUNCTION book_search_vector_update();