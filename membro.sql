--TABELLA DEI MEMBRI

CREATE TABLE membro(
    relazione tipo_relazione,
    codice_fiscale VARCHAR(16) NOT NULL,
    CONSTRAINT fk_Membro FOREIGN KEY(codice_fiscale)
        REFERENCES persona(codice_fiscale)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT validate_codice_fiscale
        CHECK (codice_fiscale ~ '^[A-Z]{6}[0-9]{2}[A-Z]{1}[0-9]{2}[A-Z]{1}[0-9]{3}[A-Z]{1}$')
);
 