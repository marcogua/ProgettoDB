--TABELLA DEGLI UTENTI

CREATE TABLE utente(
    email VARCHAR(255) PRIMARY KEY,
    password VARCHAR(255) NOT NULL,
    CONSTRAINT validate_email
        CHECK (email ~ '^[\w\-\.]+@([\w-]+\.)+[\w-]{2,}$'),
    CONSTRAINT validate_password
        CHECK (password ~ '^(?=.*\d)(?=.*[A-Z])(?=.*[a-z])(?=.*[^\w\d\s:])([^\s]){8,16}$')
);

--INSERIMENTI DI ESEMPIO DELLA TABELLA UTENTI

INSERT INTO utente VALUES ('admin.admin@admin.admin', 'Admin@admin12');
INSERT INTO utente VALUES ('luca.rossi@email.it', 'LR.password12');
INSERT into utente values ('mario.rossi@email.com', 'MR.password12');
 