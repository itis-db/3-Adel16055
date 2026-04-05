CREATE INDEX idx_book_publisher_id ON book(publisher_id);
CREATE INDEX idx_book_category_id ON book(category_id);
CREATE INDEX idx_book_author_author_id ON book_author(author_id);
CREATE INDEX idx_loan_book_id ON loan(book_id);
CREATE INDEX idx_loan_reader_id ON loan(reader_id);

CREATE INDEX idx_book_publish_year ON book(publish_year);
CREATE INDEX idx_reader_full_name ON reader(full_name);
CREATE INDEX idx_loan_loan_date ON loan(loan_date);

CREATE INDEX idx_book_search_vector
    ON book
        USING GIN (search_vector);

CREATE INDEX idx_book_title_trgm
    ON book
        USING GIN (title gin_trgm_ops);

CREATE INDEX idx_book_annotation_trgm
    ON book
        USING GIN (annotation gin_trgm_ops);