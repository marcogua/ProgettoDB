--TABELLA DELLE TRANSAZIONI

CREATE TABLE transazione(
    --ID_TRANSAZIONE identifica univocamente una transazione
    id_transazione VARCHAR(22) PRIMARY KEY,
    --TIPOLOGIA_TRANSAZIONE identifica la tipologia di transazione(entrata/uscita/trasferimento)
    tipologia_transazione tipologia_transazione NOT NULL,
    --DESCRIZIONE_TRANSAZIONE descrive la transazione
    descrizione_transazione VARCHAR(255),
    --DATA_TRANSAZIONE data della transazione
    data_transazione DATE NOT NULL,
    --CATEGORIA_TRASAZIONE identifica la vategoria della transazione(svago/tasse/affitto)
    categoria_transazione categoria_transazione,
    --VALORE identifica l'importo della transazione
    importo DECIMAL NOT NULL,
    id_conto INT NOT NULL,
    CONSTRAINT FK_id_conto FOREIGN KEY(id_conto)
        REFERENCES conto(id_conto)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

--TRIGGER PER SETTARE IN AUTOMATICO LA CHIAVE PRIMARIA
CREATE OR REPLACE FUNCTION TransazionePK()
    RETURNS TRIGGER
AS $$
DECLARE
    pk Transazione.id_transazione%TYPE;
BEGIN
    SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(CAST(CURRENT_TIMESTAMP AS VARCHAR), '-', ''), ' ', ''), ':', ''), '.', ''), '+', '') INTO pk;
    NEW.id_transazione := pk;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER TransazionePK
BEFORE INSERT
ON transazione
FOR EACH ROW
EXECUTE PROCEDURE TransazionePK();
 