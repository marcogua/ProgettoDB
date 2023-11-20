CREATE DOMAIN TipoRelazione AS 
    VARCHAR(1000) NOT NULL CHECK(
                                VALUE = 'Fratello-Sorella' OR
                                VALUE = 'Coniuge' OR
                                VALUE = 'Figlio-Figlia' OR
                                VALUE = 'Parente' OR
                                VALUE = 'Amico')

CREATE TABLE Membro(
    Relazione TipoRelazione,
    CodiceFiscale CHAR(16),

    CONSTRAINT fk_Membro FOREIGN KEY(CodiceFiscale)
        REFERENCES Persona(CodiceFiscale)
        ON DELETE CASCADE
        ON UPDATE CASCADE
)
