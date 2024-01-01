--TABELLA DEGLI UTENTI

CREATE TABLE utente(
    email VARCHAR(255) PRIMARY KEY,
    password VARCHAR(255) NOT NULL,
    CONSTRAINT validate_email
        CHECK (email ~ '^[\w\-\.]+@([\w-]+\.)+[\w-]{2,}$')
);
 