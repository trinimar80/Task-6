CREATE TABLE "Authors" (
    author_id SERIAL PRIMARY KEY,   
    name VARCHAR(255) NOT NULL,
    nationality VARCHAR(100)
);

CREATE TABLE "Publishers" (
    publisher_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);


CREATE TABLE "Genres" (
    genre_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE
);


CREATE TABLE "Books" (
    book_id SERIAL PRIMARY KEY,
    title VARCHAR(500) NOT NULL,
    isbn VARCHAR(20) NOT NULL,
    author_id INTEGER NOT NULL REFERENCES "Authors"(author_id),
    publisher_id INTEGER NOT NULL REFERENCES "Publishers"(publisher_id),
    publication_year INTEGER NOT NULL
);

CREATE TABLE "Book_Genres" (
    book_genre_id SERIAL PRIMARY KEY,
    book_id INTEGER NOT NULL REFERENCES "Books"(book_id),
    genre_id INTEGER NOT NULL REFERENCES "Genres"(genre_id),
    UNIQUE (book_id, genre_id)
);




INSERT INTO "Authors" (name, nationality) VALUES
('Gabriel García Márquez', 'Colombian'),
('Isabel Allende', 'Chilean'),
('Jane Austen', 'British'),
('Paulo Coelho', 'Brazilian'),
('Aleksandr Pushkin', 'Russian'),
('William Shakespeare', 'British'),
('Leon Tolstoy', 'Russian'),
('Pablo Neruda', 'Chilean'),
('Jorge Luis Borges', 'Argentinian'),
('Miguel de Cervantes', 'Spanish');


INSERT INTO "Publishers" (name) VALUES
('RELX group'),
('ThomsonReuters'),
('Bertelsmann'),
('Pearson'),
('Wolters Kluwer'),
('Springer Nature'),
('Cengage Learning'),
('McGraw-Hill Education'),
('Hachette Livre'),
('AST');


INSERT INTO "Genres" (name) VALUES
    ('Realismo Mágico'),
    ('Ficción Histórica'),
    ('Romance Clásico'),
    ('Ficción Filosófica'),
    ('Poesía'),
    ('Drama'),
    ('Novela Épica'),
    ('Cuento Corto'),
    ('Aventura');


INSERT INTO "Books" (title, isbn, author_id, publisher_id, publication_year) VALUES
('Cien años de soledad', '9780307474728', 1, 1, 1967),
('La casa de los espíritus', '9780553273916', 2, 2, 1982),
('Orgullo y prejuicio', '9780141439518', 3, 3, 1813),
('El alquimista', '9780061122415', 4, 4, 1988),
('Eugene Onegin', '9780140449129', 5, 5, 1833),
('Hamlet', '9780743477123', 6, 6, 1603),
('Guerra y paz', '9780199232765', 7, 7, 1869),
('Veinte poemas de amor y una canción desesperada', '9788491050463', 8, 8, 1924),
('Ficciones', '9780142437476', 9, 9, 1944),
('Don Quijote de la Mancha', '9788491050258', 10, 10, 1605);


INSERT INTO "Book_Genres" (book_id, genre_id) VALUES
    (1, 1),  -- Cien años de soledad: Realismo Mágico
    (2, 2),  -- La casa de los espíritus: Ficción Histórica
    (3, 3),  -- Orgullo y prejuicio: Romance Clásico
    (4, 4),  -- El alquimista: Ficción Filosófica
    (5, 5),  -- Eugene Onegin: Poesía
    (6, 6),  -- Hamlet: Drama
    (7, 7),  -- Guerra y paz: Novela Épica
    (8, 5),  -- Veinte poemas de amor: Poesía
    (9, 8),  -- Ficciones: Cuento Corto
    (10, 9); -- Don Quijote: Aventura


$do$
BEGIN
   IF NOT EXISTS (
      SELECT FROM pg_catalog.pg_roles WHERE rolname = 'librarian_user') THEN
      CREATE USER librarian_user WITH PASSWORD 'secure_password_123';
   END IF;
END
$do$; 

-- b. Asignar permisos
GRANT CONNECT ON DATABASE library_db TO librarian_user;

-- c. Permisos de uso
GRANT ALL PRIVILEGES ON SCHEMA public TO librarian_user;

-- d. Conceder permisos específicos
GRANT SELECT, INSERT, UPDATE, DELETE ON "Authors" TO librarian_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON "Publishers" TO librarian_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON "Books" TO librarian_user;


-- e. Conceder permisos para usar las secuencias
GRANT USAGE, SELECT ON SEQUENCE "Authors_author_id_seq" TO librarian_user;
GRANT USAGE, SELECT ON SEQUENCE "Publishers_publisher_id_seq" TO librarian_user;
GRANT USAGE, SELECT ON SEQUENCE "Books_book_id_seq" TO librarian_user;
