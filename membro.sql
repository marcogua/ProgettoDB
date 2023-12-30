--TABELLA DEI MEMBRI

CREATE TABLE Membro(
    Relazione TipoRelazione,
    CodiceFiscale VARCHAR(16),
    CONSTRAINT fk_Membro FOREIGN KEY(CodiceFiscale)
        REFERENCES Persona(CodiceFiscale)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT validate_codice_fiscale
        CHECK (CodiceFiscale ~ '^[A-Z]{6}[0-9]{2}[A-Z]{1}[0-9]{2}[A-Z]{1}[0-9]{3}[A-Z]{1}$')
);
