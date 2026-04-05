DROP TABLE IF EXISTS loan CASCADE;
DROP TABLE IF EXISTS book_author CASCADE;
DROP TABLE IF EXISTS book CASCADE;
DROP TABLE IF EXISTS author CASCADE;
DROP TABLE IF EXISTS publisher CASCADE;
DROP TABLE IF EXISTS category CASCADE;
DROP TABLE IF EXISTS reader CASCADE;

CREATE TABLE author (
                        author_id BIGSERIAL PRIMARY KEY,
                        full_name VARCHAR(200) NOT NULL,
                        birth_date DATE,
                        country VARCHAR(100)
);

CREATE TABLE publisher (
                           publisher_id BIGSERIAL PRIMARY KEY,
                           name VARCHAR(200) NOT NULL UNIQUE,
                           city VARCHAR(100)
);

CREATE TABLE category (
                          category_id BIGSERIAL PRIMARY KEY,
                          name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE book (
                      book_id BIGSERIAL PRIMARY KEY,
                      title VARCHAR(300) NOT NULL,
                      annotation TEXT NOT NULL,
                      isbn VARCHAR(20) UNIQUE,
                      publish_year INT CHECK (publish_year BETWEEN 1800 AND 2100),
                      publisher_id BIGINT NOT NULL REFERENCES publisher(publisher_id),
                      category_id BIGINT NOT NULL REFERENCES category(category_id),
                      search_vector tsvector
);

CREATE TABLE book_author (
                             book_id BIGINT NOT NULL REFERENCES book(book_id) ON DELETE CASCADE,
                             author_id BIGINT NOT NULL REFERENCES author(author_id) ON DELETE CASCADE,
                             PRIMARY KEY (book_id, author_id)
);

CREATE TABLE reader (
                        reader_id BIGSERIAL PRIMARY KEY,
                        full_name VARCHAR(200) NOT NULL,
                        email VARCHAR(200) UNIQUE,
                        phone VARCHAR(30),
                        registered_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE loan (
                      loan_id BIGSERIAL PRIMARY KEY,
                      book_id BIGINT NOT NULL REFERENCES book(book_id),
                      reader_id BIGINT NOT NULL REFERENCES reader(reader_id),
                      loan_date DATE NOT NULL,
                      due_date DATE NOT NULL,
                      return_date DATE,
                      CHECK (due_date >= loan_date),
                      CHECK (return_date IS NULL OR return_date >= loan_date)
);