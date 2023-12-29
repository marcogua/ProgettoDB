CREATE TABLE Persona(
    Nome VARCHAR(256) CHECK (Nome ~ '^([a-zA-Z ])+$'),
    Cognome VARCHAR(256) CHECK (Cognome ~ '^([a-zA-Z ])+$'),
    CodiceFiscale CHAR(16) CHECK (CodiceFiscale ~ '^[A-Z]{6}[0-9]{2}[A-Z]{1}[0-9]{2}[A-Z]{1}[0-9]{3}[A-Z]{1}$') PRIMARY KEY,
    Telefono VARCHAR(15) CHECK (Telefono ~ '^\d{9,15}$')
);