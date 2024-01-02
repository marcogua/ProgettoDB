--DOMINIO TIPO_RELAZIONE

CREATE DOMAIN tipo_relazione AS 
    VARCHAR(1000) NOT NULL CHECK(
                                VALUE = 'Fratello-Sorella' OR
                                VALUE = 'Coniuge' OR
                                VALUE = 'Figlio-Figlia' OR
                                VALUE = 'Parente' OR
                                VALUE = 'Amico');

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

--INSERIMENTI DI ESEMPIO DELLA TABELLA MEMBRO

INSERT INTO membro VALUES ('Amico', 'RSSMRA90A01F839Y');
 