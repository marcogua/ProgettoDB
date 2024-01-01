--TABELLA DELLE PERSONE

CREATE TABLE Persona(
    Nome VARCHAR(256),
    Cognome VARCHAR(256),
    CodiceFiscale CHAR(16) PRIMARY KEY,
    Telefono VARCHAR(15),
    CONSTRAINT validate_nome
        CHECK (Nome ~ '^([a-zA-Z ])+$'),
    CONSTRAINT validate_cognome
        CHECK (Cognome ~ '^([a-zA-Z ])+$'),
    CONSTRAINT validate_codice_fiscale
        CHECK (CodiceFiscale ~ '^[A-Z]{6}[0-9]{2}[A-Z]{1}[0-9]{2}[A-Z]{1}[0-9]{3}[A-Z]{1}$'),
    CONSTRAINT validate_telefono
        CHECK (Telefono ~ '^\d{9,15}$')
);
 