
CREATE TABLE users (
    id         INTEGER PRIMARY KEY AUTOINCREMENT,
    first_name TEXT,
    last_name  TEXT,
    birth_date DATE,
    phone      TEXT,
    email      TEXT,
    address    TEXT,
    city       TEXT,
    state      TEXT,
    zip_code   INTEGER
);


CREATE TABLE books (
    id             INTEGER PRIMARY KEY AUTOINCREMENT,
    title          TEXT,
    author         TEXT,
    isbn           TEXT,
    date_published DATE,
    publisher      TEXT,
    format         TEXT,
    pages          INTEGER
);


CREATE TABLE genres (
    id   INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT
);


CREATE TABLE book_genre_link (
    book_id  INTEGER REFERENCES books (id),
    genre_id INTEGER REFERENCES genres (id) 
);


CREATE TABLE checkouts (
    id                   INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id              INTEGER REFERENCES users (id),
    book_id              INTEGER REFERENCES books (id),
    checkout_date        DATE,
    days_checking_out    INTEGER,
    due_date             DATE,
    return_date          DATE,
    days_checked_out     INTEGER,
    returned_with_damage INTEGER
);
