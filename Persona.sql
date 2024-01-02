--CREAZIONE DEL TIPO STRUTTURATO RESIDENZA

CREATE TYPE residenza AS (
    via VARCHAR(255),
    civico VARCHAR(5),
    cap VARCHAR(5),
    citta VARCHAR(255),
    provincia VARCHAR(255)
);

--TABELLA DELLE PERSONE

CREATE TABLE persona(
    nome VARCHAR(256) NOT NULL,
    cognome VARCHAR(256) NOT NULL,
    codice_fiscale CHAR(16) PRIMARY KEY,
    residenza residenza NOT NULL,
    telefono VARCHAR(15) NOT NULL,
    CONSTRAINT validate_nome
        CHECK (nome ~ '^([a-zA-Z ])+$'),
    CONSTRAINT validate_cognome
        CHECK (cognome ~ '^([a-zA-Z ])+$'),
    CONSTRAINT validate_codice_fiscale
        CHECK (codice_fiscale ~ '^[A-Z]{6}[0-9]{2}[A-Z]{1}[0-9]{2}[A-Z]{1}[0-9]{3}[A-Z]{1}$'),
    CONSTRAINT validate_telefono
        CHECK (telefono ~ '^\d{9,15}$')
);

--INSERIMENTI DI ESEMPIO DELLA TABELLA PERSONA

INSERT INTO persona VALUES('Mario', 'Rossi', 'RSSMRA90A01F839Y', ROW('via mario rossi', '12', '12345', 'Acerra', 'Napoli'), '0818907665');
 